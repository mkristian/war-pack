require 'war_pack/pom_runner'
module WarPack
  class Pack < PomRunner

    def pack
      copy_webxml( rails? ? 'web-production.xml' : 'web.xml', 'web-pack.xml' )

      exec :package

      war = "#{workdir}/#{final_name}.war"
      puts war if File.exists?( war )
    end

    def pom_file
      WarPack.file( rails? ? 
                    'pack_rails_pom.rb' :
                    'pack_rack_pom.rb' )
    end
  end
end
