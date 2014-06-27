#-*- mode: ruby -*-

gemfile

#jruby_plugin! :gem, :gemUseSystem => true

jruby_plugin :minitest do
  execute_goals( :spec )
end

snapshot_repository :jruby, 'http://ci.jruby.org/snapshots/maven'

properties( 'jruby.versions' => ['1.5.6','1.6.8','1.7.13','9000.dev-SNAPSHOT'].join(','),
            'jruby.modes' => ['1.8', '1.9', '2.0','2.1'].join(','),
            # just lock the versions
            'jruby.version' => '1.7.13',
            'tesla.dump.pom' => 'pom.xml',
            'tesla.dump.readonly' => true )

#plugin :invoker, '1.8' do
#  execute_goals( :run,
#                 :id => 'integration-test',
#                 :projectsDirectory => 'integration',
#                 :streamLogs => true,
#                 :pomIncludes => [ '*' ],
#                 :preBuildHookScript => 'setup',
#                 :postBuildHookScript => 'verify' )
#end

# vim: syntax=Ruby
