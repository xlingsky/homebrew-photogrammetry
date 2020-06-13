# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class SiftGPU < Formula
  desc "A fork repo for SiftGPU from Changchang Wu"
  homepage "http://ccwu.me"
  url "https://github.com/xlingsky/SiftGPU/archive/v1.0.tar.gz"
  sha256 "218bea69cf677af46a36357430577eea65a09585d19e920b66691a68c9d65873"

  depends_on "cmake" => :build

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    system "cmake", ".", *std_cmake_args
    system "make", "install" # if this fails, try separate make/make install steps
  end

  resource("640-1.jpg") do
    url "https://github.com/xlingsky/SiftGPU/blob/master/data/640-1.jpg"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test SiftGPU`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    resource("640-1.jpg").stage do
      assert_match "OK", shell_output("#{bin}/SimpleSIFT 640-1.jpg")
    end
  end
end
