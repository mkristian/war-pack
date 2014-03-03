#
# Copyright (C) 2014 Christian Meier
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
require 'thor'
require 'war_pack/pack'
require 'war_pack/dump'
module WarPack
  class Cli < Thor

    desc 'pack', 'pack a warfile'
    method_option :workdir, :type => :string, :desc => 'default: pkg'
    method_option :publicdir, :type => :string, :desc => 'default: public'
    method_option :mavenfile, :type => :string, :desc => 'the name has to starts with Mavenfile or has to have .rb extension. empty filename result in using a default file. default: Mavenfile'
    method_option :clean, :type => :boolean, :default => false
    method_option :verbose, :type => :boolean, :default => false
    method_option :debug, :type => :boolean, :default => false
    def pack
      WarPack::Pack.new( options ).pack
    end

    desc 'dump [Mavenfile]', 'dump Mavenfile'
    method_option :mode, :type => :string, :enum => %w(create append overwrite), :default => :create
    def dump( file = 'Mavenfile' )
      WarPack::Dump.new( options ).dump( file )
    end
  end
end
