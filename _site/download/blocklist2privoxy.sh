#!/bin/bash
#
# ╔═╗┌─┐─┐ ┬┌─┐┌─┐┬┌┬┐┌─┐
# ╠╣ ├─┤┌┴┬┘│ │├─┘│ │ ├─┤
# ╚  ┴ ┴┴ └─└─┘┴  ┴ ┴ ┴ ┴
# from “The Un-Official Proxomitron Forum”
#
# Improve your Privoxy skills:
# https://www.prxbx.com/forums/forumdisplay.php?fid=49
#
# Add-on to privoxy-adblock
# Rewrite syntax in .action files supplied by `privoxy-adblock.sh`
#
# Script tested successfully with GNU sed 4.2.2. and GNU grep 2.27

# Original script by Faxopita, slightly modified by lls on 2020.10.03
# https://www.prxbx.com/forums/showthread.php?tid=2261

# User-defined Variables:
#
ADB_path="/etc/privoxy"
#
# #######################

echo "Adjusting blocklists syntax"

mkdir -p /tmp/blocklist2privoxy/Converted/ /tmp/blocklist2privoxy/Old/ /tmp/blocklist2privoxy/Diff/

WorkingPathDir="/tmp/blocklist2privoxy"

cd $ADB_path
cp *.script.action $WorkingPathDir/

cd $WorkingPathDir/
cp $ADB_path/*.script.action ./Old/

FileList=*.script.action

for f in $FileList
do
# Deactivation of White List
  sed -r '/^\s*\{\s*-(block|filter)/,/\{-1/ d' $f | \
  sed -r '/^[^.]?http:\/\/(\.\*.*|$)/d' | \

# Deletion of http://
# sed -r '/^[^.]?http:\/\/(\.\*.*|$)/d' $f | \
  sed -r 's/^[^.]?http:\/\//./g' | \

# Path Pattern Format
  sed -r 's/^\//\/(.*\/)?/g' | \

  sed -r 's/^(\\\.[^/[]*\\.)$/\/.*\1/g' | \
  sed -r 's/^(\\\.[^/.[]*\/)$/\/.*\1/g' | \
  sed -r 's/^([^a-zA-Z0-9\.*{/])/\/.*\1/g' | \

  sed -r 's/^(\\[^.])/\/.*\1/g' | \
  sed -r 's/(\\[a-z])/\\\1/g' | \
  sed -r 's/^(\\.[0-9]+(x|X)[0-9]+)/\/.*\1/g' | \
  sed -r 's/^(\\.([^/]+\.)?(css|js|php|json))/\/.*\1/g' | \
  sed -r 's/^(\\.[^./]+(\?|%)[^./]*)/\/.*\1/g' | \
  sed -r 's/^\\.([^/]+)\\.\s*$/.\1./g' | \

# sed -r 's/^\\.(.+\/)\s*$/.\1/g' | \
  sed -r '/^\\\.(1|a)d\//!s/^\\.(.+\/)\s*$/.\1/g' | \

  sed -r 's/^(\\.[^./]+[^a-zA-Z0-9])\s*$/\/.*\1/g' | \

# sed -r 's/^\\.([a-zA-Z]+\/.+)/.\1/g' | \
  sed -r '/^\\\.(1|a)d\//!s/^\\.([a-zA-Z]+\/.+)/.\1/g' | \

  sed -r 's/^\\.([a-zA-Z]+)\\.([a-zA-Z]+\/.+)/.\1.\2/g' | \
  sed -r 's/^(\\.[^./]+\[)/\/.*\1/g' | \
  sed -r 's/^(\\..+)/\/.*\1/g' | \
  sed -r '/^\.[^/]+(\\.[^/]+)?(\/|\.)$/s/\\././g' | \
  sed -r 's/^(\.[^/]+)\/\s*$/\1/g' | \

  sed -r 's/^([a-zA-Z])/\/(.*[^a-z])?\1/g' | \
  sed -r 's/^([0-9])/\/(.*[^0-9])?\1/g' | \
  sed -r 's/\*\+/*\\+/g; s/([^.\])(\+)/\1\\\2/g' | \
# sed -r 's/^\s*\*\s*$/\//g' | \

# Deletion of Duplicates
  awk '!x[$0]++' | \
#
  sed -r 's/^\s*\{/\n{/g' | \
  sed -r 's/netbb-\s*$/net\/bb-/g' | \

  tail -n +2 > TEMP.1

# Host Pattern Format
  sed -r '/^(\.[^/]+\/|\/.+)/!s/\\//g' TEMP.1 > TEMP.2
  sed -r '/^\..+\//!s/.*//g' TEMP.2 | cut -d'/' -f1  | \
  sed -r 's/\\//g; s/([^a-zA-Z0-9])\.\*/\1*/g; s/^(\..+)$/\1\//g' > domains
  sed -r '/^\..+\//!s/.*//g' TEMP.2 | cut -d'/' -f2- > paths
  paste domains paths | tr -d '\011' > TEMP.3

  sed -r '/^\..+\//s/.*//g' TEMP.2 > TEMP.4
  paste TEMP.3 TEMP.4 | tr -d '\011' | \

  sed -r '/^\..+/s/([^\])\.\./\1./g' | \

# Deletion of [/&:?=_] (the set [/&:?=_] has no effect on the Host part)
  sed -r '/^\.[^[]+\[/s/\[\/&:\?=_\]\.\*\//*\/(.*\/)?/g' | \
  sed -r '/^\.[^[]+\[/s/\[\/&:\?=_\]$//g' | \
  sed -r '/^\.[^[]+\[/s/\[\/&:\?=_\]\.\*(\[\/&:\?=_\])?([^/])/*\/.*\2/g' | \
  sed -r '/^\.[^[]+\[/s/\*\[\/&:\?=_\]\/?/*\/(.*\/)?/g' | \
  sed -r '/^\.[^[]+\[/s/\[\/&:\?=_\]\//*\/(.*\/)?/g' | \
  sed -r '/^\/.+\[/s/\[\/&:\?=_\]$//g' | \
  sed -r 's/\.\*$//g' > Converted/$f

  grep -Fvxf Old/$f Converted/$f > Diff/$f
  cat Converted/$f > $ADB_path/$f
done

rm -f TEMP.* domains paths
rm -rf $WorkingPathDir/

echo "Completed! -" $(date -u)
