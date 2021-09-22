class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/v0.17.0.tar.gz"
  sha256 "4b961a45b8ef645f4f25c5e860d7464bdb5712a7a49275a6d815f4c1194bbf60"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "81e4789fd0942dce3ceff1db1af608444280a338aebf119afe8ab38dc02f7018"
    sha256 cellar: :any_skip_relocation, big_sur:       "30461dd39544621f770b4a08b17156c39c86efa58bc933dbfeaeafef234960e7"
    sha256 cellar: :any_skip_relocation, catalina:      "c68c2e53447de0cf5faae4e34c862e2c20528d83524ccc8388cc8e2cbd7a025f"
    sha256 cellar: :any_skip_relocation, mojave:        "5df85af607c2132ff5c7ec242fe7c2d5f755c77dba7484e1e87207185e718062"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e079b0f2352a0f57312f2a58cdf0b12705823574b8156e23058d8f66c98f743" # linuxbrew-core
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_output = Utils.safe_popen_read("#{bin}/miniserve", "--print-completions", "bash")
    (bash_completion/"miniserve").write bash_output
    zsh_output = Utils.safe_popen_read("#{bin}/miniserve", "--print-completions", "zsh")
    (zsh_completion/"_miniserve").write zsh_output
    fish_output = Utils.safe_popen_read("#{bin}/miniserve", "--print-completions", "fish")
    (fish_completion/"miniserve.fish").write fish_output
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/miniserve", "#{bin}/miniserve", "-i", "127.0.0.1", "--port", port.to_s
    end

    sleep 2

    begin
      read = (bin/"miniserve").read
      assert_equal read, shell_output("curl localhost:#{port}")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
