cask "brave-origin@nightly" do
  version "1.93.2"
  sha256 "d68bdc49544569442742b0b284626af6c9893828ecbe5047ed1169558b4bfda8"
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
