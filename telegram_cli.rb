require 'formula'

class LuaRequirement < Requirement
  fatal true
  default_formula 'lua'

  satisfy { which 'pg_config' }
end

class TelegramCli < Formula
  homepage 'https://telegram.org/'
  head 'https://github.com/vysheng/tg.git'

  depends_on 'pkg-config' => :build
  depends_on 'readline'
  depends_on 'libconfig'
  depends_on LuaRequirement

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.install %w{ telegram }
  end
end
