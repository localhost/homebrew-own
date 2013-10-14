require 'formula'

class Opencv < Formula
  homepage 'http://opencv.org/'
  url 'https://github.com/Itseez/opencv/archive/2.4.6.2.tar.gz'
  sha1 'e599c984eabd16730df7f4ecfd7cd3778784e685'

  env :std # otherwise superenv removes our build flags

  option '32-bit'
  option 'with-qt',  'Build the Qt4 backend to HighGUI'
  option 'with-tbb', 'Enable parallel code in OpenCV using Intel TBB'
  option 'with-opencl', 'Enable gpu code in OpenCV using OpenCL'
  option 'with-c++11', 'Compile using Clang, std=c++11 and stdlib=libc++' if MacOS.version >= :lion

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

  def install
    args = std_cmake_args + %w[
      -DCMAKE_OSX_DEPLOYMENT_TARGET=
      -DWITH_CUDA=OFF
      -DWITH_OPENEXR=OFF
      -DBUILD_OPENEXR=OFF
      -DBUILD_ZLIB=OFF
      -DBUILD_TIFF=OFF
      -DBUILD_PNG=OFF
      -DBUILD_JPEG=OFF
      -DBUILD_JASPER=OFF
      -DWITH_FFMPEG=OFF
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

    if build.with? 'c++11' and MacOS.version >= :lion
      args << "-DCMAKE_C_COMPILER=cc"
      args << "-DCMAKE_CXX_COMPILER=c++"
      args << "-DCMAKE_CXX_FLAGS='-std=c++11 -stdlib=libc++ -Wno-c++11-narrowing'"
    end

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

  def patches
    # fix the error in 'dpstereo.cpp': multiple unsequenced modifications to 'temp3' [-Werror,-Wunsequenced]
    DATA
  end

end

__END__
diff --git a/modules/legacy/src/dpstereo.cpp b/modules/legacy/src/dpstereo.cpp
index a55e1ca..dd7e642 100644
--- a/modules/legacy/src/dpstereo.cpp
+++ b/modules/legacy/src/dpstereo.cpp
@@ -76,7 +76,7 @@ typedef struct _CvRightImData
     uchar min_val, max_val;
 } _CvRightImData;
 
-#define CV_IMAX3(a,b,c) ((temp3 = (a) >= (b) ? (a) : (b)),(temp3 >= (c) ? temp3 : (c)))
+#define CV_IMAX3(a,b,c) ((temp2 = (a) >= (b) ? (a) : (b)),(temp2 >= (c) ? temp2 : (c)))
 #define CV_IMIN3(a,b,c) ((temp3 = (a) <= (b) ? (a) : (b)),(temp3 <= (c) ? temp3 : (c)))
 
 static void icvFindStereoCorrespondenceByBirchfieldDP( uchar* src1, uchar* src2,
@@ -87,7 +87,7 @@ static void icvFindStereoCorrespondenceByBirchfieldDP( uchar* src1, uchar* src2,
                                                 float  _param3, float _param4,
                                                 float  _param5 )
 {
-    int     x, y, i, j, temp3;
+    int     x, y, i, j, temp2, temp3;
     int     d, s;
     int     dispH =  maxDisparity + 3;
     uchar  *dispdata;
