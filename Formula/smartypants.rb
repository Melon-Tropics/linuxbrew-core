class Smartypants < Formula
  desc "Typography prettifier"
  homepage "https://daringfireball.net/projects/smartypants/"
  url "https://daringfireball.net/projects/downloads/SmartyPants_1.5.1.zip"
  sha256 "2813a12d8dd23f091399195edd7965e130103e439e2a14f298b75b253616d531"

  livecheck do
    url :homepage
    regex(/href=.*?SmartyPants[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0a2ba46d5d61456e25f9844222df5afdc0844c33913d598d29e4e73216714df9" # linuxbrew-core
  end

  def install
    bin.install "SmartyPants.pl" => "smartypants"
  end

  test do
    assert_equal "&#8220;Give me a beer&#8221;, said Mike O&#8217;Connor",
      pipe_output("#{bin}/smartypants",
                  %q("Give me a beer", said Mike O'Connor), 0)
  end
end
