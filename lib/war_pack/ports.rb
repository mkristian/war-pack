require 'war_pack'
module WarPack
  class Ports

    def initialize( config )
      @config = config
    end

    def keystore
      @config[ 'keystore' ] || WarPack.file( 'server.keystore' ) 
    end

    def keystore_pass
      @config[ 'keystore.pass' ] || '123456'
    end

    def truststore_pass
      @config[ 'truststore.pass' ] || '123456'
    end

    def port
       @config[ 'port' ] || 8080
    end

    def sslport
       @config[ 'sslport' ] || 8443
    end
  end
end
