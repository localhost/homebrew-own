require 'formula'

class Vice < Formula
  homepage 'http://vice-emu.sourceforge.net/'
  url 'http://svn.code.sf.net/p/vice-emu/code/tags/v2.4/v2.4.6/vice'
  version '2.4.6'

  head 'http://svn.code.sf.net/p/vice-emu/code/trunk/vice'

  depends_on 'pkg-config' => :build
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build
  depends_on 'jpeg'
  depends_on 'libpng'
  depends_on 'giflib' => :optional
  depends_on 'lame' => :optional

  def install
    # Use Cocoa instead of X
    # Use a static lame, otherwise Vice is hard-coded to look in
    # /opt for the library.
    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-cocoa",
                          "--without-x",
                          "--enable-static-lame",
                          # VICE can't compile against FFMPEG newer than 0.11:
                          # http://sourceforge.net/tracker/?func=detail&aid=3585471&group_id=223021&atid=1057617
                          "--disable-ffmpeg"
    system "make"
    system "make bindist"
    prefix.install Dir['vice-macosx-*/*']
    bin.install_symlink Dir[prefix/'tools/*']
  end

  def caveats
    "Cocoa apps for these emulators have been installed to #{prefix}."
  end
end
