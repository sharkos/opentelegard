=begin

===============================================================================
                 OpenTG (Telegard/2)  http://www.opentg.org                    
===============================================================================

See "LICENSE" file for distribution and copyright information. 
 
---[ File Info ]-------------------------------------------------------------

 Source File: /lib/rubyclass_extensions.rb
     Version: 0.01
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: Extends built-in Ruby Classes to enhance functionality. 

-----------------------------------------------------------------------------
=end

=begin rdoc
= Ruby:: Class Extensions
This library extends built in Ruby Classes to add additional features.
=end

# Java Class Mix-Ins
require 'java'

# Imports java.lang as Ruby::JavaLang
module JavaLang
    include_package "java.lang"
end

# Imports java.io as Ruby::JavaIO
module JavaIO
    include_package "java.io"
end

# Imports java.util as Ruby::JavaUtil
module JavaUtil
    include_package "java.util"
end

# Imports JLine Jar for ANSI Console Functions
require 'class/jline.jar'
module JLine
  include_package "jline"  
end

# Import the ApacheCommonsLang Library
require 'class/commons-lang3.jar'
module ApacheCommonsLang
  include_package "org.apache.commons.lang3"
end

# Imports the Validation Jar file from Apache Commons
#require 'class/jakarta-oro.jar' # ORO is a retired Apache project 20180820 - lets see what happens if we disable it
require 'class/commons-validator.jar'
module ApacheCommonsValidator
  include_package "org.apache.commons.validator"    
end

# OLD VALIDATION LIBRARY (replaced with Apache Commons)
# require 'class/validator.jar'
# module Validation
#   include_package "com.jgoodies.validation.util"
# end

# Imports the JaSypt encryption library
require 'class/jasypt.jar'
module JasyptPBE
  include_package "org.jasypt.encryption.pbe"
end

module JasyptSalt
  include_package "org.jasypt.salt"
end

module JasyptText
  include_package "org.jasypt.util.text"
end


# Extends fixunum class for some date/time shortcuts.
class Integer
  # Default fixnum class is in seconds (self).
  def seconds
    self
  end

  # Convert number of minutes to seconds (self).
  def minutes
    self * 60
  end

  # Convert number of hours to seconds (self).
  def hours
    self * 60 * 60
  end
  # Alias for hours when using a single hour grammar
  def hour
    self * 60 * 60
  end

  # Convert number of days to seconds (self)
  def days
    self * 60 * 60 * 24
  end
  # Convert Seconds to Minutes
  def sec_to_min
    self / 60
  end
end #/class Fixnum


# Extend the String Class with validation methods
class String
  # Return true if string contains only Alpha characters
  def is_alpha?
    ApacheCommonsLang::StringUtils.isAlpha(self)
  end

  # Returns true if string constains only Numeric characters
  def is_numeric?
    ApacheCommonsLang::StringUtils.isNumeric(self)
  end

  # Returns true if string is AlphaNumeric
  def is_alphanumeric?
    ApacheCommonsLang::StringUtils.isAlphanumeric(self)
  end

  # Return true if string contains only Alpha characters
  def is_spaced_alpha?
    ApacheCommonsLang::StringUtils.isAlphaSpace(self)
  end

  # Returns true if string constains only Numeric characters
  def is_spaced_numeric?
    ApacheCommonsLang::StringUtils.isNumericSpace(self)
  end

  # Returns true if string is AlphaNumeric
  def is_spaced_alphanumeric?
    ApacheCommonsLang::StringUtils.isAlphanumericSpace(self)
  end

  # Returns true if string is Blank. Similar to empty,
  # but looks for whitespace entries. 
  def is_blank?
    ApacheCommonsLang::StringUtils.isBlank(self)
  end

  # Returns true if string is NOT Blank.
  def is_notblank?
    ApacheCommonsLang::StringUtils.isNotBlank(self)
  end

  # Returns true if string meets email address criteria
  # Pure Ruby way, replaced with Apache Commons Validator
  #def is_email?
  #  if /^([0-9a-zA-Z]+[-._+&amp;])*[0-9a-zA-Z]+@([-0-9a-zA-Z]+[.])+[a-zA-Z]{2,6}$/.match(self)
  #    return true
  #  else
  #    return false
  #  end
  #end
  def is_email?    
    ApacheCommonsValidator::GenericValidator.isEmail(self)
  end

  # Returns true if string is a valid url
  def is_url?
    ApacheCommonsValidator::GenericValidator.isUrl(self)
  end

  # Returns true if string meets minimum length
  def minlength?(size)
    ApacheCommonsValidator::GenericValidator.minLength(self,size)
  end

  # Returns true if string meets maximum length
  def maxlength?(size)
    ApacheCommonsValidator::GenericValidator.maxLength(self,size)
  end

  # Returns true if string size is within bounds.
  def inbounds(min, max)
     ApacheCommonsValidator::GenericValidator.isInRange(self.length, min, max)
  end

end #/class String

# Extends TrueClass for Boolean Functions
class TrueClass
  # Flip the bit on a Boolean - True becomes False
  def toggle
    if self == true
      return false
    else
      return true
    end
  end
end

# Extends FalseClass for Boolean Functions
class FalseClass
  # Flip the bit on a Boolean - False becomes True
  def toggle
    if self == false
      return true
    else
      return false
    end
  end
end

# Load FFI Support
require 'ffi'

# LIBC exec call.
module JExec
    extend FFI::Library
    ffi_lib("c")
    attach_function :execvp, [:string, :pointer], :int
    attach_function :fork, [], :int
end
