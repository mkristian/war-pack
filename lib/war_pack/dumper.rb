require 'war_pack'
module WarPack
  class Dumper

    def initialize( config )
      @mode = ( config[ 'mode' ] || :create ).to_sym
    end

    def dump( file )
      send @mode, file
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

    def pom_file
      raise 'overwrite this method'
    end

    def write( file, mode, plugin_only )
      File.open( file, mode ) do |f|
        f.print( File.read( WarPack.common_pom ) ) unless plugin_only
        content = File.read( pom_file )
        content.gsub!( /.*"common.pom" .*/, '' )
        f.print( content )
      end
    end
  end
end
