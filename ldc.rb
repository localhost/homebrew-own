require 'formula'

class Ldc < Formula
  homepage 'http://wiki.dlang.org/LDC'
  url 'https://github.com/downloads/ldc-developers/ldc/ldc-0.10.0-src.tar.gz'
  sha1 '6cfd64f89d74655dc2896d428ac26331c963f00a'
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
