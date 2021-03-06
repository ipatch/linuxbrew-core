require "language/haskell"

class Mighttpd2 < Formula
  include Language::Haskell::Cabal

  desc "HTTP server"
  homepage "https://www.mew.org/~kazu/proj/mighttpd/en/"
  url "https://hackage.haskell.org/package/mighttpd2-3.4.6/mighttpd2-3.4.6.tar.gz"
  sha256 "fe14264ea0e45281591c86030cad2b349480f16540ad1d9e3a29657ddf62e471"

  bottle do
    rebuild 1
    sha256 "3deac246044c856f3b85c98ad7de72f3da58078a4a8fb1f8b621a3d0ac4ddf93" => :catalina
    sha256 "c0ead6b222cc7564253a15ce33a4db37e4b08a3e65d9a035e901c76484b2f8f3" => :mojave
    sha256 "e583e8b97857ae8cd8c545355e4f2f257584ada8c678a534096277b3ac323de4" => :high_sierra
    sha256 "92ceeab85d461b14aa77035c00402160dd394e7ae68d8b91059733c307e581c7" => :x86_64_linux
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build

  uses_from_macos "zlib"

  def install
    install_cabal_package
  end

  test do
    system "#{bin}/mighty-mkindex"
    assert (testpath/"index.html").file?
  end
end
