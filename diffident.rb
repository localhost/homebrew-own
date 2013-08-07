require 'formula'

class Diffident < Formula
  homepage 'http://www.artificialworlds.net/wiki/Diffident/Diffident'
  url 'http://downloads.sourceforge.net/project/diffident/diffident-0.3.tar.bz2'
  version '0.3'
  sha1 'bc6263d33cb806c8c5422915988dddeb8bcdaaa9'
  head 'git://diffident.git.sourceforge.net/gitroot/diffident/diffident'

  depends_on :python

  def install
    inreplace "Makefile", "PREFIX=/usr", "PREFIX=#{prefix}"
    ENV.deparallelize
    system "make"
    system "make", "install"
  end
end
