#!/usr/bin/env -S uv run

import re
from pathlib import Path

import httpx
from pydantic import BaseModel


class Release(BaseModel):
    tag_name: str


for path in sorted((*Path("Formula").glob("*.rb"), *Path("Casks").glob("*.rb"))):
    text = path.read_text()

    version_match = re.search(r'^\s*version "([^"]+)"', text, re.M)
    url_match = re.search(r'^\s*url "([^"]+)"', text, re.M)
    livecheck_match = re.search(r"livecheck do(.*?)end", text, re.S)
    assert version_match is not None
    assert url_match is not None
    assert livecheck_match is not None

    current = version_match.group(1)
    url = url_match.group(1)
    livecheck = livecheck_match.group(1)
    livecheck_url = re.search(r'url "([^"]+)"', livecheck)

    if livecheck_url:
        response = httpx.get(livecheck_url.group(1)).raise_for_status()
        latest = response.text.strip()
    else:
        repo_match = re.search(r"github\.com/([^/]+/[^/]+)/", url)
        assert repo_match is not None
        response = httpx.get(
            f"https://api.github.com/repos/{repo_match.group(1)}/releases/latest"
        ).raise_for_status()
        latest = Release.model_validate_json(response.text).tag_name.removeprefix("v")

    if latest == current:
        print(f"{path}: current ({current})")
        continue

    new_url = url.replace("#{version}", latest).replace(current, latest)
    response = httpx.get(f"{new_url}.sha256").raise_for_status()
    sha_match = re.match(r"\s*([a-fA-F0-9]{64})\b", response.text)
    assert sha_match is not None

    new = text.replace(current, latest)
    new = re.sub(
        r'^(\s*sha256 ")[a-fA-F0-9]{64}(".*)$',
        rf"\g<1>{sha_match.group(1).lower()}\2",
        new,
        count=1,
        flags=re.M,
    )
    _ = path.write_text(new)
    print(f"{path}: {current} -> {latest}")
