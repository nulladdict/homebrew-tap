class Plannotator < Formula
  version "0.19.18"
  sha256 "8e7aac0d2224afe33d12e80b3c1f2d058e5c0ada26ef69289fd67217c50035f1"
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
