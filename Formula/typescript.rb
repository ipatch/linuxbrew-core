require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-3.9.3.tgz"
  sha256 "5283860b4f5fe40dd9d508fc1759db4b61a19ce96c7be6cc66044c5b74469677"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ff32cd1c1b3cdfa5599613b3f161d50ffc953850eb6e8ccbc22a905f6f0b701d" => :catalina
    sha256 "e5e8c552f1ae46f1a2dc98bcd8eeecd69f677f7d127deb51e38b9e317eced4af" => :mojave
    sha256 "1c522f2cac514069086d097bcdb80a5902696961a56b9781ed2a9133ede72825" => :high_sierra
    sha256 "e757e928f39cfd932634c2b7b7710dec93c8d26092822052090a56dc4da54a86" => :x86_64_linux
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.ts").write <<~EOS
      class Test {
        greet() {
          return "Hello, world!";
        }
      };
      var test = new Test();
      document.body.innerHTML = test.greet();
    EOS

    system bin/"tsc", "test.ts"
    assert_predicate testpath/"test.js", :exist?, "test.js was not generated"
  end
end
