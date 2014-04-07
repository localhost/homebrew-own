require "formula"

class Ffms2 < Formula
  homepage "https://github.com/FFMS/ffms2"

  url "https://github.com/FFMS/ffms2/archive/2.19.1.tar.gz"
  sha1 "db7fb9d820e5a8dadab82a761c6feb5a9f1e20b0"

  head do
    url "https://github.com/FFMS/ffms2.git"

    depends_on :autoconf => :build
    depends_on :automake => :build
    depends_on :libtool  => :build
  end

  depends_on "lzlib"
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  # depends_on "libav" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
    ]

    # ENV['LIBAV_LIBS'] = %x[pkg-config --libs libav].chomp
    
    system "./autogen.sh" if build.head?

    system "./configure", *args

    system "make"
    system "make", "install"
  end
end
