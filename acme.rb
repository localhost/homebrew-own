require 'formula'

class Acme < Formula
  homepage 'http://www.esw-heim.tu-clausthal.de/~marco/smorbrod/acme/'
  url 'http://www.esw-heim.tu-clausthal.de/~marco/smorbrod/acme/current/acme091src.tar.bz2'
  version '0.91'
  sha1 'd9751da2aee7cfc7ddbbbc0923b13f669b8666ad'

  def install
    cd 'src' do
      system 'make'
      system 'make', 'install'
    end
  end
end
