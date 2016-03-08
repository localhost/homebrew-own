require "formula"

class Tass64 < Formula
  homepage 'http://singularcrew.hu/64tass/'
  url 'http://downloads.sourceforge.net/project/tass64/source/64tass-1.51.992-src.zip'
  sha1 '3d7e653dabca96951395a4f38e4988ae9b2751f5'
  head 'svn://svn.code.sf.net/p/tass64/code/trunk'

  def install
    system "make", "64tass"
    bin.install '64tass'
  end

  test do
    system "#{bin}/64tass -V"
  end
end
