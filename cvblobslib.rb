require 'formula'

class Cvblobslib < Formula
  homepage 'http://opencv.willowgarage.com/wiki/cvBlobsLib'
  url 'http://opencv.willowgarage.com/wiki/cvBlobsLib?action=AttachFile&do=get&target=cvblobs8.3_linux.tgz'
  sha1 'b18e63fe3fc9b3f1521ca21cb3b3331b67d7ab8a'

  depends_on 'pkg-config' => :build
  depends_on 'opencv'

  # Remove gtk+-2.0
  def patches; DATA; end

  def install
    system "make"
    ENV.deparallelize
    #system "make install"
    include.install %w{
      BlobResult.h BlobLibraryConfiguration.h blob.h BlobContour.h BlobOperators.h ComponentLabeling.h BlobProperties.h
    }
    lib.install %w{ libblob.a }
  end
end
__END__
diff --git a/Makefile b/Makefile
index 7028dfc..ec6751f 100644
--- a/Makefile
+++ b/Makefile
@@ -2,8 +2,8 @@
 # Makefile for blobs library for OpenCV Version 4 and its examples
 #
 
-CFLAGS= `pkg-config --cflags opencv gtk+-2.0` -I. 
-LDFLAGS= `pkg-config --libs opencv gtk+-2.0` -L. -lblob 
+CFLAGS= `pkg-config --cflags opencv` -I.
+LDFLAGS= `pkg-config --libs opencv` -L. -lblob
 CXX=g++
 
 CPPFILES= \
 