require "formula"

class Lftp < Formula
  desc "Sophisticated file transfer program"
  homepage "http://lftp.tech/"
  url "http://lftp.yar.ru/ftp/lftp-4.7.4.tar.xz"
  sha256 "bf67c4d128b6f769a4082947376a9679c5ee3463a24ab761a0757f75d70bd92c"

  depends_on "xz" => :build
  depends_on "pkg-config" => :build
  depends_on "readline"
  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end
end
