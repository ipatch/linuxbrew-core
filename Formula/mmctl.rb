class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      :tag      => "v5.23",
      :revision => "87f989f74d0ac874e4038d47b77b3fd65f53bba4"
  head "https://github.com/mattermost/mmctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0199ecc1ec2a6314704801f67b254bc684e2eb08a25b42bdd2f28ca1dc6144e3" => :catalina
    sha256 "ce69eac322b02b6018e807f6a654a41c9c1d7401e91700bcaa02063c98edb396" => :mojave
    sha256 "a2b0ea5a63c92a6b005c5cc7aa99eec5275294675ec03d80976493f4153aa9b7" => :high_sierra
    sha256 "0d3e82500c6c9b9da5ea53d1b7fb3f482b80d742f311ff27f30378dc79534492" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOBIN"] = buildpath/bin
    ENV["ADVANCED_VET"] = "FALSE"
    ENV["BUILD_HASH"] = Utils.popen_read("git rev-parse HEAD").chomp
    ENV["BUILD_VERSION"] = version.to_s
    (buildpath/"src/github.com/mattermost/mmctl").install buildpath.children
    cd "src/github.com/mattermost/mmctl" do
      system "make", "install"

      # Install the zsh and bash completions
      output = Utils.popen_read("#{bin}/mmctl completion bash")
      (bash_completion/"mmctl").write output
      output = Utils.popen_read("#{bin}/mmctl completion zsh")
      (zsh_completion/"_mmctl").write output
    end
  end

  test do
    output = pipe_output("#{bin}/mmctl help 2>&1")
    assert_no_match /.*No such file or directory.*/, output
    assert_no_match /.*command not found.*/, output
    assert_match /.*mmctl \[command\].*/, output
  end
end
