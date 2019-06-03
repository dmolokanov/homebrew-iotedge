# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Iotedge < Formula
  desc ""
  homepage ""
  url "https://raw.githubusercontent.com/dmolokanov/iotedge-releases/master/iotedge-1.0.8-rc1.tar.gz"
  sha256 "9e37afe1b7be306857c596a5e3ebc8c1e1d00bfcd9507443a79f023efeb0dafd"
  # depends_on "git" => :build
  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "openssl"

  def install
    # # ENV.deparallelize  # if your formula fails when building in parallel

    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl"].opt_prefix
    ENV["FORCE_NO_UNITTEST"] = "ON"
    # ENV["LIBIOTHSM_NOBUILD"] = "ON" # it'll cause cargo linker to use whatever libs were built before

    Dir.chdir("edgelet")
    system "make", "release"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test iotedge`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
