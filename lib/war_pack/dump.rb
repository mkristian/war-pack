require 'war_pack/dumper'
module WarPack
  class Dump  < Dumper

    # overwrite method
    def pom_file
      WarPack.file( 'pack_pom.rb' )
    end
  end
end
