class Tundra < Formula
  desc "Code build system that tries to be fast for incremental builds"
  homepage "https://github.com/deplinenoise/tundra"
  url "https://github.com/deplinenoise/tundra/archive/v2.14.tar.gz"
  sha256 "db3d4b13820373a038a08b8751376e3ecdf49355f329a7909cd2f836372dffe1"

  bottle do
    cellar :any_skip_relocation
    sha256 "bafe878e5e83d8edb27eac2b645afd1898045c50d50d169a65398a31a7c23baf" => :catalina
    sha256 "3f22d2d8ee09acdb42cb4c9c6b0a87496696999ee0ce95c26842d0200f26d356" => :mojave
    sha256 "37c6abc51fbabc29bed3c7e7dbb7d7264d0113f98470ce8a82449227da172433" => :high_sierra
    sha256 "d5786d31b88755395ba0c2119d023cc2df4dd8c801944c1a0af5e9d8f01db4b8" => :x86_64_linux
  end

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.10.0.tar.gz"
    sha256 "9dc9157a9a1551ec7a7e43daea9a694a0bb5fb8bec81235d8a1e6ef64c716dcb"
  end

  def install
    (buildpath/"unittest/googletest").install resource("gtest")
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~'EOS'
      #include <stdio.h>
      int main() {
        printf("Hello World\n");
        return 0;
      }
    EOS
    if OS.mac?
      (testpath/"tundra.lua").write <<~'EOS'
        Build {
          Units = function()
            local test = Program {
              Name = "test",
              Sources = { "test.c" },
            }
            Default(test)
          end,
          Configs = {
            {
              Name = "macosx-clang",
              DefaultOnHost = "macosx",
              Tools = { "clang-osx" },
            },
          },
        }
      EOS
    else
      (testpath/"tundra.lua").write <<~'EOS'
        Build {
          Units = function()
            local test = Program {
              Name = "test",
              Sources = { "test.c" },
            }
            Default(test)
          end,
          Configs = {
            {
              Name = "linux-gcc",
              DefaultOnHost = "linux",
              Tools = { "gcc" },
            },
          },
        }
      EOS
    end
    system bin/"tundra2"
    if OS.mac?
      system "./t2-output/macosx-clang-debug-default/test"
    else
      system "./t2-output/linux-gcc-debug-default/test"
    end
  end
end
