class Ormolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/tweag/ormolu"
  url "https://github.com/tweag/ormolu/archive/0.3.0.0.tar.gz"
  sha256 "710ae7d57ff5cbb6589a4b068f4157a20bc119bc0eecb40d2c8d0efd9877bce9"
  license "BSD-3-Clause"
  head "https://github.com/tweag/ormolu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "20985d0d7f3ecdc40e4e446237dd00beee5549586c31b8e5397d30a63e57a1c0"
    sha256 cellar: :any_skip_relocation, big_sur:       "366b87413d6e300e9d089f35e550ca02db32156a837ebd7549bdf83d1188c170"
    sha256 cellar: :any_skip_relocation, catalina:      "bd06fd5e6eb8b540a95bd9e857701f4b4eedd66239c780d9fe5aa01f83517dc4"
    sha256 cellar: :any_skip_relocation, mojave:        "0963f25611342146a3435f4f65610c1a29441ba94ad52670a2a4baa47ff6da56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3a5e8d85fdf38ad734ec9b3bba18afe8fa30b2004830ed9e4ef3d23fff3a2ce" # linuxbrew-core
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"test.hs").write <<~EOS
      foo =
        f1
        p1
        p2 p3

      foo' =
        f2 p1
        p2
        p3

      foo'' =
        f3 p1 p2
        p3
    EOS
    expected = <<~EOS
      foo =
        f1
          p1
          p2
          p3

      foo' =
        f2
          p1
          p2
          p3

      foo'' =
        f3
          p1
          p2
          p3
    EOS
    assert_equal expected, shell_output("#{bin}/ormolu test.hs")
  end
end
