require 'formula'

class Xjobs < Formula
  homepage 'http://www.maier-komor.de/xjobs.html'
  url 'http://www.maier-komor.de/xjobs/xjobs-20120412.tgz'
  sha1 'c461a023cae35d082416914f3d4f13373007f1d2'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
