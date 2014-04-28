require 'formula'

class Libtiff < Formula
  homepage 'http://www.remotesensing.org/libtiff/'
  url 'http://download.osgeo.org/libtiff/tiff-4.0.3.tar.gz'
  sha256 'ea1aebe282319537fb2d4d7805f478dd4e0e05c33d0928baba76a7c963684872'

  option :universal
  option 'with-lzlib', 'Build with lzlib'

  depends_on 'lzlib' if build.include? 'with-lzlib'
  depends_on :x11 if build.include? 'with-x'
  depends_on 'glut' if build.include? 'with-x'

  # Fix uint64_t conflict when included together with OpenCV
  def patches; DATA; end

  def install
    ENV.universal_binary if build.universal?
    ENV['CFLAGS'] += "-DHAVE_APPLE_OPENGL_FRAMEWORK" if build.include? 'with-x'

    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}"
    ]
    args << "--disable-lzma" unless build.include? 'with-lzlib'
    args << (build.include?('with-x') ? "--with-x" : "--without-x")

    system "./configure", *args
    system "make", "CFLAGS=#{ENV.cflags}"
    system "make install"
  end
end

__END__
diff --git a/configure b/configure
index 8f27f01..98b70ca 100755
--- a/configure
+++ b/configure
@@ -17021,11 +17021,11 @@ INT64_T='none'
 INT64_FORMAT='none'
 if test $ac_cv_sizeof_signed_long -eq 8
 then
-  INT64_T='signed long'
+  INT64_T='int64_t'
   INT64_FORMAT='"%ld"'
 elif test $ac_cv_sizeof_signed_long_long -eq 8
 then
-  INT64_T='signed long long'
+  INT64_T='int64_t'
   case "${host_os}" in
     mingw32*)
       # MinGW32 understands 'long long', but uses printf from WIN32 CRT
@@ -17057,11 +17057,11 @@ UINT64_T='none'
 UINT64_FORMAT='none'
 if test $ac_cv_sizeof_unsigned_long -eq 8
 then
-  UINT64_T='unsigned long'
+  UINT64_T='uint64_t'
   UINT64_FORMAT='"%lu"'
 elif test $ac_cv_sizeof_unsigned_long_long -eq 8
 then
-  UINT64_T='unsigned long long'
+  UINT64_T='uint64_t'
   case "${host_os}" in
     mingw32*)
       # MinGW32 understands 'unsigned long long', but uses printf from WIN32 CRT
diff --git a/configure.ac b/configure.ac
index e1b8d40..b891a9a 100644
--- a/configure.ac
+++ b/configure.ac
@@ -272,11 +272,11 @@ INT64_T='none'
 INT64_FORMAT='none'
 if test $ac_cv_sizeof_signed_long -eq 8
 then
-  INT64_T='signed long'
+  INT64_T='int64_t'
   INT64_FORMAT='"%ld"'
 elif test $ac_cv_sizeof_signed_long_long -eq 8
 then
-  INT64_T='signed long long'
+  INT64_T='int64_t'
   case "${host_os}" in
     mingw32*)
       # MinGW32 understands 'long long', but uses printf from WIN32 CRT
@@ -298,11 +298,11 @@ UINT64_T='none'
 UINT64_FORMAT='none'
 if test $ac_cv_sizeof_unsigned_long -eq 8
 then
-  UINT64_T='unsigned long'
+  UINT64_T='uint64_t'
   UINT64_FORMAT='"%lu"'
 elif test $ac_cv_sizeof_unsigned_long_long -eq 8
 then
-  UINT64_T='unsigned long long'
+  UINT64_T='uint64_t'
   case "${host_os}" in
     mingw32*)
       # MinGW32 understands 'unsigned long long', but uses printf from WIN32 CRT
diff --git a/libtiff/tif_config.h.in b/libtiff/tif_config.h.in
index b2cea35..ea84f27 100644
--- a/libtiff/tif_config.h.in
+++ b/libtiff/tif_config.h.in
@@ -1,5 +1,7 @@
 /* libtiff/tif_config.h.in.  Generated from configure.ac by autoheader.  */
 
+#include <stdint.h>
+
 /* Define if building universal (internal helper macro) */
 #undef AC_APPLE_UNIVERSAL_BUILD
 
diff --git a/libtiff/tiffconf.h.in b/libtiff/tiffconf.h.in
index 6da9c5a..cbbc7f8 100644
--- a/libtiff/tiffconf.h.in
+++ b/libtiff/tiffconf.h.in
@@ -7,6 +7,8 @@
 #ifndef _TIFFCONF_
 #define _TIFFCONF_
 
+#include <stdint.h>
+
 /* Signed 16-bit type */
 #undef TIFF_INT16_T
 
