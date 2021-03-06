class Bup < Formula
  desc "Backup tool"
  homepage "https://bup.github.io/"
  url "https://github.com/bup/bup/archive/0.30.1.tar.gz"
  sha256 "11cfc63525a27559462116ed583874c9624e8c65027d0c8f9700a8afc77691e6"
  head "https://github.com/bup/bup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b3fdc5a3246004c995fe3df6036b1591999a9678f9e54b851cbdbd3a7a1824d4" => :catalina
    sha256 "0aae81e8b0b51bfd243ea1cc40d540042ba8b9431473c9c916c8d34a168c3f92" => :mojave
    sha256 "4616a9f3da047dd34aada7cbc9536f007aa4be01f0529abcb24e1ac4dba3fcc1" => :high_sierra
  end

  depends_on "pandoc" => :build
  depends_on :macos # Due to Python 2
  depends_on :macos # Due to Python 2

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/b8/e2/a3a86a67c3fc8249ed305fc7b7d290ebe5e4d46ad45573884761ef4dea7b/certifi-2020.4.5.1.tar.gz"
    sha256 "51fcb31174be6e6664c5f69e3e1691a2d72a1a12e90f872cbdb1567eb47b6519"
  end

  resource "singledispatch" do
    url "https://files.pythonhosted.org/packages/d9/e9/513ad8dc17210db12cb14f2d4d190d618fb87dd38814203ea71c87ba5b68/singledispatch-3.4.0.3.tar.gz"
    sha256 "5b06af87df13818d14f08a028e42f566640aef80805c3b50c5056b086e3c2b9c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/95/84/119a46d494f008969bf0c775cb2c6b3579d3c4cc1bb1b41a022aa93ee242/tornado-6.0.4.tar.gz"
    sha256 "0fe2d45ba43b00a41cd73f8be321a44936dc1aba233dee979f17a042b83eb6dc"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    if OS.mac?
      # set AC_CPP_PROG due to Mojave issue, see https://github.com/Homebrew/brew/issues/5153
      system "make", "AC_CPP_PROG=xcrun cpp"
    else
      system "./configure"
      system "make"
    end
    system "make", "install", "DESTDIR=#{prefix}", "PREFIX="

    mv bin/"bup", libexec/"bup.py"
    (bin/"bup").write_env_script libexec/"bup.py", :PYTHONPATH => ENV["PYTHONPATH"]
  end

  test do
    system bin/"bup", "init"
    assert_predicate testpath/".bup", :exist?
  end
end
