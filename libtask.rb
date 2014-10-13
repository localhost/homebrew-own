require "formula"

class Libtask < Formula
  homepage "http://swtch.com/libtask/"
  version "2005"
  url "http://swtch.com/libtask.tar.gz"
  sha1 "3873d8b53d386e7d6baecf99310ae3c3f6e8d066"

  def install
    system "make", "libtask.a"
    lib.install "libtask.a"
    include.install Dir['task.h']
  end
end
