# websphere unpack war-files 
# force the gem to load instead of bundled default gems
#gem 'jruby-openssl'
#gem 'krypt'

# jruby version 1.7.5-1.7.11 needs those for various servlet containers
require 'bcpkix-jdk15on-1.47.jar'
require 'bcprov-jdk15on-1.47.jar'

# jboss wildfly needs this when deploying packed war files
#ENV['GEM_PATH'] = $servlet_context.getRealPath('/WEB-INF/classes')
