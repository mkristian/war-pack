eval( File.read( java.lang.System.getProperty( "common.pom" ) ), nil,
      java.lang.System.getProperty( "common.pom" ) ) 

jruby_plugin!( :gem,
               :includeLibDirectoryInResources => true,
               :includeRubygemsInResources => true )

plugin( :war, '2.2',
        :warSourceDirectory => '${public.dir}',
        :webResources => [ { :directory => '${base.dir}',
                             :targetPath => 'WEB-INF',
                             :includes => [ 'config.ru' ] } ] )

gem 'war-pack', '${war_pack.version}', :scope => :provided
execute :war_plugin, :phase => 'prepare-package'do |ctx|
  Gem.path << 'pkg/rubygems'
  Gem.path << 'pkg/rubygems-provided'

  require 'war_pack/maven_plugin'

  plugin = WarPack::MavenPlugin.new( ctx )

  plugin.remove_java_source_files_from_gems
  plugin.generate_load_path
end
