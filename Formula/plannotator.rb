class Plannotator < Formula
  version "0.19.11"
  sha256 "e96e194bc781f602b410f05b345ebc09c2a55ee560c440923cca932f673c85a3"
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
