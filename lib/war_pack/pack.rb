require 'war_pack/pom_runner'
module WarPack
  class Pack < PomRunner

    def pack
      copy( 'web.xml', 'web-pack.xml' )
      copy( 'init.rb' )

      puts "creating #{final_name}.war . . ."

      exec :package

      war = "#{work_dir}/#{final_name}.war"
      puts war if File.exists?( war )
    end

    def pom_file
      WarPack.file( 'pack_pom.rb' )
    end
  end
end
