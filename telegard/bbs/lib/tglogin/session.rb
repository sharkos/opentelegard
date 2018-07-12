=begin
               ================================================
                      OpenTelegard/2 Operating SubSystem
                  Copyright (C) 2010, LeafScale Systems, LLC
                            http://www.opentg.org
               ================================================


---[ License & Distribution ]------------------------------------------------

Copyright (c) 2010, LeafScale Systems, LLC
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

 Source File: /lib/tglogin.rb
     Version: 0.01
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: Handlers for Login/Logout

-----------------------------------------------------------------------------
=end

=begin rdoc
= Tglogin (Login/Logout Routines)
Tglogin handles the procedures for logging into Telegard.
== Configuration Variables (see opentg.conf) $cfg['login']
login:
  attempts: 3
  lockout: 5
  usehint: true

attempts:integer - number of failed attempts to allow before disconnecting.
lockout: integer - number of failed attempts for a single user before setting account to is_locked = true.
usehint: boolean - whether to prompt user for password hint on last attempt before lockout.
allownew:boolean - will the login routine accept new users?

=end

require 'lib/tglogin/signup'
require 'lib/tglogin/session'
