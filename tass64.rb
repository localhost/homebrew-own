require "formula"

class Tass64 < Formula
  homepage 'http://singularcrew.hu/64tass/'
  url 'http://downloads.sourceforge.net/project/tass64/source/64tass-1.51.584-src.zip'
  sha1 '4cc9739592c7fc7b9901f73f78d47da8664308d6'
  head 'svn://svn.code.sf.net/p/tass64/code/trunk'

  def install
    system "make", "64tass"
    bin.install '64tass'
  end

  test do
    system "#{bin}/64tass -V"
  end
end
