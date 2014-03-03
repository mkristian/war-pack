#-*- mode: ruby -*-

gemfile

jruby_plugin! :gem#, :gemUseSystem => true

jruby_plugin :minitest do
  execute_goals( :spec )
end

properties( 'jruby.versions' => ['1.6.8','1.7.10'].join(','),
            'jruby.modes' => ['1.8', '1.9', '2.0'].join(','),
            # just lock the versions
            'jruby.version' => '1.7.10',
            'tesla.dump.pom' => 'pom.xml',
            'tesla.dump.readonly' => true )

plugin :invoker, '1.8' do
  execute_goals( :run,
                 :id => 'integration-test',
                 :projectsDirectory => 'integration',
                 :streamLogs => true,
                 :pomIncludes => [ '*' ],
                 :preBuildHookScript => 'setup',
                 :postBuildHookScript => 'verify' )
end

# vim: syntax=Ruby
