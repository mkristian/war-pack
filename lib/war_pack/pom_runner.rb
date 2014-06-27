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
          if File.exists?( public_dir )
            m.property( 'public.dir', File.expand_path( publicdir ) )
         elsif publicdir
             m.property( 'public.dir', File.expand_path( '.' ) )
             m.property( 'webinf.dir', File.expand_path( web_inf ) )
          end
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
          m.options[ '-e' ] = nil if !debug and verbose
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

    def work_dir
      # needs default here
      workdir || 'pkg'
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

    def public_dir
      publicdir || 'public'
    end

    def web_inf
      pdir = public_dir
      unless File.exists? public_dir
        pdir = '.'
      end
      @web_inf ||= 
        begin
          d = File.join( pdir, 'WEB-INF' )
          FileUtils.mkdir_p d
          d
        end
    end

    def rails?
      File.exists?( File.join( 'config', 'application.rb' ) )
    end

    def copy( source, target = nil )
      return unless web_inf
      target = File.join( web_inf, target || File.basename( source ) )
      unless File.exists?( target )
        FileUtils.cp( WarPack.file( source ), target )
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
