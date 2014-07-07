require "formula"

class Exactimage < Formula
  homepage "http://www.exactcode.com/site/open_source/exactimage/"
  url "http://ftp.debian.org/debian/pool/main/e/exactimage/exactimage_0.8.9.orig.tar.gz"
  sha1 "d5cb671386d4ca8203f68f6caf01199b05467032"
  # head "https://svn.exactcode.de/exact-image/trunk/"

  depends_on "pkg-config" => :build

  depends_on "freetype"
  depends_on "libagg" # needs --with-freetype
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "expat"

  depends_on "libtiff" => :recommended
  depends_on "giflib" => :recommended
  depends_on "lcms" => :recommended

  depends_on "evas" => :optional
  depends_on "jasper" => :optional
  depends_on "openexr" => :optional

  # Fix compilation.
  def patches; DATA; end

  def install
    args = %W[
      --prefix=#{prefix}
      --without-lua
      --without-perl
      --without-php
      --without-python
      --without-ruby
      --without-swig
      --without-x11
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

end

__END__
Description: Fix FTBFS with libpng 1.5
Author: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Reviewed-by: Ralf Treinen <treinen@debian.org>
Bug-Debian: #635745

---
diff --git a/codecs/png.cc b/codecs/png.cc
index be70a53630710759194b56179b842c2cbba38823..ec5b16f9329d29239a770742255bec13147c1184 100644
--- a/codecs/png.cc
+++ b/codecs/png.cc
@@ -17,6 +17,7 @@
 
 #include <stdlib.h>
 #include <png.h>
+#include <zlib.h>
 
 #include <iostream>
 
@@ -58,7 +59,7 @@ int PNGCodec::readImage (std::istream* stream, Image& image, const std::string&
   png_structp png_ptr;
   png_infop info_ptr;
   png_uint_32 width, height;
-  int bit_depth, color_type, interlace_type;
+  int bit_depth, color_type, interlace_type, num_trans;
   
   png_ptr = png_create_read_struct(PNG_LIBPNG_VER_STRING,
 				   NULL /*user_error_ptr*/,
@@ -71,7 +72,7 @@ int PNGCodec::readImage (std::istream* stream, Image& image, const std::string&
   /* Allocate/initialize the memory for image information.  REQUIRED. */
   info_ptr = png_create_info_struct(png_ptr);
   if (info_ptr == NULL) {
-    png_destroy_read_struct(&png_ptr, png_infopp_NULL, png_infopp_NULL);
+    png_destroy_read_struct(&png_ptr, NULL, NULL);
     return 0;
   }
   
@@ -82,7 +83,7 @@ int PNGCodec::readImage (std::istream* stream, Image& image, const std::string&
   
   if (setjmp(png_jmpbuf(png_ptr))) {
     /* Free all of the memory associated with the png_ptr and info_ptr */
-    png_destroy_read_struct(&png_ptr, &info_ptr, png_infopp_NULL);
+    png_destroy_read_struct(&png_ptr, &info_ptr, NULL);
     /* If we get here, we had a problem reading the file */
     return 0;
   }
@@ -99,13 +100,13 @@ int PNGCodec::readImage (std::istream* stream, Image& image, const std::string&
   png_read_info (png_ptr, info_ptr);
   
   png_get_IHDR (png_ptr, info_ptr, &width, &height, &bit_depth, &color_type,
-		&interlace_type, int_p_NULL, int_p_NULL);
+		&interlace_type, NULL, NULL);
   
   image.w = width;
   image.h = height;
   image.bps = bit_depth;
-  image.spp = info_ptr->channels;
-  
+  image.spp = png_get_channels(png_ptr, info_ptr);
+
   png_uint_32 res_x, res_y;
   res_x = png_get_x_pixels_per_meter(png_ptr, info_ptr);
   res_y = png_get_y_pixels_per_meter(png_ptr, info_ptr);
@@ -119,11 +120,13 @@ int PNGCodec::readImage (std::istream* stream, Image& image, const std::string&
    * (not useful if you are using png_set_packing). */
   // png_set_packswap(png_ptr);
 
+  png_get_tRNS(png_ptr, info_ptr, NULL, &num_trans, NULL);
+
   /* Expand paletted colors into true RGB triplets */
   if (color_type == PNG_COLOR_TYPE_PALETTE) {
     png_set_palette_to_rgb(png_ptr);
     image.bps = 8;
-    if (info_ptr->num_trans)
+    if (num_trans)
       image.spp = 4;
     else
       image.spp = 3;
@@ -196,11 +199,11 @@ int PNGCodec::readImage (std::istream* stream, Image& image, const std::string&
   for (int pass = 0; pass < number_passes; ++pass)
     for (unsigned int y = 0; y < height; ++y) {
       row_pointers[0] = image.getRawData() + y * stride;
-      png_read_rows(png_ptr, row_pointers, png_bytepp_NULL, 1);
+      png_read_rows(png_ptr, row_pointers, NULL, 1);
     }
   
   /* clean up after the read, and free any memory allocated - REQUIRED */
-  png_destroy_read_struct(&png_ptr, &info_ptr, png_infopp_NULL);
+  png_destroy_read_struct(&png_ptr, &info_ptr, NULL);
   
   /* that's it */
   return true;
@@ -224,7 +227,7 @@ bool PNGCodec::writeImage (std::ostream* stream, Image& image, int quality,
   /* Allocate/initialize the memory for image information.  REQUIRED. */
   info_ptr = png_create_info_struct(png_ptr);
   if (info_ptr == NULL) {
-    png_destroy_write_struct(&png_ptr, png_infopp_NULL);
+    png_destroy_write_struct(&png_ptr, NULL);
     return false;
   }
   
@@ -244,8 +247,10 @@ bool PNGCodec::writeImage (std::ostream* stream, Image& image, int quality,
   else if (quality > Z_BEST_COMPRESSION) quality = Z_BEST_COMPRESSION;
   png_set_compression_level(png_ptr, quality);
   
+  /* Need?
   png_info_init (info_ptr);
-  
+  */
+
   /* Set up our STL stream output control */ 
   png_set_write_fn (png_ptr, stream, &stdstream_write_data, &stdstream_flush_data);
   
---
diff --git a/codecs/Makefile b/codecs/Makefile
index e596309..43b6d99 100644
--- a/codecs/Makefile
+++ b/codecs/Makefile
@@ -18,8 +18,8 @@ else
 NOT_SRCS += png.cc
 endif

-ifeq "$(WITHLIBUNGIF)" "1"
-LDFLAGS += -lungif
+ifeq "$(WITHLIBGIF)" "1"
+LDFLAGS += -lgif
 else
 NOT_SRCS += gif.cc
 endif
diff --git a/configure b/configure
index 668f939..a8d4415 100755
--- a/configure
+++ b/configure
@@ -2,7 +2,7 @@

 . config/functions

-with_options="x11 freetype evas libjpeg libtiff libpng libungif jasper openexr expat lcms bardecode lua swig perl python php ruby"
+with_options="x11 freetype evas libjpeg libtiff libpng libgif jasper openexr expat lcms bardecode lua swig perl python php ruby"

 feature_options="evasgl tga pcx static"
 TGA=1 # default to yes
@@ -64,7 +64,7 @@ fi
 pkgcheck libjpeg header LIBJPEG cc jconfig.h
 pkgcheck libtiff header LIBTIFF c++ tiffconf.h tiffio.h # tiffio.hxx
 pkgcheck libpng pkg-config LIBPNG atleast 1.2
-pkgcheck libungif header LIBUNGIF c++ gif_lib.h
+pkgcheck libgif header LIBGIF c++ gif_lib.h
 pkgcheck jasper header JASPER c++ jasper/jasper.h
 if pkgcheck expat header EXPAT c++ expat.h; then # just for the SVG parser
        var_append EXPATLIBS " " "-lexpat"
