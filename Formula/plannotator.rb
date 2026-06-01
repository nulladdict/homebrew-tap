class Plannotator < Formula
  version "0.19.26"
  sha256 "721680c7bb62bc7466f691c2666d4196d87ce12fbbb1875bfada7f6aa74ae473"
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
