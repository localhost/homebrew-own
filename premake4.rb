require "formula"

class Premake4 < Formula
  homepage "http://industriousone.com/premake"
  url "https://downloads.sourceforge.net/project/premake/Premake/4.3/premake-4.3-src.zip"
  sha1 "8f37a3599121580f18b578811162b9b49a2e122f"
  head 'https://bitbucket.org/premake/premake-stable', :using => :hg

  bottle do
    cellar :any
    sha1 "54ccb106b6abf6c1c76a776cffa82d671ab940a2" => :mavericks
    sha1 "960b64d517b1290608acc950058a71f9e984ad79" => :mountain_lion
    sha1 "271358004f8cd52160bfd45d9e58a59bc3fcb75d" => :lion
  end

  devel do
    url "https://downloads.sourceforge.net/project/premake/Premake/4.4/premake-4.4-beta5-src.zip"
    sha1 "02472d4304ed9ff66cde57038c17fbd42a159028"
  end

  def install
    unless build.devel?
      # Linking against stdc++-static causes a library not found error on 10.7
      inreplace "build/gmake.macosx/Premake4.make", "-lstdc++-static ", ""
    end
    system "make -C build/gmake.macosx"

    # Premake has no install target, but its just a single file that is needed
    bin.install "bin/release/premake4"
  end

  def patches
    DATA if build.devel?
  end

