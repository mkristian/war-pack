require 'war_pack'
module WarPack
  class Dumper

    def initialize( config )
      @config = config
    end

    def dump( file )
      send mode, file
    end

    def create( file )
      raise "#{file} exists. either remove it or use mode 'append' or 'overwrite' or use a different name'" if File.exists?( file )
      write( file, 'w', false )
    end

    def overwrite( file )
      FileUtils.rm_f( file )
      write( file, 'w', false )
    end

    def append( file )
      raise "#{file} not found." unless File.exists?( file )
      write( file, 'a', false )
    end

    def append_plugin( file )
      raise "#{file} not found." unless File.exists?( file )
      write( file, 'a', true )
    end
    
    protected

    def mode
      ( @config[ 'mode' ] || :create ).to_sym
    end

    def write( file, mode, plugin_only )
      File.open( file, mode ) do |f|
        f.print( File.read( WarPack.common_pom ) ) unless plugin_only
        
        call_prepend( f )
        
        content = File.read( pom_file )
        content.gsub!( /.*"common.pom" .*/, '' )
        f.print( content )

        call_append( f )
      end
    end

    def call_prepend( f )
    end

    def call_append( f )
    end
  end
end
