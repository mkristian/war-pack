require 'war_pack/dumper'
module WarPack
  class Dump  < Dumper

    # overwrite method
    def pom_file
      WarPack.file( rails?  ? 
                    'pack_rails_pom.rb' :
                    'pack_rack_pom.rb' )
    end
  end
end
