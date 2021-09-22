class Hblock < Formula
  desc "Adblocker that creates a hosts file from multiple sources"
  homepage "https://hblock.molinero.dev/"
  url "https://github.com/hectorm/hblock/archive/v3.2.3.tar.gz"
  sha256 "1b8eb3c5cb074cbe7b0a8b5e040641c12b519bee21a4a879e1bdd328cd17aa60"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "037c4b5c2edbe84e50273a03f752ca6a71ee0a5612307177c5695cfa68eef8b7" # linuxbrew-core
  end

  uses_from_macos "curl"

  def install
    system "make", "install", "prefix=#{prefix}", "bindir=#{bin}", "mandir=#{man}"
  end

  test do
    output = shell_output("#{bin}/hblock -H none -F none -S none -A none -D none -qO-")
    assert_match "Blocked domains:", output
  end
end
