class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.32.0",
      revision: "edd1d458902d64e51e17b83514e1fc693c248259"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f40b1246c5c65e4590525e8e6b43b307fd96290ce809b7c0b8ee7c6c8eea1da2"
    sha256 cellar: :any_skip_relocation, big_sur:       "472c853214015ca234f9142f8fe3718b142f099867ed3fe0e82532eb2d16f778"
    sha256 cellar: :any_skip_relocation, catalina:      "29cbefa29462dbd923d4945669ce2843947d3a91ebe41d2c431efb1be9e439e8"
    sha256 cellar: :any_skip_relocation, mojave:        "3f6a6d0eedf93ddaa16af6bb574a680da130d2e43a376683408487d16b7eeefe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dba3877c157aa4b9d099777aa4f2b76306caf2eb8fc6aac1512de43cc008c8db" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "out/skaffold"
    output = Utils.safe_popen_read("#{bin}/skaffold", "completion", "bash")
    (bash_completion/"skaffold").write output
    output = Utils.safe_popen_read("#{bin}/skaffold", "completion", "zsh")
    (zsh_completion/"_skaffold").write output
  end

  test do
    (testpath/"Dockerfile").write "FROM scratch"
    output = shell_output("#{bin}/skaffold init --analyze").chomp
    assert_equal '{"builders":[{"name":"Docker","payload":{"path":"Dockerfile"}}]}', output
  end
end
