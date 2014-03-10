eval( File.read( java.lang.System.getProperty( "common.pom" ) ), nil, 
      java.lang.System.getProperty( "common.pom" ) )

plugin( :war, '2.2',
        :warSourceDirectory => '${public.dir}',
        :warSourceExcludes => [ 'WEB-INF/classes/META-INF/maven/*',
                                'WEB-INF/classes/META-INF/MANIFEST.MF',
                                'WEB-INF/classes/gems/jruby-jars-*/**/*',
                                'WEB-INF/classes/bin/*',
                                'WEB-INF/classes/cache/*',
                                'WEB-INF/classes/doc/**/*',
                                'WEB-INF/classes/build_info/*',
                                # resin compiles those files automatically
                                # so we just leave them out
                                'WEB-INF/classes/gems/**/*.java' ].join(','),
        :webResources => [ { :directory => '${base.dir}',
                             :targetPath => 'WEB-INF',
                             :includes => [ 'config.ru',
                                            'Gemfile*' ] },
                           { :directory => '${lib.dir}',
                             :targetPath => 'WEB-INF/classes' } ],
        :webXml => '${webinf.dir}/web-pack.xml' )

# vim: syntax=Ruby
