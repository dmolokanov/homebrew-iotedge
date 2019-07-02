class Iotedge < Formula
  desc "Azure IoT Edge is an Internet of Things (IoT) service that builds on top of IoT Hub."
  homepage "https://docs.microsoft.com/en-us/azure/iot-edge/"
  url "https://github.com/dmolokanov/iotedge.git", 
    :using => :git,
    :revision => "a47489b08ccb0e21a0ddf879ed073cce6e568288"
  head "https://github.com/Azure/iotedge.git" 
  version "1.8.0-rc3"
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
    (etc/name).install "contrib/config/macos/config.yaml"
    man1.install "contrib/man/man1/iotedge.1"
    man8.install "contrib/man/man8/iotedged.8"
    doc.install "contrib/docs/LICENSE"
    doc.install "contrib/docs/ThirdPartyNotices"
    doc.install "contrib/docs/trademark"
  end

  def post_install
    (var/name).mkpath
  end

  test do
    system "iotedged", "-V"
    system "iotedge", "-V"
  end
end
