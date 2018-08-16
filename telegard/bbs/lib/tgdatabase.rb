=begin
               ================================================
                      OpenTelegard/2 Operating SubSystem
                  Copyright (C) 2010, LeafScale Systems, LLC
                           http://www.telegard.org
               ================================================


---[ License & Distribution ]------------------------------------------------

Copyright (c) 2008-2011, Chris Tusa & LeafScale Systems, LLC
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

    * Redistributions of source code must retain the above copyright notice,
      this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of LeafScale Systems nor the names of its contributors
      may be used to endorse or promote products derived from this software
      without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.


---[ File Info ]-------------------------------------------------------------

 Source File: /db/tgdatabase.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@telegard.org>
 Description: Database Handlers

-----------------------------------------------------------------------------
=end

=begin rdoc               
= Tgdatabase (Database)
Tgdatabase provides the database connectivity and initialization routines.

== Embedded
OpenTelegard includes an embedded database option for installations that do
not need a larger database server, or for users not comfortable managing
a database engine separately. H2 is the included database, and is provided
as a JAR file with the distribution. see (http://h2database.com).

== Remote
For larger deployments, cloud deployments, or for advanced users, OpenTelegard
supports external database connections. remote is only tested against Postgresql,
but should work on any Sequel JDBC compatible server.

=end

module Tgdatabase
  require 'rubygems'
  require 'sequel'
#  Sequel::Model.plugin(:schema)  # This plugin was depreacted in gem Sequel >= v4.5
  Sequel::Model.plugin(:skip_create_refresh)
  
  # Create Database Connection based on type of either H2 Embedded or External Remote.
  def Tgdatabase.connect(db)
    dbpwd = Security::ConfigPassword.new.decrypt(db['pass'])
    if db['type'] == "remote"
      begin
        Sequel.connect("#{db['driver']}://#{db['host']}/#{db['name']}?user=#{db['user']}&password=#{dbpwd}")
      # TODO: Try to enhance this rescue as it doesn't seem to respond to JDBC driver errors.
      rescue Exception, NativeException, Sequel::DatabaseConnectionError => e
        raise "ERROR: Unable to connect to remote database. (#{e})"
      end
    elsif db['type'] == "embedded"
      # -> Try to load Java support
      begin
        require 'java'
      rescue LoadError
        raise "FATAL: Unable to load JAVA hooks. OpenTG requires JRuby >= 2.5.0"
      end
      # -> Try to load H2 Database from JAR.
      # (instead of using the GEM for jdbc-h2 which tends to be outdated)
      begin
        require 'class/h2.jar'          # This loads the entire DB engine from jar
        Java::org.h2.Driver             # This loads the native JDBC driver
      rescue LoadError
        raise "ERROR: unable to load embedded database engine."
      end
      # -> Try to connect to H2 Database from Sequel.
      begin
        Sequel.connect("jdbc:h2:tcp://localhost/opentg", :user => "#{db['user']}", :password=>dbpwd)
      rescue Sequel::DatabaseConnectionError => e
        raise "ERROR: Unable to connect to embedded database. (#{e})"
      rescue Java::NativeException => e
        raise "ERROR: Unable to connect to embedded database. (#{e})"
      end

    else
      puts "FATAL: Database type has been improperly set or is missing."
      exit 100
    end

  end #/def connect


  # => Initialize the database (reserved)
  def Tgdatabase.initdb
    # THIS IS PROBABLY NOT NEEDED AS THIS IS HANDLED VIA Sequel::Model - BUT RESERVE THE NAME
  end #/dev init
  
end # /module
