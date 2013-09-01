require 'formula'

class Iulib < Formula
  homepage 'http://code.google.com/p/iulib/'
  url 'http://iulib.googlecode.com/files/iulib-0.4.tgz'
  sha1 '96a006f806a650886fdd59b1239f6e56d1a864c1'

  depends_on "scons" => :build
  depends_on :libtool
  depends_on :libpng
  depends_on "jpeg"
  depends_on "libtiff" => 'with-lzlib'
  depends_on "imagemagick" => 'with-magick-plus-plus'

  def patches
    # fixes errors in header calls
    DATA
  end

  def install
    system "scons"
    system "scons install"
  end
end

__END__
diff --git a/SConstruct b/SConstruct
index e5e3b70..90a37a0 100644
--- a/SConstruct
+++ b/SConstruct
@@ -60,7 +60,7 @@ if not conf.CheckLibWithHeader('png', 'png.h', 'C', 'png_byte;', 1):
     missing += " libpng12-dev"
 if not conf.CheckLibWithHeader('jpeg', 'jconfig.h', 'C', 'jpeg_std_error();', 1):
     missing += " libjpeg62-dev"    
-if not conf.CheckLibWithHeader('tiff', 'tiff.h', 'C', 'inflate();', 1):
+if not conf.CheckLibWithHeader('tiff', 'tiff.h', 'C', 'TIFFOpen();', 1):
    missing += " libtiff4-dev"
 
 if missing:
diff --git a/colib/narray-util.h b/colib/narray-util.h
index bf86993..6d6c458 100644
--- a/colib/narray-util.h
+++ b/colib/narray-util.h
@@ -31,7 +31,7 @@
 #ifndef h_narray_util__
 #define h_narray_util__
 
-#include <math.h>
+#include <cmath>
 #include <stdlib.h>
 #include "colib/checks.h"
 #include "misc.h"
@@ -49,7 +49,7 @@ namespace colib {
     template <class T>
     void check_nan(narray<T> &v) {
         for(int i=0;i<v.length1d();i++)
-            ASSERT(!isnan(v.unsafe_at1d(i)));
+            ASSERT(!std::isnan(v.unsafe_at1d(i)));
     }
 
     /// Compute the global max of the absolute value of the array.
@@ -176,7 +176,7 @@ namespace colib {
         double total = 0.0;
         for(int i=0;i<a.length1d();i++)
             total += sqr(a.at1d(i)-b.at1d(i));
-        CHECK_ARG(!isnan(total));
+        CHECK_ARG(!std::isnan(total));
         return total;
     }
 
