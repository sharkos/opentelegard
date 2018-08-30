=begin

===============================================================================
                 OpenTG (Telegard/2)  http://www.opentg.org                    
===============================================================================

See "LICENSE" file for distribution and copyright information. 
 
---[ File Info ]-------------------------------------------------------------

 Source File: /lib/dbmodels/bbslist.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: BBS List Schema for Database

-----------------------------------------------------------------------------


=begin rdoc
= Tgdatabase_models (Database Models)
Tgdatabase_models defines the Sequel Model classes for the data structures.

== BBSlist Structure

=end


# Chat Room Structure
class Tgbbslist < Sequel::Model(:bbslist)
  Tgio.printstart " DB Model: bbslist"

  if empty?
    create  :bbsname => 'OpenTelegard Official BBS',
            :description => 'The official OpenTelegard BBS. This server runs official releases and is a full-production system.',
            :sysopname => 'TELEGARDIAN',
            :bbsurl => 'ssh://telegard:opentg@bbs.telegard.org',
            :homepage => 'http://www.telegard.org/bbslist',
            :submitted_by => '(OPENTG)',
            :created => Time.now

    create  :bbsname => 'OpenTelegard AlphaSite',
            :description => 'AlphaSite is a project sponsored server running current code from the source tree. Users can expect missing features, occasional crashes, and frequent database refreshes. This server should not be used in production.',
            :sysopname => 'TELEGARDIAN',
            :bbsurl => 'ssh://telegard:opentg@alpha.telegard.org',
            :homepage => 'http://www.telegard.org/bbslist',
            :submitted_by => '(OPENTG)',
            :created => Time.now



  end
  Tgio.printreturn(0)
end
