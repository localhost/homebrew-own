require 'formula'

class Opencv < Formula
  homepage 'http://opencv.org/'
  url 'https://github.com/Itseez/opencv/archive/2.4.6.2.tar.gz'
  sha1 'e599c984eabd16730df7f4ecfd7cd3778784e685'

  option '32-bit'
  option 'with-qt',  'Build the Qt4 backend to HighGUI'
  option 'with-tbb', 'Enable parallel code in OpenCV using Intel TBB'
  option 'with-opencl', 'Enable gpu code in OpenCV using OpenCL'

  depends_on 'cmake'   => :build
  depends_on 'pkg-config' => :build
  depends_on 'numpy'   => :python

  depends_on 'python'  => :optional
  depends_on 'eigen'   => :optional
  depends_on 'libtiff' => :optional
  depends_on 'jasper'  => :optional
  depends_on 'tbb'     => :optional
  depends_on 'qt'      => :optional
  depends_on :libpng

  # Can also depend on ffmpeg, but this pulls in a lot of extra stuff that
  # you don't need unless you're doing video analysis, and some of it isn't
  # in Homebrew anyway. Will depend on openexr if it's installed.
  depends_on 'ffmpeg'  => [:build, :optional]

  def install
    args = std_cmake_args + %w[
      -DCMAKE_OSX_DEPLOYMENT_TARGET=
      -DWITH_CUDA=OFF
      -DBUILD_ZLIB=OFF
      -DBUILD_TIFF=OFF
      -DBUILD_PNG=OFF
      -DBUILD_JPEG=OFF
      -DBUILD_JASPER=OFF
      -DBUILD_TESTS=OFF
      -DBUILD_PERF_TESTS=OFF
    ]
    if build.build_32_bit?
      args << "-DCMAKE_OSX_ARCHITECTURES=i386"
      args << "-DOPENCV_EXTRA_C_FLAGS='-arch i386 -m32'"
      args << "-DOPENCV_EXTRA_CXX_FLAGS='-arch i386 -m32'"
    end
    args << '-DWITH_QT=ON' if build.with? 'qt'
    args << '-DWITH_TBB=ON' if build.with? 'tbb'
    # OpenCL 1.1 is required, but Snow Leopard and older come with 1.0
    args << '-DWITH_OPENCL=OFF' if build.without? 'opencl' or MacOS.version < :lion
    if build.with? 'python'
      args << "-DPYTHON_INCLUDE_DIR='#{python.incdir}'"
      args << "-DPYTHON_LIBRARY='#{python.libdir}/lib#{python.xy}.dylib'"
      args << "-DPYTHON_EXECUTABLE='#{python.binary}'"
    else
      args << "-DWITH_PYTHON=OFF"
    end
    args << '-DWITH_FFMPEG=OFF' unless build.with? 'ffmpeg'

    args << '..'
    mkdir 'macbuild' do
      system 'cmake', *args
      system "make"
      system "make install"
    end
  end

  def caveats
    python.standard_caveats if python
  end
end
