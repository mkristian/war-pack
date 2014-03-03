load File.expand_path(File.join('spec', 'setup.rb'))
require 'war_pack/ports'

describe WarPack::Ports do

#  let( :workdir ) { File.join('pkg', 'tmp') }

  let( :config ) { {} }

  subject { WarPack::Ports.new( config ) }

#  before do
#    FileUtils.mkdir_p(workdir)
#  end

  it 'has defaults' do
    File.exists?( subject.keystore ).must_equal true
    subject.keystore_pass.must_equal( '123456' )
    subject.truststore_pass.must_equal( '123456' )
    subject.port.must_equal( 8080 )
    subject.sslport.must_equal( 8443 )
  end

  it 'takes config' do
    config[ 'keystore' ] = 'ks'
    config[ 'keystore.pass' ] = 'secret'
    config[ 'truststore.pass' ] = 'more secret'
    config[ 'sslport' ] = 443
    config[ 'port' ] = 80
    subject.keystore.must_equal 'ks'
    subject.keystore_pass.must_equal( 'secret' )
    subject.truststore_pass.must_equal( 'more secret' )
    subject.port.must_equal( 80 )
    subject.sslport.must_equal( 443 )
  end
end
