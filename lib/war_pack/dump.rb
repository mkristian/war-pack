require 'war_pack/dumper'
require 'war_pack/version'
module WarPack
  class Dump  < Dumper

    # overwrite method
    def pom_file
      WarPack.file( 'pack_pom.rb' )
    end

    def call_append( f )
      f.puts
      f.puts "# fix war_pack version"
      f.puts "properties 'war_pack.version' => '#{WarPack::Version::VERSION}'"
    end
  end
end
