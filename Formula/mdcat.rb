class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/lunaryorn/mdcat"
  url "https://github.com/lunaryorn/mdcat/archive/mdcat-0.16.1.tar.gz"
  sha256 "276a0cf7177baccfef006dc0985bf9008a9e18a9a4f93659b9385ec5c4190569"

  bottle do
    cellar :any_skip_relocation
    sha256 "b0ca453fe41c335d0f07c2f77bc27578051adc08c0a54aedbccc4516a4496a7b" => :catalina
    sha256 "7e4f234b6836d28d1f5b9c6343f9d9941f0035a7af1b2ba0ef35472353503d8f" => :mojave
    sha256 "751902ce6d2ecf346ffef9498a3f272abc0800cc1f4f2b97d8981eac409052ca" => :high_sierra
    sha256 "052a9dc5a656eb4a2f98e72c23e6ebec802c7008fbe69bb8eab4d82d9cf4d5c5" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  unless OS.mac?
    depends_on "llvm" => :build
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    (testpath/"test.md").write <<~EOS
      _lorem_ **ipsum** dolor **sit** _amet_
    EOS
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end
