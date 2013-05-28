require 'formula'

class Cvblob < Formula
  homepage 'https://code.google.com/p/cvblob/'
  url 'https://cvblob.googlecode.com/files/cvblob-0.10.4-src.tgz'
  sha1 'bd1a46174a88f3a8150a0f16d7e3f2a6f0eb4c0b'

  depends_on 'cmake' => :build
  depends_on 'opencv'

  def install
    args = std_cmake_args
    args << '..'
    mkdir 'macbuild' do
      system 'cmake', *args
      system 'make'
      system 'make install'
    end
  end
end
