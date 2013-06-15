require 'formula'

class MoshScheme < Formula
  homepage 'https://code.google.com/p/mosh-scheme/'
  url 'https://mosh-scheme.googlecode.com/files/mosh-0.2.7.tar.gz'
  sha1 '866c08ac12e14733ce27756001a27257624d01ad'

  head 'https://github.com/higepon/mosh.git'

  depends_on 'autoconf' => :build if build.head?
  depends_on 'automake' => :build if build.head?
  depends_on 'oniguruma'

  def install
    system "./autogen.sh" if build.head?

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
