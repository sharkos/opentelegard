=begin
               ================================================
                      OpenTelegard/2 Operating SubSystem
               Copyright (C) 2008-2018   LeafScale Systems, LLC
                           http://www.telegard.org
               ================================================


---[ License & Distribution ]------------------------------------------------

Copyright (c) 2008-2018, Chris Tusa & LeafScale Systems, LLC
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

 Source File: /lib/telegard.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@telegard.org>
 Description: Main Library

-----------------------------------------------------------------------------
=end

=begin rdoc               
= Telegard (Telegard)
Telegard is the main Telegard library responsible for initialization of sub libraries.
=end

module Telegard

# Load the constants definition
def Telegard.loadlib_tgconstants
  begin
    require 'lib/tgconstants'
  rescue LoadError
    puts "FATAL: cannot load library 'tgconstants'."
    exit 1
  end
end

# Load Library: Security
def Telegard.loadlib_security
  begin
    require 'lib/security'
  rescue LoadError
    puts "FATAL: cannot load library 'security'."
    exit 1
  end
end


# Load Library: Tgio
def Telegard.loadlib_tgio
  begin
    require 'lib/tgio'
    Tgio.mainbanner
  rescue LoadError
    puts "FATAL: cannot load library 'tgio'."
    exit 1
  end
end

# Load Library: Tgconfig
def Telegard.loadlib_tgconfig
  begin
    require 'lib/tgconfig'
  rescue LoadError
    puts "FATAL: cannot load library 'tgconfig'."
    exit 1
  end
end

# Loads configuration into a global $cfg variable
def Telegard.load_tgconfig
  begin
    Tgio.printstart "Loading Telegard configuration"
    $cfg = Tgconfig.load
    Tgio.printreturn(0)
  rescue Exception => e
    Tgio.printreturn(1)
    puts e
    exit 1
  end
end

# Load Library: Tgdatabase
def Telegard.loadlib_tgdatabase
  begin
    require 'lib/tgdatabase'
  rescue LoadError
    puts "FATAL: cannot load library 'tgdatabase'."
    exit 1
  end
end

# Connect to the user specified DB engine & load the Sequel models
def Telegard.load_databaseconn
  begin
    Tgio.printstart "Initializing database connection"
    $db = Tgdatabase.connect($cfg['database'])
    Tgio.printreturn(0)
  rescue Exception => e
    Tgio.printreturn(1)
    puts e
    exit 1
  end
end

# Load Library: Tgdatabase_models
def Telegard.loadlib_tgdatabasemodels
  Tgio.printstart "Initializing Database Models"
  Tgio.printreturn(2)
  begin
    require 'lib/tgdatabase_models'
  rescue LoadError
    puts "FATAL: cannot load library 'tgdatabase_models'."
    exit 1
  rescue Sequel::DatabaseConnectionError => e
    puts "Unable to connect to database: #{e}"
    exit 1
  end
  Tgio.printstart "Database Models Initialized OK"
  Tgio.printreturn(0)
end

# Load Library: Tgtemplate
def Telegard.loadlib_tgtemplate
  begin
    Tgio.printstart "Loading FreeMarker+TG template engine"
    require 'lib/tgtemplate'
    Tgio.printreturn(0)
  rescue LoadError    
    puts "FATAL: cannot load library 'tgtemplate'."
    Tgio.printreturn(1)
    exit 1
  end
end 

# Load Library: Tgcontroller
def Telegard.loadlib_tgcontroller
  begin
    Tgio.printstart "Loading Master Controller"
    require 'lib/tgcontroller'
    Tgio.printreturn(0)
  rescue LoadError
    puts "FATAL: cannot load library 'tgcontroller'."
    Tgio.printreturn(1)
    exit 1
  end
end


# Load the entire stack in the correct order. Use this method for anything that requires full init
def Telegard.init
  self.loadlib_tgconstants
  self.loadlib_tgio
  self.loadlib_tgconfig
  self.load_tgconfig
  self.loadlib_tgdatabase
  self.load_databaseconn
  self.loadlib_tgdatabasemodels
  self.loadlib_tgtemplate
  self.loadlib_tgcontroller
end

# Defines normal goodbye
def Telegard.goodbye
  # TODO: Add askny question, and add any other items here.
  Tgtemplate.display('logout_prompt_goodbye.ftl')
  askuser = Tgio::Input.inputyn
  if askuser == true
    self.goodbye_fast
  end
end

# Defines fast goodbye
def Telegard.goodbye_fast
  puts "Goodbye!"
  # If we have reached this point, the main controller has exited.
  # Terminate the session
  if $session
    $callerid.time_logout = Time.now
    $callerid.save
    $session.destroy
    $session = nil
  end
  exit 0
end  

# Prints a message when a feature is currently not implemented
def Telegard.unimplemented
 puts "En: Sorry! Feature not implemented / De: Element nicht geschrieben"
end

end #/module Telegard
