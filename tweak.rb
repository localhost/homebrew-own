require "formula"

class Tweak < Formula
  homepage "http://www.chiark.greenend.org.uk/~sgtatham/tweak/"
  url "http://www.chiark.greenend.org.uk/~sgtatham/tweak/tweak-3.01.tar.gz"
  sha1 "23e731d14837f9bd7c80c3a03c1c82a39928f0fc"

  option "with-s-lang", "Build against slang instead of ncurses"

  depends_on 's-lang' => :optional

  def patches; DATA; end

  def install
    args = []
    args << "SLANG=yes" if build.with? 's-lang'
    system "make", "tweak", *args
    system "make", "install"
  end

end
__END__
diff --git a/slang.c b/slang.c
index 172c5db..2462294 100644
--- a/slang.c
+++ b/slang.c
@@ -153,7 +153,9 @@ int display_input_to_flush(void)
 void display_post_error(void)
 {
     SLKeyBoard_Quit = 0;
+#if SLANG_VERSION < 20000
     SLang_Error = 0;
+#endif
 }
 
 void display_recheck_size(void)
diff --git a/tweak.h b/tweak.h
index eeb6236..b76da0a 100644
--- a/tweak.h
+++ b/tweak.h
@@ -1,6 +1,10 @@
 #ifndef TWEAK_TWEAK_H
 #define TWEAK_TWEAK_H
 
+#if !defined(unix) && (defined(__unix__) || defined(__unix) || defined(__APPLE__) || defined(__MACH__))
+#define unix
+#endif
+
 #ifndef NO_LARGE_FILES
 
 #ifndef _LARGEFILE_SOURCE
