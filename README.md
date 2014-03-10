# packing war files of rack applications #

## usage ##

    war-pack

will use ```./Gemfile``` to install the gems and will pack a war-file in ```./pkg```

for help and about parameter info, see

    war-pack help pack

## customization ##

for permanent customization (instead of using parameters) and for further customization dump a Mavenfile (which is a ruby DSL of pom.xml from maven.apache.org)

    war-pack dump

there you can further manipulate include patterns as needed. ```war-pack``` will use it when present. to tell ```war-pack``` to not use the Mavenfile you need to add ```--mavenfile=``` to trigger to use the default.

## restrictions ##

the packing is restricted to rack based applications. rails is based on rack as well !

regarding bundler things work OK as long as the application does not depend on the auto-require feature of bundler and has no runtime dependency to bundler itself, i.e. if the application works with

     bundle install --standalone
	 GEM_PATH=not_existing ruby -r./bundle/bundler/setup.rb -S rackup

## standard directory layout ##

    .
    ├── lib # ruby app
    ├── public # public resources
    └── config.ru

after the first run it look slightly different:

    .
    ├── lib # ruby app
    ├── public
    │   └── WEB-INF
    │       ├── classes # contains jruby.home and the installed gems
    │       ├── init.rb # can be used to customize ENV
    │       └── web-pack.xml # packed as web.xml, can be customized
    ├── pkg # work directory, can be deleted any time
    └── config.ru

## what works and what does not work ##

the list is limited to what I have installed locally (any PR to add others to servlet containers is welcome).

### tomcat-7, tomcat-8 ###

deployment as war-file without unpacking just does never finsih deployment, so it just does not work

deployment when the war-file gets unpacked works as is.

works with [jetty-run](../jetty-run) and [tomcat-run](../tomcat-run) gems

### jetty-7, jetty-8, jetty-9 ###

deployment as war-file without unpacking produces lots of error with the packed jar-files from WEB-INF/lib, i.e. does not work

deployment when the war-file gets unpacked works as is.

works with [jetty-run](../jetty-run) and [tomcat-run](../tomcat-run) gems

### websphere ###

some jruby versions needs to explicitly require the bouncy-castle jars see ```public/WEB-INF/init.rb```.

deployment as war-file without unpacking needs to add these default gems to the Gemfile (bundler might not install depending on the jruby version and its default gems):

    gem 'jruby-openssl', :platform => :jruby
    gem 'krypt', :platform => :jruby

as well in ```public/WEB-INF/init.rb``` those gems needs to be activated explicitly with:

    gem 'jruby-openssl'
    gem 'krypt'

the gem-maven-plugin used for packing here does installs those declared gems as needed. with this in place deploment of packed warfiles works.

deployment when the war-file gets unpacked works as is.

### jboss wildfly-8 ###

deployment as war-file without unpacking needs to set GEM_PATH to ```WEB-INF/classes```, see ```public/WEB-INF/init.rb```.

deployment when the war-file gets unpacked works as is.

### resin-4 ###

deployment as war-file always leads to unpacking it (could not find an option to avoid that), i.e. it works as is.

### others servlet containers ###

not tested. also war-files part of an ear-file is not tested !

in general running packed war-files is more likely to have problems then the unpacking deployment.

## notes on how things are done ##

jruby finds gems if they are installed in the root of the classpath, i.e.

    export GEM_HOME=rubygems
    export GEM_PATH=rubygems
    gem install mygem
	GEM_PATH=none_existing java -cp jruby-complete.jar:rubygems org.jruby.Main -S gem list

that will list your ```mygem``` as installed gem, even though the GEM_PATH points to a directory without any gems !!!

this fact is used by the packing that it installes the gems of the application in ```WEB-INF/classes```, then there is in general no need to specify ```gem.path``` for jruby-rack (exception is jboss when deploying packed war-files).

further the classpath is also part of the LOAD_PATH, so putting all the files under ```./lib``` into the ```WEB-INF/classes``` directory, makes them accessible without further manipulation of the LOAD_PATH.

since the default gems became part of jruby-stdlib.jar there are also some packed jars inside that jruby-stdlib.jar. especially when deployment as packed war-file takes place it sounds like asking for problems to load a jar-file from jar-file from war-file. to decrease the amount of trouble the complete jruby-stdlib.jar will be unpacked into ```WEB-INF/classes``` and **not** added to ```WEB-INF/lib``` (that move helped websphere to work when the war gets unpacked on deployment).

the default place to install gems with jruby is ```JRUBY_HOME/lib/ruby/gems/shared```, but that did not work as expected. so ```WEB-INF/classes``` is the better choice since it works for the tested servlet containers.

summarizing the technical details:

    GEM_PATH contains WEB-INF/classes as implicit default
	JRUBY_HOME is WEB-INF/classes/META-INF/jruby.home
	LOAD_PATH contains WEB-INF/classes as implicit default
	
## more ##

probably, but some other time ;)

## contributing ##

1. fork it
2. create your feature branch (`git checkout -b my-new-feature`)
3. commit your changes (`git commit -am 'Added some feature'`)
4. push to the branch (`git push origin my-new-feature`)
5. create new Pull Request

## extra-fu ##

bug-reports and pull request are most welcome. otherwise

enjoy :) 
