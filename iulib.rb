require 'formula'

class Iulib < Formula
  homepage 'http://code.google.com/p/iulib/'
  url 'http://iulib.googlecode.com/files/iulib-0.4.tgz'
  sha1 '96a006f806a650886fdd59b1239f6e56d1a864c1'

  depends_on "scons" => :build
  depends_on "imagemagick" => :build
  depends_on :libtool
  depends_on :libpng
  depends_on "jpeg"
  depends_on "libtiff" => 'with-lzlib'

  depends_on "sdl" => :optional
  depends_on "sdl_gfx" => :optional
  depends_on "sdl_image" => :optional

  def patches
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
diff --git a/SConstruct b/SConstruct
index 90a37a0..a3cf5e5 100644
--- a/SConstruct
+++ b/SConstruct
@@ -76,9 +76,6 @@ have_v4l2 = conf.CheckHeader("linux/videodev2.h")
 have_sdl = conf.CheckCXXHeader("SDL/SDL_gfxPrimitives.h") and \
            conf.CheckCXXHeader("SDL/SDL.h")

-have_vidio = 0 # FIXME
-have_v4l2 = 0 # FIXME
-have_sdl = 1
 conf.Finish()

 ### install folders
diff --git a/imglib/imgops.h b/imglib/imgops.h
index 2fdb156..86f1567 100644
--- a/imglib/imgops.h
+++ b/imglib/imgops.h
@@ -67,7 +67,7 @@ namespace iulib {
     }

     template<class T, class V>
-    void addscaled(colib::narray<T> &, colib::narray<T> &, V, int, int);
+    void addscaled(colib::narray<T> &, colib::narray<T> &, V scale=1, int dx=0, int dy=0);
     template<class T>
     void tighten(colib::narray<T> &image);
     template<class T>
diff --git a/imglib/imgops.cc b/imglib/imgops.cc
index b950c91..c9dcb14 100644
--- a/imglib/imgops.cc
+++ b/imglib/imgops.cc
@@ -133,7 +133,7 @@ namespace iulib {

     template<class T,class V>
     void addscaled(narray<T> &dest,narray<T> &src,
-            V scale=1,int dx=0,int dy=0) {
+            V scale,int dx,int dy) {
         for (int i=0; i<dest.dim(0); i++)
             for (int j=0; j<dest.dim(1); j++)
                 dest.unsafe_at(i,j) += (T)(scale*xref(src,i+dx,j+dy));
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
 
