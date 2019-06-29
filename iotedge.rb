class Iotedge < Formula
  desc "Azure IoT Edge is an Internet of Things (IoT) service that builds on top of IoT Hub."
  homepage "https://docs.microsoft.com/en-us/azure/iot-edge/"
  url "https://raw.githubusercontent.com/dmolokanov/iotedge-releases/master/iotedge-1.0.8-rc2.tar.gz"
  sha256 "4caabc955b12d95123bf8df53eac7d473ac9f19f0fe0a63864aca8fcc0410287"
  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "openssl"
  
  def install
    # ensure that the `openssl` crate picks up the intended library
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl"].opt_prefix
    ENV["OPENSSL_ROOT_DIR"] = Formula["openssl"].opt_prefix

    # prevent build and run unit tests for C code
    ENV["FORCE_NO_UNITTEST"] = "ON"

    # prevent update submodules for git archive 
    ENV["FORCE_NO_SUBMODULES_UPDATE"] = "ON"
  
    # build edgelet
    Dir.chdir("edgelet")
    system "make", "release"

    # move files to appropriate locations
    bin.install "target/release/iotedged"
    bin.install "target/release/iotedge"
    lib.install Dir["target/release/build/hsm-sys*/out/lib/*.dylib"]
    etc.install "contrib/config/linux/config.yaml" # TODO change to macos config
    # TODO logrotate
    # TODO prepare to run as a service
    man1.install "contrib/man/man1/iotedge.1"
    man8.install "contrib/man/man8/iotedged.8"
    doc.install "contrib/docs/LICENSE"
    doc.install "contrib/docs/ThirdPartyNotices"
    doc.install "contrib/docs/trademark"
  end

  test do
    system "iotedged", "-V"
    system "iotedge", "-V"
  end
end
