cask "brave-origin@nightly" do
  version "1.92.4"
  sha256 "1d37e0cc107d93259fe199dad185da09e0b94b18a692da1f97e88243c17a9c09"

  url "https://github.com/brave/brave-browser/releases/download/v#{version}/Brave-Origin-Nightly-arm64.dmg",
      verified: "github.com/brave/brave-browser/"
  name "Brave Origin Nightly"
  desc "Privacy-focused web browser with non-essential Brave features removed"
  homepage "https://brave.com/origin/download-nightly/"

  livecheck do
    url "https://versions.brave.com/latest/origin-nightly-macos-arm64.version"
    strategy :page_match, &:strip
  end

  auto_updates true
  depends_on macos: ">= :monterey"
  depends_on arch: :arm64

  app "Brave Origin Nightly.app"

  zap trash: [
        "~/Library/Application Support/BraveSoftware/Brave-Origin-Nightly",
        "~/Library/Caches/BraveSoftware/Brave-Origin-Nightly",
        "~/Library/Caches/com.brave.Browser.origin.nightly",
        "~/Library/HTTPStorages/com.brave.Browser.origin.nightly",
        "~/Library/Preferences/com.brave.Browser.origin.nightly.plist",
        "~/Library/Saved Application State/com.brave.Browser.origin.nightly.savedState",
      ],
      rmdir: [
        "~/Library/Application Support/BraveSoftware",
        "~/Library/Caches/BraveSoftware",
      ]
end
