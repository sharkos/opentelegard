=begin

===============================================================================
                 OpenTG (Telegard/2)  http://www.opentg.org                    
===============================================================================

See "LICENSE" file for distribution and copyright information. 
 
---[ File Info ]-------------------------------------------------------------

 Source File: lib/tgdatabase.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: Database Connectivity

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
    # DEPRECATION WARNING: Remote option will go away in favor of H2
    if db['type'] == "remote"
      begin
        require 'class/h2.jar'          # This loads the entire DB engine from jar
        Java::org.h2.Driver             # This loads the native JDBC driver
        Sequel.connect("#{db['driver']}:tcp://#{db['host']}/#{db['name']}", :user=> "#{db['user']}", :password=> "#{dbpwd}")
      # TODO: Try to enhance this rescue as it doesn't seem to respond to JDBC driver errors.
      rescue Exception, NativeException, Sequel::DatabaseConnectionError => e
        raise "ERROR: Unable to connect to remote database. (#{e})"
      end
    elsif db['type'] == "embedded"
      # -> Try to load Java support
      begin
        require 'java'
      rescue LoadError
        raise "FATAL: Unable to load JAVA hooks. Missing JRuby >= 9.2.0"
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
