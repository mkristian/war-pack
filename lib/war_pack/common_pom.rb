#-*- mode: ruby -*-

gemfile

properties( 'project.build.sourceEncoding' => 'utf-8',
            'final.name' => '${project.artifactId}',
            'base.dir' => '${basedir}',
            'public.dir' => '${base.dir}/public',
            'webinf.dir' => '${public.dir}/WEB-INF',
            'classes.dir' => '${webinf.dir}/classes',
            'gem.home' => '${classes.dir}',
            'gem.path' => '${classes.dir}',
            'work.dir' => '${base.dir}/pkg'  )

# ruby-maven will dump an equivalent pom.xml
properties[ 'tesla.dump.pom' ] = 'pom.xml'

packaging :war

jruby_jars = model.dependencies.detect {|d| d.group_id == 'rubygems' && d.artifact_id == 'jruby-jars' }

jar( 'org.jruby:jruby', jruby_jars ? jruby_jars.version : '1.7.11' )

jar( 'org.jruby.rack:jruby-rack', '1.1.14', 
     :exclusions => [ 'org.jruby:jruby-complete' ] )

jruby_plugin :gem, :includeRubygemsInTestResources => false do
  execute_goal :initialize
end

plugin :clean, '2.5', :filesets => [ { :directory => '${classes.dir}',
                                       :includes => [ '**/*' ] } ]

build do
  final_name '${final.name}'
  directory '${work.dir}'
end
