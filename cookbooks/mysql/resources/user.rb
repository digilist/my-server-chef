#
# Cookbook Name:: mysql
# Resource:: user
#
# Copyright 2013, Markus Fasselt
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

actions :add, :remove

def initialize(*args)
  super
  @action = :add
end

#name of the repo, used for source.list filename
attribute :username, :kind_of => String, :name_attribute => true
attribute :host, :kind_of => [String, Array], :default => 'localhost'
attribute :password, :kind_of => String
attribute :grant, :kind_of => String, :default => 'USAGE'
attribute :database, :kind_of => [String, Array]
attribute :tables, :kind_of => Array, :default => []
