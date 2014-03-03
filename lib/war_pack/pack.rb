require 'war_pack/pom_runner'
module WarPack
  class Pack < PomRunner

    def pack
      copy_webxml( rails? ? 'web-production.xml' : 'web.xml', 'web-pack.xml' )
      maven.options[ '-f' ] ||= File.join( File.dirname( __FILE__ ), 
                                           rails? ? 
                                           'pack_rails_pom.rb' :
                                           'pack_rack_pom.rb' )
      exec :package

      war = "#{workdir}/#{final_name}.war"
      puts war if File.exists?( war )
    end
  end
end
