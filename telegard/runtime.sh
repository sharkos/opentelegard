#!/bin/bash
#
#=============================================================================
#                 OpenTG (Telegard/2)  http://www.opentg.org                    
#=============================================================================
#
#See "LICENSE" file for distribution and copyright information. 
# 
#---[ File Info ]-------------------------------------------------------------
#
# Source File: runtime.sh
#     Version: 1.00
#   Author(s): Chris Tusa <chris.tusa@opentg.org>
# Description: BASH Shell script which sets the environment variables.
#
# 
# To use this file, from your bash shell, enter:  'source ./runtime.sh'
#
#-----------------------------------------------------------------------------
#
JAVA_HOME=/opt/telegard/contrib/jdk
JRUBY_HOME=/opt/telegard/contrib/jruby
PATH=$JAVA_HOME/bin:$JRUBY_HOME/bin:$PATH