end
__END__
diff --git a/src/host/scripts.c b/src/host/scripts.c
index bfddb1e..a0c08d2 100644
--- a/src/host/scripts.c
+++ b/src/host/scripts.c
@@ -103,8 +103,8 @@ const char* builtin_scripts[] = {
 	/* tools/gcc.lua */
 	"premake.gcc = { }\npremake.gcc.cc     = \"gcc\"\npremake.gcc.cxx    = \"g++\"\npremake.gcc.ar     = \"ar\"\nlocal cflags =\n{\nEnableSSE      = \"-msse\",\nEnableSSE2     = \"-msse2\",\nExtraWarnings  = \"-Wall -Wextra\",\nFatalWarnings  = \"-Werror\",\nFloatFast      = \"-ffast-math\",\nFloatStrict    = \"-ffloat-store\",\nNoFramePointer = \"-fomit-frame-pointer\",\nOptimize       = \"-O2\",\nOptimizeSize   = \"-Os\",\nOptimizeSpeed  = \"-O3\",\nSymbols        = \"-g\",\n}\nlocal cxxflags =\n{\nNoExceptions   = \"-fno-exceptions\",\nNoRTTI         = \"-fno-rtti\",\n}\npremake.gcc.platforms =\n{\nNative = {\ncppflags = \"-MMD\",\n},\nx32 = {\ncppflags = \"-MMD\",\nflags    = \"-m32\",\nldflags  = \"-L/usr/lib32\",\n},\nx64 = {\ncppflags = \"-MMD\",\nflags    = \"-m64\",\nldflags  = \"-L/usr/lib64\",\n},\nUniversal = {\ncppflags = \"\",\nflags    = \"-arch i386 -arch x86_64 -arch ppc -arch ppc64\",\n},\nUniversal32 = {\ncppflags = \"\",\nflags    = \"-arch i386 -arch ppc\",\n},\nUniversal64 = {\ncppflags = \"\""
 	",\nflags    = \"-arch x86_64 -arch ppc64\",\n},\nPS3 = {\ncc         = \"ppu-lv2-g++\",\ncxx        = \"ppu-lv2-g++\",\nar         = \"ppu-lv2-ar\",\ncppflags   = \"-MMD\",\n},\nWiiDev = {\ncppflags    = \"-MMD -MP -I$(LIBOGC_INC) $(MACHDEP)\",\nldflags= \"-L$(LIBOGC_LIB) $(MACHDEP)\",\ncfgsettings = [[\n  ifeq ($(strip $(DEVKITPPC)),)\n    $(error \"DEVKITPPC environment variable is not set\")'\n  endif\n  include $(DEVKITPPC)/wii_rules']],\n},\n}\nlocal platforms = premake.gcc.platforms\nfunction premake.gcc.getcppflags(cfg)\nlocal flags = { }\ntable.insert(flags, platforms[cfg.platform].cppflags)\nif flags[1]:startswith(\"-MMD\") and cfg.system ~= \"haiku\" then\ntable.insert(flags, \"-MP\")\nend\nreturn flags\nend\nfunction premake.gcc.getcflags(cfg)\nlocal result = table.translate(cfg.flags, cflags)\ntable.insert(result, platforms[cfg.platform].flags)\nif cfg.system ~= \"windows\" and cfg.kind == \"SharedLib\" then\ntable.insert(result, \"-fPIC\")\nend\nreturn result\nend\nfunction premake.gcc.getcxxflags"
-	"(cfg)\nlocal result = table.translate(cfg.flags, cxxflags)\nreturn result\nend\nfunction premake.gcc.getldflags(cfg)\nlocal result = { }\nif not cfg.flags.Symbols then\nif cfg.system == \"macosx\" then\ntable.insert(result, \"-Wl,-x\")\nelse\ntable.insert(result, \"-s\")\nend\nend\nif cfg.kind == \"SharedLib\" then\nif cfg.system == \"macosx\" then\ntable.insert(result, \"-dynamiclib\")\nelse\ntable.insert(result, \"-shared\")\nend\nif cfg.system == \"windows\" and not cfg.flags.NoImportLib then\ntable.insert(result, '-Wl,--out-implib=\"' .. cfg.linktarget.fullpath .. '\"')\nend\nend\nif cfg.kind == \"WindowedApp\" and cfg.system == \"windows\" then\ntable.insert(result, \"-mwindows\")\nend\nlocal platform = platforms[cfg.platform]\ntable.insert(result, platform.flags)\ntable.insert(result, platform.ldflags)\nreturn result\nend\nfunction premake.gcc.getlibdirflags(cfg)\nlocal result = { }\nfor _, value in ipairs(premake.getlinks(cfg, \"all\", \"directory\")) do\ntable.insert(result, '-L' .. _MAKE.esc(value))\n"
-	"end\nreturn result\nend\nfunction premake.gcc.getlinkflags(cfg)\nlocal result = {}\nfor _, value in ipairs(premake.getlinks(cfg, \"system\", \"name\")) do\nif path.getextension(value) == \".framework\" then\ntable.insert(result, '-framework ' .. _MAKE.esc(path.getbasename(value)))\nelse\ntable.insert(result, '-l' .. _MAKE.esc(value))\nend\nend\nreturn result\nend\nfunction premake.gcc.getdefines(defines)\nlocal result = { }\nfor _,def in ipairs(defines) do\ntable.insert(result, '-D' .. def)\nend\nreturn result\nend\nfunction premake.gcc.getincludedirs(includedirs)\nlocal result = { }\nfor _,dir in ipairs(includedirs) do\ntable.insert(result, \"-I\" .. _MAKE.esc(dir))\nend\nreturn result\nend\nfunction premake.gcc.getcfgsettings(cfg)\nreturn platforms[cfg.platform].cfgsettings\nend\n",
+	"(cfg)\nlocal result = table.translate(cfg.flags, cxxflags)\nreturn result\nend\nfunction premake.gcc.getldflags(cfg)\nlocal result = { }\nif not cfg.flags.Symbols then\nif cfg.system ~= \"macosx\" then\ntable.insert(result, \"-s\")\nend\nend\nif cfg.kind == \"SharedLib\" then\nif cfg.system == \"macosx\" then\ntable.insert(result, \"-dynamiclib\")\nelse\ntable.insert(result, \"-shared\")\nend\nif cfg.system == \"windows\" and not cfg.flags.NoImportLib then\ntable.insert(result, '-Wl,--out-implib=\"' .. cfg.linktarget.fullpath .. '\"')\nend\nend\nif cfg.kind == \"WindowedApp\" and cfg.system == \"windows\" then\ntable.insert(result, \"-mwindows\")\nend\nlocal platform = platforms[cfg.platform]\ntable.insert(result, platform.flags)\ntable.insert(result, platform.ldflags)\nreturn result\nend\nfunction premake.gcc.getlibdirflags(cfg)\nlocal result = { }\nfor _, value in ipairs(premake.getlinks(cfg, \"all\", \"directory\")) do\ntable.insert(result, '-L' .. _MAKE.esc(value))\nend\nreturn result\nend\nfunction premak"
+	"e.gcc.getlinkflags(cfg)\nlocal result = {}\nfor _, value in ipairs(premake.getlinks(cfg, \"system\", \"name\")) do\nif path.getextension(value) == \".framework\" then\ntable.insert(result, '-framework ' .. _MAKE.esc(path.getbasename(value)))\nelse\ntable.insert(result, '-l' .. _MAKE.esc(value))\nend\nend\nreturn result\nend\nfunction premake.gcc.getdefines(defines)\nlocal result = { }\nfor _,def in ipairs(defines) do\ntable.insert(result, '-D' .. def)\nend\nreturn result\nend\nfunction premake.gcc.getincludedirs(includedirs)\nlocal result = { }\nfor _,dir in ipairs(includedirs) do\ntable.insert(result, \"-I\" .. _MAKE.esc(dir))\nend\nreturn result\nend\nfunction premake.gcc.getcfgsettings(cfg)\nreturn platforms[cfg.platform].cfgsettings\nend\n",

 	/* tools/msc.lua */
 	"premake.msc = { }\npremake.msc.namestyle = \"windows\"\n",
diff --git a/src/tools/gcc.lua b/src/tools/gcc.lua
index 403f532..f4d01dd 100644
--- a/src/tools/gcc.lua
+++ b/src/tools/gcc.lua
@@ -138,9 +138,7 @@

 		-- OS X has a bug, see http://lists.apple.com/archives/Darwin-dev/2006/Sep/msg00084.html
 		if not cfg.flags.Symbols then
-			if cfg.system == "macosx" then
-				table.insert(result, "-Wl,-x")
-			else
+			if cfg.system ~= "macosx" then
 				table.insert(result, "-s")
 			end
 		end
