eval( File.read( java.lang.System.getProperty( "common.pom" ) ), nil, 
      java.lang.System.getProperty( "common.pom" ) )

plugin( :war, '2.2',
        :warSourceDirectory => '${public.dir}',
        :warSourceExcludes => [ 'WEB-INF/classes/gems/jruby-jars-*/**',
                                'WEB-INF/classes/bin/**',
                                'WEB-INF/classes/cache/**',
                                'WEB-INF/classes/doc/**',
                                'WEB-INF/classes/build_info/**' ].join(','),
        :webResources => [ { :directory => '${base.dir}',
                             :targetPath => 'WEB-INF',
                             :includes => [ 'Gemfile*',
                                            'db/**/*',
                                            'app/**/*',
                                            'lib/**/*',
                                            'vendor/**/*',
                                            'config/**/*' ]
                           } ],
        :webXml => '${webinf.dir}/web-pack.xml' )

# vim: syntax=Ruby
