class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2020/sqlite-src-3320100.zip"
  version "3.32.1"
  sha256 "5ccc7dd634ab820dbcef56318279d27ee945ccaba17e70d4932e5c624a7872d0"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf45bae7a867b985bae690cec09c87f511fa06b86c4b197d574b24e3e61bf196" => :catalina
    sha256 "c1fb02b6350f3de195069700022276a6374ed805f3f573782b3dfc457c276cb6" => :mojave
    sha256 "0470d4c41cb459d1e9d8bf4e8d84c238015b5dc5e3a0432129ddbbba42ea1b25" => :high_sierra
    sha256 "36d4606275f45d34aac4aaeefc793a6dcb9bca195a60bf697b99f04e569017ed" => :x86_64_linux
  end

  uses_from_macos "tcl-tk" => :build
  uses_from_macos "sqlite" => :test

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "sqldiff"
    bin.install "sqldiff"
  end

  test do
    dbpath = testpath/"test.sqlite"
    sqlpath = testpath/"test.sql"
    sqlite = OS.mac? ? "/usr/bin/sqlite3" : Formula["sqlite"].bin/"sqlite3"
    sqlpath.write "create table test (name text);"
    system "#{sqlite} #{dbpath} < #{sqlpath}"
    assert_equal "test: 0 changes, 0 inserts, 0 deletes, 0 unchanged",
                 shell_output("#{bin}/sqldiff --summary #{dbpath} #{dbpath}").strip
  end
end
