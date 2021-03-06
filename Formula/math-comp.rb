class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/mathcomp-1.10.0.tar.gz"
  sha256 "3f8a88417f3456da05e2755ea0510c1bd3fd13b13c41e62fbaa3de06be040166"
  revision 4
  head "https://github.com/math-comp/math-comp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ff7b69b229ea703aa2641f258fbdcfec6e077d7c845f9d848f5e7514c261a7e" => :catalina
    sha256 "74f6dc81e536f3f98306b3d8bffde87f88de4bbba8ece8a0ec2b6ca0169c01cb" => :mojave
    sha256 "517cef20c34b7b69635924ef61b38a9e8aa230874b1357d3b6e4e271a5b4fdd1" => :high_sierra
    sha256 "aece26d62ea12b3a53342664f0a691a0474b7bdedca77e483fdab102b76c3777" => :x86_64_linux
  end

  depends_on "ocaml" => :build
  depends_on "coq"

  def install
    coqlib = "#{lib}/coq/"

    (buildpath/"mathcomp/Makefile.coq.local").write <<~EOS
      COQLIB=#{coqlib}
    EOS

    cd "mathcomp" do
      system "make", "Makefile.coq"
      system "make", "-f", "Makefile.coq", "MAKEFLAGS=#{ENV["MAKEFLAGS"]}"
      system "make", "install", "MAKEFLAGS=#{ENV["MAKEFLAGS"]}"

      elisp.install "ssreflect/pg-ssr.el"
    end

    doc.install Dir["docs/*"]
  end

  test do
    (testpath/"testing.v").write <<~EOS
      From mathcomp Require Import ssreflect seq.

      Parameter T: Type.
      Theorem test (s1 s2: seq T): size (s1 ++ s2) = size s1 + size s2.
      Proof. by elim : s1 =>//= x s1 ->. Qed.

      Check test.
    EOS

    coqc = Formula["coq"].opt_bin/"coqc"
    cmd = "#{coqc} -R #{lib}/coq/user-contrib/mathcomp mathcomp testing.v"
    assert_match /\Atest\s+: forall/, shell_output(cmd)
  end
end
