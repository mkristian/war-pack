require 'war_pack/pom_runner'
require 'war_pack/version'
module WarPack
  class Pack < PomRunner

    def pack
      copy( 'web.xml' )

      puts "creating #{final_name}.war . . ."

      maven.property 'war_pack.version', WarPack::Version::VERSION

      exec :package

      war = "#{work_dir}/#{final_name}.war"
      puts war if File.exists?( war )
    end

    def pom_file
      WarPack.file( 'pack_pom.rb' )
    end
  end
end
