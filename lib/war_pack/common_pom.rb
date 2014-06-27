gemfile( File.expand_path( 'Gemfile' ) ) if File.exists? 'Gemfile'

# remove jruby-jars gem from the dependencies but use its version for the 
# jruby jar
jruby_jars = model.dependencies.detect {|d| d.group_id == 'rubygems' && d.artifact_id == 'jruby-jars' } 
if jruby_jars
  model.dependencies.delete
  jruby_version = jruby_jars.version
end

if File.exists? 'Jarfile'
  jarfile( File.expand_path( 'Jarfile' ) ) 
  jruby_pom = model.dependencies.detect {|d| d.group_id == 'org.jruby' }
  jruby_version = jruby_pom.version 
elsif ( jruby_version && 
        jruby_version.sub( /1.[67]./, '' ).sub( /-SNAPSHOT/, '' ).to_i < 14 ||
        jruby_version.nil? )
  pom( 'org.jruby:jruby', '${jruby.version}' )
else
  jar( 'org.jruby:jruby-core', '${jruby.version}' )
  jar( 'org.jruby:jruby-lib', '${jruby.version}' )
  jar( 'org.jruby:jruby-stdlib', '${jruby.version}', :scope => :provided )
end

packaging :war

jar( 'org.jruby.rack:jruby-rack', '1.1.14', 
     :exclusions => [ 'org.jruby:jruby-complete' ] )

properties( 'jruby.version' => jruby_version || '1.7.13',
            'project.build.sourceEncoding' => 'utf-8',
            'final.name' => '${project.artifactId}',
            'base.dir' => '${basedir}',
            'public.dir' => '${base.dir}/public',
            'webinf.dir' => '${public.dir}/WEB-INF',
            'classes.dir' => '${webinf.dir}/classes',
            'lib.dir' => '${base.dir}/lib',
            'work.dir' => '${base.dir}/pkg'  )

final_name '${final.name}'
directory '${work.dir}'
output_directory '${classes.dir}'

# ruby-maven will dump an equivalent pom.xml
properties[ 'tesla.dump.pom' ] = 'pom.xml'
