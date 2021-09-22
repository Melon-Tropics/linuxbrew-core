class DjangoCompletion < Formula
  desc "Bash completion for Django"
  homepage "https://www.djangoproject.com/"
  url "https://github.com/django/django/archive/3.2.7.tar.gz"
  sha256 "f3a439d4521e9c76a828f743ee7130c95065cc05aa3fa6287708cc0919ed9fc1"
  license "BSD-3-Clause"
  head "https://github.com/django/django.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  def install
    bash_completion.install "extras/django_bash_completion" => "django"
  end

  test do
    assert_match "-F _django_completion",
      shell_output("source #{bash_completion}/django && complete -p django-admin.py")
  end
end
