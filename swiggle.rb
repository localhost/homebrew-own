require "formula"

class Swiggle < Formula
  homepage "http://homepage.univie.ac.at/l.ertl/swiggle/"
  url "http://homepage.univie.ac.at/l.ertl/swiggle/files/swiggle-0.4.tar.gz"
  sha1 "e949b37a700da1e7154217a23f2e49ca6c08154d"

  depends_on "libexif"
  depends_on "jpeg"

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "swiggle"
    doc.install "README"
  end
end
