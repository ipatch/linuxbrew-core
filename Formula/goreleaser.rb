class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.137.0",
      :revision => "da787478753c06aa6137c1cf0ed05699f193b198"

  bottle do
    cellar :any_skip_relocation
    sha256 "072c18f9ee9dae5a1f7d731461445de754aa691702e92787efdf6702a73a0cf6" => :catalina
    sha256 "8d53be532a037002360e3112ac6b201d4c6a8bb0d8f4850b531792a01e037933" => :mojave
    sha256 "9e6939dc494c933662d7171958c23c2f321a1e64292e23404de59dda6cb7140f" => :high_sierra
    sha256 "d414e9dc3de5c521507692f1e99924c6fbcbfefb88e19529364530d70987fb04" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X main.version=#{version} -X main.commit=#{stable.specs[:revision]} -X main.builtBy=homebrew",
             *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
