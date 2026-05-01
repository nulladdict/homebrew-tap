class Plannotator < Formula
  desc "Interactive plan and code review for AI coding agents"
  homepage "https://plannotator.ai/"
  url "https://github.com/backnotprop/plannotator/releases/download/v0.19.5/plannotator-darwin-arm64",
      using: :nounzip
  version "0.19.5"
  sha256 "ca4b6662788a8af85a6cd0828d338ee962b46cb9f3833062672e87106a8caca2"
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
