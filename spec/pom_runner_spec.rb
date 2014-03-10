load File.expand_path(File.join('spec', 'setup.rb'))
require 'war_pack/pom_runner'
require 'yaml'
describe WarPack::PomRunner do

  let( :workdir ) { 'pkg' }
  let( :webxml ) { File.join( workdir, 'public', 'WEB-INF', 'web.xml' ) }
    
  let( :config ) { {} }

  subject { WarPack::PomRunner.new( config ) }

  before do
    configdir = File.join( workdir, 'config' )
    FileUtils.mkdir_p( configdir )
    FileUtils.touch( File.join( configdir, 'application.rb' ) )
  end

  it 'has defaults' do
    opts = subject.maven.options.dup
    pwd = File.expand_path( '.' )
    opts.each do |k,v|
      v.sub!( /^#{pwd}/, '') if v.is_a? String
    end
    expected = {
      "-Dbase.dir"=>"", 
      "-Drun.port"=>8080, 
      "-Drun.sslport"=>8443, 
      "-Drun.keystore"=>"/lib/war_pack/server.keystore", 
      "-Drun.keystore.pass"=>"123456", 
      "-Drun.truststore.pass"=>"123456", 
      "-Dcommon.pom"=>"/lib/war_pack/common_pom.rb", 
      "-Dverbose"=>false,
      "-q"=>nil, 
      "-Dfinal.name"=>"war-pack",
      "-f"=>"Mavenfile"
    }
    opts.to_yaml.must_equal expected.to_yaml
  end

  it 'takes config' do
    config[ 'keystore' ] = 'ks'
    config[ 'keystore.pass' ] = 'secret'
    config[ 'truststore.pass' ] = 'more secret'
    config[ 'sslport' ] = 443
    config[ 'port' ] = 80
    config[ 'publicdir' ] = '.'
    config[ 'workdir' ] = 'target'
    config[ 'final_name' ] = 'mine'
    config[ 'debug' ] = true
    config[ 'verbose' ] = true
    config[ 'mavenfile' ] = nil
    opts = subject.maven.options.dup
    pwd = File.expand_path( '.' )
    opts.each do |k,v|
      v.sub!( /^#{pwd}/, '') if v.is_a? String
    end
    expected = {
      "-Dbase.dir"=>"", 
      "-Dpublic.dir"=>"", 
      "-Dwork.dir"=>"/target", 
      "-Drun.port"=>80, 
      "-Drun.sslport"=>443, 
      "-Drun.keystore"=>"ks", 
      "-Drun.keystore.pass"=>"secret", 
      "-Drun.truststore.pass"=>"more secret", 
      "-Dcommon.pom"=>"/lib/war_pack/common_pom.rb", 
      "-Dverbose" => true,
      "-X"=>nil, 
      "-Dfinal.name"=>"mine",
    }
    opts.to_yaml.must_equal expected.to_yaml
  end

  it 'detects rails' do
    subject.rails?.must_equal false
    FileUtils.chdir( workdir ) do
      subject.rails?.must_equal true
    end
  end

  it 'copies web.xml if missing' do
    FileUtils.rm_f( webxml )
    FileUtils.chdir( workdir ) do
      subject.copy( 'web.xml' )
    end
    File.exists?( webxml ).must_equal true
  end

  it 'does not copy web.xml if it already exists' do
    FileUtils.rm_f( webxml )
    FileUtils.touch( webxml )
    FileUtils.chdir( workdir ) do
      subject.copy( 'web.xml' )
    end
    File.exists?( webxml ).must_equal true
    File.size( webxml ).must_equal 0
  end

end
