#!/bin/bash
#               ================================================
#                      OpenTelegard/2 Operating SubSystem
#               Copyright (C) 2008-2011   LeafScale Systems, LLC
#                           http://www.telegard.org
#               ================================================
#
#
# ---[ License & Distribution ]------------------------------------------------
#
# Copyright (c) 2008-2011, Chris Tusa & LeafScale Systems, LLC
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
#    * Redistributions of source code must retain the above copyright notice,
#      this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above copyright
#      notice, this list of conditions and the following disclaimer in the
#      documentation and/or other materials provided with the distribution.
#    * Neither the name of LeafScale Systems nor the names of its contributors
#      may be used to endorse or promote products derived from this software
#      without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
#
#---[ File Info ]-------------------------------------------------------------
#
# Source File: /h2.init.sh
#     Version: 1.00
#   Author(s): Chris Tusa <chris.tusa@telegard.org>
# Description: Generic Shell script to start/stop H2 database
#
#-----------------------------------------------------------------------------

# The install path or symlink to the Telegard installation bbs directory
TELEGARD_HOME=/opt/telegard/bbs

## TODO: This path is hardset due to a bug in h2 that does not follow symlinks-waiting for maintainer to fix. 
#TELEGARD_HOME=/media/dstick/data/repos/telegard/bbs
##

H2_HOME=$TELEGARD_HOME/class
echo Using Embedded Database Engine in $TELEGARD_HOME
case $1 in
  start)
    cd $H2_HOME
    echo "Starting H2 Database Server"
    java -cp $H2_HOME/h2.jar org.h2.tools.Server -tcpDaemon -baseDir $TELEGARD_HOME/db &
  ;;
  stop)
    echo "Shutting down H2 Database Server"
    java -cp $H2_HOME/h2.jar org.h2.tools.Server -tcpShutdown "tcp://localhost"
  ;;
  web)
    echo "Starting H2 Web Server Admin Tool :: [CTRL-C] to terminate..."
    java -cp $H2_HOME/h2.jar org.h2.tools.Server -web -baseDir $TELEGARD_HOME/db
    #echo "NOTE: The webserver administration tool must be"
    #echo "      shutdown from either the browser interface"
    #echo "      or by killing the PID of the service."
  ;;
  webremote)
    echo "Starting H2 Web Server Admin Tool :: [CTRL-C] to terminate..."
    echo "                    *** !!! WARNING !!!! ***"
    echo ""
    echo "THIS MODE PERMITS REMOTE ACCESS TO YOUR MASTER DATABASE FROM THE INTERNET!"
    echo "DO NOT LEAVE THE ADMIN WEB SERVER RUNNING!!          YOU HAVE BEEN WARNED!"
    echo ""
    java -cp $H2_HOME/h2.jar org.h2.tools.Server -webAllowOthers
  ;;
  backup)
    echo "Taking backup of H2 Database (opentg)"
    java -cp $H2_HOME/h2.jar org.h2.tools.Backup -file "$TELEGARD_HOME/db/backup.zip" -dir "$TELEGARD_HOME/db" -db "opentg"
  ;;
  sqldump)
    java -cp $H2_HOME/h2.jar org.h2.tools.Script -url jdbc:h2:tcp://localhost/opentg -user '' -script $TELEGARD_HOME/sqldump.zip -options compression zip
  ;;
  *)
    echo "Syntax is: h2 [start | stop | web | webremote | backup | sqldump]"
  ;;
esac
