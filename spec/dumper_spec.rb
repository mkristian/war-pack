load File.expand_path(File.join('spec', 'setup.rb'))
require 'war_pack/dumper'
require 'fileutils'
class Dumper < WarPack::Dumper
  def pom_file
    File.join( 'pkg', 'dummy' )
  end
end

describe WarPack::Dumper do

  let( :workdir ) { 'pkg' }
    
  let( :dummy ) { File.join( workdir, 'dummy' ) }
    
  let( :target ) { File.join( workdir, 'target' ) }
    
  let( :config ) { {} }

  subject { Dumper.new( config ) }

  before do
    FileUtils.mkdir_p( workdir )
    File.open( dummy, 'w' ) { |f| f.puts 'dummy' }
  end

  it 'creates file' do
    config[ 'mode' ] = 'create'
    FileUtils.rm_f( target )
    subject.dump( target )
    File.exists?( target ).must_equal true
    lambda{ subject.dump( target ) }.must_raise RuntimeError
  end

  it 'overwrites file' do
    config[ 'mode' ] = 'overwrite'
    FileUtils.rm_f( target )
    FileUtils.touch( target )
    subject.dump( target )
    File.exists?( target ).must_equal true
    File.size( target ).wont_equal 0
  end

  it 'append file' do
    config[ 'mode' ] = 'append'
    FileUtils.rm_f( target )
    FileUtils.touch( target )
    subject.dump( target )
    File.exists?( target ).must_equal true
    size = File.size( target )
    size.wont_equal 0
    subject.dump( target )
    File.size( target ).must_equal 2*size
  end

  it 'append plugin only' do
    config[ 'mode' ] = 'append_plugin'
    FileUtils.rm_f( target )
    FileUtils.touch( target )
    subject.dump( target )
    File.exists?( target ).must_equal true
    size = File.size( target )
    size.wont_equal 0
    File.read( dummy ).strip.must_equal File.read( target ).gsub( /^#.*/, '' ).strip
    subject.dump( target )
    File.size( target ).must_equal 2*size
    ( File.read( dummy ).strip * 2 ).must_equal File.read( target ).gsub( /^#.*/, '' ).strip.gsub( /\n/, '' )
  end
end
