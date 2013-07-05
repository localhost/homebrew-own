require 'formula'

class Tcc < Formula
  homepage 'http://bellard.org/tcc/'
  url 'http://download.savannah.gnu.org/releases/tinycc/tcc-0.9.26.tar.bz2'
  sha1 '7110354d3637d0e05f43a006364c897248aed5d0'

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}", "--cc=gcc", "--strip-binaries"
    system "make"
    system "make install"
  end
end
