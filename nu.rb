require 'formula'

class Nu < Formula
  homepage 'http://programming.nu'
  url 'https://github.com/timburks/nu/archive/v2.1.1.tar.gz'
  sha1 'ca0f9bbd5bbdb8528be516325f274d07d4be54bf'
  head 'https://github.com/timburks/nu.git'

  depends_on :macos => :lion
  depends_on 'pcre'

  fails_with :llvm do
    build 2336
    cause 'nu only builds with clang'
  end

  fails_with :gcc do
    build 5666
    cause 'nu only builds with clang'
  end

  stable do
    patch do
      # Fix issue #74, "Remove compiling with objc gc" - https://github.com/timburks/nu/pull/74
      url 'https://github.com/timburks/nu/commit/c0b05f11f668ee21977b7a99f89a1d7945c519d0.diff'
      sha1 'e31f3741a0a21b62c9547ba14959b3f6b504d2bd'
    end
  end

  def install
    ENV['PREFIX'] = prefix

    inreplace "Nukefile" do |s|
      s.gsub!('(SH "sudo ', '(SH "') # don't use sudo to install
      s.gsub!('#{@destdir}/Library/Frameworks', '#{@prefix}/Frameworks')
      s.sub! /^;; source files$/, <<-EOS
;; source files
(set @framework_install_path "#{frameworks}")
EOS
    end
    system "make"
    system "./mininush", "tools/nuke"
    bin.mkdir
    lib.mkdir
    include.mkdir
    system "./mininush", "tools/nuke", "install"
  end

  def caveats
    if self.installed? and File.exist? frameworks+"Nu.framework"
      return <<-EOS.undent
        Nu.framework was installed to:
          #{frameworks}/Nu.framework

        You may want to symlink this Framework to a standard OS X location,
        such as:
          ln -s "#{frameworks}/Nu.framework" /Library/Frameworks
      EOS
    end
    return nil
  end
end
