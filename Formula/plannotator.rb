class Plannotator < Formula
  version "0.19.27"
  sha256 "dca6b01595706b78de0f7ae3d96199888948756f547bcdf1dbfc9839f9bdb684"
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
