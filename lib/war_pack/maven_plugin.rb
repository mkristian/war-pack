module WarPack
  class MavenPlugin
    
    def initialize( context )
      @ctx = context
    end

    def remove_java_source_files_from_gems
      classes = @ctx.project.build.output_directory.to_pathname
      # FileUtils.rm_f has problems on Windows
      Dir[ File.join( classes, 'gems', '**', '*.java' ) ].each do |f|
        File.delete( f ) if File.exist?( f )
      end
    end

    def generate_load_path
      target = @ctx.project.build.directory.to_pathname
      meta_inf = File.join( target, @ctx.project.build.final_name,
                            'META-INF' )
      FileUtils.mkdir_p( meta_inf )
      s = Dir[ File.join( target, 
                          'rubygems/specifications/jruby-openssl-*.gemspec' ) ].first
      jossl = eval( File.read( s ) ).full_name
      
      File.open( File.join( meta_inf, 'init.rb' ), 'w' ) do |f|
        f.puts <<EOS
# the whole setup is meant to be self contained and rubygems does 
# not work with some classloaders, so skip it completely.
# instead setup the load_path on assembly time

Gem.path.clear

# some gems do use this :(
def gem( *args )
end

# load_path - check whether to classpath: or not
prefix = __FILE__.sub( /META-INF\\/init.rb/, 'WEB-INF/classes' )
begin
  openssl_path = File.join( prefix, 'gems/#{jossl}/lib' )
  $:.unshift openssl_path
  require 'openssl'
rescue LoadError
  prefix = 'classpath:'
end
$:.delete( openssl_path )

EOS
        Dir[ File.join( target,  'rubygems', 
                        'specifications', '*.gemspec' ) ].each do |s|
          spec = eval( File.read( s ) )
          f.puts "$:.unshift \"\#{prefix}/gems/#{spec.full_name}/#{spec.require_path}\""
        end
      end
    end
  end
end
