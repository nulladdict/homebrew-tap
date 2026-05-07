class Plannotator < Formula
  version "0.19.10"
  sha256 "cdabc53e88b7d18a1be9058b0b64fb0e1b9ca020d3824ade9104add48613944f"
  url "https://github.com/backnotprop/plannotator/releases/download/v#{version}/plannotator-darwin-arm64",
      using: :nounzip

  desc "Interactive plan and code review for AI coding agents"
  homepage "https://plannotator.ai/"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on :macos

  def install
    bin.install "plannotator-darwin-arm64" => "plannotator"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/plannotator --help")
  end
end
