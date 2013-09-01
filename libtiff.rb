require 'formula'

class Libtiff < Formula
  homepage 'http://www.remotesensing.org/libtiff/'
  url 'http://download.osgeo.org/libtiff/tiff-4.0.3.tar.gz'
  sha256 'ea1aebe282319537fb2d4d7805f478dd4e0e05c33d0928baba76a7c963684872'

  option :universal
  option 'with-lzlib', 'Build with lzlib'

  depends_on 'lzlib' if build.include? 'with-lzlib'
  depends_on :x11 if build.include? 'with-x' or MacOS::X11.installed?

  def install
    ENV.universal_binary if build.universal?

    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}"
    ]
    args << "--disable-lzma" unless build.include? 'with-lzlib'
    args << "--without-x" unless build.include? 'with-x' or MacOS::X11.installed?

    system "./configure", *args
    system "make install"
  end
end
