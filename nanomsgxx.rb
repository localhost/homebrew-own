require "formula"

class Nanomsgxx < Formula
  homepage "https://github.com/achille-roussel/nanomsgxx"
  version "0.1"
  head "https://github.com/achille-roussel/nanomsgxx.git"

  def install
    system "./waf configure --prefix=#{prefix}"
    system "./waf build"
    system "./waf install"
  end
end
