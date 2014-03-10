#-*- mode: ruby -*-

gemfile

properties( 'project.build.sourceEncoding' => 'utf-8',
            'final.name' => '${project.artifactId}',
            'base.dir' => '${basedir}',
            'public.dir' => '${base.dir}/public',
            'webinf.dir' => '${public.dir}/WEB-INF',
            'classes.dir' => '${webinf.dir}/classes',
            'lib.dir' => '${base.dir}/lib',
            'gem.home' => '${classes.dir}',
            'gem.path' => '${classes.dir}',
            'work.dir' => '${base.dir}/pkg'  )

# ruby-maven will dump an equivalent pom.xml
properties[ 'tesla.dump.pom' ] = 'pom.xml'

packaging :war

# remove jruby-jars gem from the dependencies but use its version for the 
# jruby dependency
jruby_jars = model.dependencies.detect {|d| d.group_id == 'rubygems' && d.artifact_id == 'jruby-jars' }

jruby_version = jruby_jars ? jruby_jars.version : '1.7.11'

jar( 'org.jruby:jruby', jruby_version,
     :exclusions => ['org.jruby:jruby-stdlib' ])

# needed to install gems for the build itself
jar( 'org.jruby:jruby-stdlib', jruby_version,
     :scope => :provided )

jar( 'org.jruby.rack:jruby-rack', '1.1.14', 
     :exclusions => [ 'org.jruby:jruby-complete' ] )

phase 'prepare-package' do
  plugin( :dependency, '2.8',
          :artifactItems => [ { :groupId => 'org.jruby',
                                :artifactId => 'jruby-stdlib',
                                :version => jruby_version,
                                :outputDirectory => '${classes.dir}' } ] ) do
    execute_goal( :unpack )
  end
end

jruby_plugin :gem, :includeRubygemsInTestResources => false, :includeRubygemsResources => true  do
  execute_goal :initialize
end

plugin! :clean, '2.5', :filesets => [ { :directory => '${work.dir}',
                                        :includes => [ '**/*' ] },
                                      { :directory => '${classes.dir}',
                                        :includes => [ '**/*' ] } ]

build do
  final_name '${final.name}'
  directory '${work.dir}'
end
