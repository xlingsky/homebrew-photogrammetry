class Siftgpu < Formula
  desc "GPU version SIFT from Changchang Wu"
  homepage "http://ccwu.me"
  url "https://github.com/xlingsky/SiftGPU/archive/v1.2.tar.gz"
  sha256 "4281f6930424562f27b525ceec85b01d337dc298387ebfdd24181533e439e16c"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  head do
    url "https://github.com/xlingsky/SiftGPU.git"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <SiftGPU.h>
      int main(int argc, char* argv[]) {
        SiftGPU  *sift = new SiftGPU; 
        if(sift->CreateContextGL() != SiftGPU::SIFTGPU_FULL_SUPPORTED) return 1;
        sift->DestroyContextGL();
        delete sift;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-L#{lib}", "-lsiftgpu"
    system "./test"
  end
end
