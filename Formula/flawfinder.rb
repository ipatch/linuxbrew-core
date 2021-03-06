class Flawfinder < Formula
  desc "Examines code and reports possible security weaknesses"
  homepage "https://www.dwheeler.com/flawfinder/"
  url "https://www.dwheeler.com/flawfinder/flawfinder-2.0.11.tar.gz"
  sha256 "9b4929fca5c6703880d95f201e470b7f19262ff63e991b3ac4ea3257f712f5ec"
  head "https://git.code.sf.net/p/flawfinder/code.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a790a4d58403cf16cdba7c243621ddfc5f7b20e47d786d8aceb08598803d2264" => :catalina
    sha256 "a790a4d58403cf16cdba7c243621ddfc5f7b20e47d786d8aceb08598803d2264" => :mojave
    sha256 "a790a4d58403cf16cdba7c243621ddfc5f7b20e47d786d8aceb08598803d2264" => :high_sierra
    sha256 "78cf1146820ce854bc782c57421e3d596bd5d4208022a7f9682aee982ff691ea" => :x86_64_linux
  end

  depends_on "python@3.8" unless OS.mac?

  resource "flaws" do
    url "https://www.dwheeler.com/flawfinder/test.c"
    sha256 "4a9687a091b87eed864d3e35a864146a85a3467eb2ae0800a72e330496f0aec3"
  end

  def install
    inreplace "flawfinder", "#!/usr/bin/env python", "#!#{Formula["python@3.8"].opt_bin/"python3"}" unless OS.mac?
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    resource("flaws").stage do
      assert_match "Hits = 36",
                   shell_output("#{bin}/flawfinder test.c")
    end
  end
end
