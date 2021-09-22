require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-9.18.0.tgz"
  sha256 "c3796bb057aefddc5f9f3e55d939437ed4495640573d5e7a39739063a59f989d"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256                               arm64_big_sur: "7205c67d9fd3add5933360d1108bc409a8f3abd772c1b020af39b57d20b2717c"
    sha256 cellar: :any_skip_relocation, big_sur:       "93cce1972c68e5f377219ebef6ac23fc13de0e375acc791ef51d3c598346e4bb"
    sha256 cellar: :any_skip_relocation, catalina:      "93cce1972c68e5f377219ebef6ac23fc13de0e375acc791ef51d3c598346e4bb"
    sha256 cellar: :any_skip_relocation, mojave:        "93cce1972c68e5f377219ebef6ac23fc13de0e375acc791ef51d3c598346e4bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1070f7216514e5b98317f0da98caaefffbcccad4c3881f2ef99a8d7a31c7dd6f" # linuxbrew-core
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    term_size_vendor_dir = libexec/"lib/node_modules/firebase-tools/node_modules/term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries

    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir
    end
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/firebase login:ci --no-localhost
      expect "Paste"
    EOS
    assert_match "authorization code", shell_output("expect -f test.exp")
  end
end
