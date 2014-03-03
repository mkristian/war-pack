module WarPack
  
  def self.file( f )
    File.expand_path( File.join( __FILE__.sub( /.rb$/, '' ), f ) )
  end

  def self.common_pom
    file( 'common_pom.rb' )
  end

end
