#!/usr/bin/env -S uv run

import re
from http.client import HTTPResponse
from pathlib import Path
from typing import cast
from urllib.request import urlopen

from pydantic import BaseModel


class Release(BaseModel):
    tag_name: str


def http_get(url: str) -> str:
    response = cast("HTTPResponse", urlopen(url, timeout=30))
    with response:
        body = response.read()
        charset = response.headers.get_content_charset() or "utf-8"
        return body.decode(charset)


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
        latest = http_get(livecheck_url.group(1)).strip()
    else:
        repo_match = re.search(r"github\.com/([^/]+/[^/]+)/", url)
        assert repo_match is not None
        response_text = http_get(
            f"https://api.github.com/repos/{repo_match.group(1)}/releases/latest"
        )
        latest = Release.model_validate_json(response_text).tag_name.removeprefix("v")

    if latest == current:
        print(f"{path}: current ({current})")
        continue

    new_url = url.replace("#{version}", latest).replace(current, latest)
    sha_text = http_get(f"{new_url}.sha256")
    sha_match = re.match(r"\s*([a-fA-F0-9]{64})\b", sha_text)
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
