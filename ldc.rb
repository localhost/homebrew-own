require 'formula'

class Ldc < Formula
  homepage 'http://wiki.dlang.org/LDC'
  url 'http://d32gngvpvl2pi1.cloudfront.net/ldc-0.11.0-src.tar.gz'
  sha1 '2c43e359d4e432611ff46b7bd6703f712f32d5cc'
  head 'https://github.com/ldc-developers/ldc.git'

  depends_on 'cmake' => :build
  depends_on 'libconfig'
  depends_on 'llvm'

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

