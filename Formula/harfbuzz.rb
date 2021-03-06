class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://wiki.freedesktop.org/www/Software/HarfBuzz/"
  url "https://github.com/harfbuzz/harfbuzz/releases/download/2.6.6/harfbuzz-2.6.6.tar.xz"
  sha256 "84d0f1fb4cf4b3ee398ac20eaa608ca9f7cd90d992a44540fdcb16469bb460e5"
  revision 1

  bottle do
    cellar :any
    sha256 "bd970d1bc53e8b889a0609706d4c0571621a4a9a24f0a13c43c6fcdd481afb1a" => :catalina
    sha256 "b6c0b06cc8472250f1f57eb00976e97e235655f257351646d2e12cbb40fe4033" => :mojave
    sha256 "d4571cb7ba8503c645acb37976030b15b3a62abb259c77a8b7a43b81d25dd442" => :high_sierra
    sha256 "f59575b997346ebc1f50192754de3673c4e491f3a365109e2997bd400a4b6f97" => :x86_64_linux
  end

  head do
    url "https://github.com/behdad/harfbuzz.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "ragel" => :build
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "freetype"
  depends_on "glib"
  depends_on "graphite2"
  depends_on "icu4c"

  resource "ttf" do
    url "https://github.com/behdad/harfbuzz/raw/fc0daafab0336b847ac14682e581a8838f36a0bf/test/shaping/fonts/sha1sum/270b89df543a7e48e206a2d830c0e10e5265c630.ttf"
    sha256 "9535d35dab9e002963eef56757c46881f6b3d3b27db24eefcc80929781856c77"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-introspection=yes
      --enable-static
      --with-cairo=yes
      --with-coretext=#{OS.mac? ? "yes" : "no"}
      --with-freetype=yes
      --with-glib=yes
      --with-gobject=yes
      --with-graphite2=yes
      --with-icu=yes
    ]

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    resource("ttf").stage do
      shape = `echo 'സ്റ്റ്' | #{bin}/hb-shape 270b89df543a7e48e206a2d830c0e10e5265c630.ttf`.chomp
      assert_equal "[glyph201=0+1183|U0D4D=0+0]", shape
    end
  end
end
