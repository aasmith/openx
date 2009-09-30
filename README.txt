= openx

* http://openx.rubyforge.org

== DESCRIPTION:

A Ruby interface to the OpenX XML-RPC API.

== SYNOPSIS:

  OpenX::Services::Base.configuration = {
    'username'  => 'admin',
    'password'  => 'password',
    'url'       => 'http://localhost/www/api/v2/xmlrpc/',
  }

  OpenX::Services::Agency.find(:all).each do |agency|
    puts agency.name

    # Look up publishers
    agency.publishers.each do |publisher|
      puts "-- #{publisher.name}"
    end

    # Create a publisher
    Publisher.create!(
      :agency       => agency,
      :name         => 'My Test Publisher',
      :contact_name => 'Aaron Patterson',
      :email        => 'aaron@tenderlovemaking.com',
      :username     => 'user',
      :password     => 'password'
    )
  end

== REQUIREMENTS:

* ruby

== INSTALL:

* sudo gem install openx
* Update your $HOME/.openx/credentials.yml file.  Here is a sample:

  ---
  production:
    username: admin
    password: admin
    url: http://www.example.com/www/api/v2/xmlrpc/
    invocation_url: http://www.example.com/www/delivery/axmlrpc.php

The YAML file lists configuration for each environment.  The gem uses the
'production' environment by default. Trailing slash is required on the 'url'.
'invocation_url' is only used by the OpenX::Invocation methods to serve 
advertisements over XML-RPC

== LICENSE:

(The MIT License)

Copyright (c) 2008:

* {Aaron Patterson}[http://tenderlovemaking.com]
* Andy Smith
* {TouchLocal P/L}[http://www.touchlocal.com]

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
