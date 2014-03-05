require 'maven/ruby/maven'
require 'fileutils'
require 'war_pack/ports'
module WarPack
  
  class PomRunner

    def initialize( config )
      @config = config
      @ports = Ports.new( config )
    end

    def method_missing( m, *args )
      result = @config[ m ] || @config[ m.to_s ] 
      result.nil? ? super : result
    end

    def maven
      @m ||= 
        begin
          m = Maven::Ruby::Maven.new
          m.property( 'base.dir', File.expand_path( basedir ) )
          m.property( 'public.dir', File.expand_path( publicdir ) ) if publicdir
          m.property( 'work.dir', File.expand_path( workdir ) ) if workdir
          m.property( 'run.port', @ports.port )
          if @ports.sslport > 0
            m.property( 'run.sslport', @ports.sslport )
            m.property( 'run.keystore', @ports.keystore )
            m.property( 'run.keystore.pass', @ports.keystore_pass )
            m.property( 'run.truststore.pass', @ports.truststore_pass )
          end
          m.property( 'common.pom', WarPack.common_pom )
          m.property( 'verbose', debug || verbose )
          m.options[ '-q' ] = nil if !debug and !verbose
          m.options[ '-X' ] = nil if debug
          m.property( 'final.name', final_name )
          m.verbose = debug
          m.options[ '-f' ] = mavenfile if mavenfile
          m
        end
    end

    def mavenfile
      if @config.key?( 'mavenfile' ) && @config[ 'mavenfile' ] != ''
        @config[ 'mavenfile' ]
      elsif File.exists?( 'Mavenfile' ) && @config[ 'mavenfile' ] != ''
        'Mavenfile'
      end
    end

    def basedir
      File.expand_path( '.' )
    end

    def final_name
      @config[ 'final_name' ] || File.basename( basedir )
    end

    def publicdir
       @config[ 'publicdir' ]
    end

    def workdir
       @config[ 'workdir' ]
    end

    def debug
       @config[ 'debug' ] || false
    end

    def verbose
       @config[ 'verbose' ] || false
    end

    def clean?
       @config[ 'clean' ] || false      
    end

    def web_inf
      # if the publicdir or its default exists we can use web_inf
      public_dir = publicdir || 'public'
      if File.exists? public_dir
        @web_inf ||= 
          begin
            d = File.join( public_dir  , 'WEB-INF' )
            FileUtils.mkdir_p d
            d
          end
      end
    end

    def rails?
      File.exists?( File.join( 'config', 'application.rb' ) )
    end

    def copy_webxml( source, webxml = 'web.xml' )
      return unless web_inf
      target = File.join( web_inf, webxml )
      unless File.exists?( target )
        webxml = WarPack.file( source )
        FileUtils.cp( webxml, target )
      end
    end

    def pom_file
      raise 'overwrite this method'
    end

    def exec( *args )
      maven.options[ '-f' ] ||= pom_file
      args.unshift :clean if clean?
      maven.exec( *args )
    end
  end
end
