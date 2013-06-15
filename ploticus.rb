require 'formula'

class Ploticus < Formula
  homepage 'http://ploticus.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/ploticus/ploticus/2.42/ploticus242_src.tar.gz'
  sha1 'b3d9caa1db12144bdeff2b0b3857762e6aef26a9'
  version '2.42'

  depends_on 'gd' # %w{ with-freetype }
  depends_on :libpng
  depends_on 'lzlib'
  depends_on 'jpeg'

  def install
    cd 'src' do
      system 'make'
      bin.install %w{ pl }
    end
  end
end
