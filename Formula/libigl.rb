class Libigl < Formula
  desc "Simple C++ geometry processing library"
  homepage "https://libigl.github.io/libigl/"
  url "https://github.com/libigl/libigl/archive/v2.2.0.tar.gz"
  sha256 "b336e548d718536956e2d6958a0624bc76d50be99039454072ecdc5cf1b2ede5"

  head "https://github.com/libigl/libigl.git"

  depends_on "cmake" => [:build,:test]
  depends_on "eigen" => [:build,:test]

  def install
    args = std_cmake_args + %w[
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_INSTALL_DATAROOTDIR=lib
      -DLIBIGL_WITH_COMISO=OFF
      -DLIBIGL_WITH_EMBREE=OFF
      -DLIBIGL_WITH_OPENGL=OFF
      -DLIBIGL_WITH_OPENGL_GLFW=OFF
      -DLIBIGL_WITH_OPENGL_GLFW_IMGUI=OFF
      -DLIBIGL_WITH_PNG=OFF
      -DLIBIGL_WITH_TETGEN=OFF
      -DLIBIGL_WITH_TRIANGLE=OFF
      -DLIBIGL_WITH_PREDICATES=OFF
      -DLIBIGL_WITH_XML=OFF
      -DLIBIGL_WITH_PYTHON=OFF
    ]
    system "cmake", ".", *args
    system "make", "install"
    mv lib/"libigl", lib/"cmake"
    mv lib/"cmake/cmake", lib/"cmake/libigl"
    echo "add_definitions(-DIGL_STATIC_LIBRARY)", ">>", lib/"cmake/libigl/libigl-config.cmake"
  end

  resource("bumpy.off") do
    url "https://raw.githubusercontent.com/libigl/libigl-tutorial-data/master/bumpy.off"
    sha256 "03d8c8ab6f80616b3615d7432f6d390c4ade3e9aacc4cc65d5cb2594b3809101"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <igl/readOFF.h>
      #include <iostream>
      Eigen::MatrixXd V;
      Eigen::MatrixXi F;
      int main(int argc, char *argv[])
      {
        const char* filepath="bumpy.off";
        // Load a mesh in OFF format
        if(igl::readOFF(filepath, V, F)) { std::cout<< "OK" << std::endl; }
        else { std::cout<<"FAIL"<<std::endl; }
        return 0;
      }
    EOS
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.1...3.15)
      option(LIBIGL_USE_STATIC_LIBRARY     "Use libIGL as static librarie" ON)
      find_package(libigl REQUIRED)
      find_package(Eigen3 REQUIRED)
      add_executable(test test.cpp)
      target_link_libraries(test PUBLIC igl::core Eigen3::Eigen)
      include_directories(test PUBLIC ${EIGEN3_INCLUDE_DIR})
    EOS
    system "cmake", "-L",
           "-DCMAKE_BUILD_RPATH=#{HOMEBREW_PREFIX}/lib", "-DCMAKE_PREFIX_PATH=#{prefix}", "."
    system "cmake", "--build", ".", "-v"
    resource("bumpy.off").stage testpath
    assert_equal "OK", shell_output("./test").chomp
  end
end
