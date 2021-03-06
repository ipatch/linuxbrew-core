class Tokei < Formula
  desc "Program that allows you to count code, quickly"
  homepage "https://github.com/XAMPPRocky/tokei"
  url "https://github.com/XAMPPRocky/tokei/archive/v11.2.1.tar.gz"
  sha256 "354893da88babffe59154656ed669de06d2b04c0fe318613fb29af66b50f35bc"

  bottle do
    cellar :any_skip_relocation
    sha256 "0023434f2186b2e1fc29dc0ce0b0eebf90834c1db0994a3e186f8b7fab87276c" => :catalina
    sha256 "858b572bfb3eff1e5c5f68a5a4d99bcbf1c515e1c2191c2995c58c367488c166" => :mojave
    sha256 "19a72a404bab167c3ed801d8032b692f1d32f3baea3d5f0c1437e8eef50ac03e" => :high_sierra
    sha256 "211a6370a12d16f91b25cddd5937e68ceb4163ebdff135a9d57dd063e7b020eb" => :x86_64_linux
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", ".",
                               "--features", "all"
  end

  test do
    (testpath/"lib.rs").write <<~EOS
      #[cfg(test)]
      mod tests {
          #[test]
          fn test() {
              println!("It works!");
          }
      }
    EOS
    system bin/"tokei", "lib.rs"
  end
end
