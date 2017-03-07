#!/bin/bash

# Copyright (C) 2017, Thomas Gollmer, th_goso@freenet.de
# Dieses Programm ist freie Software. Sie können es unter den Bedingungen der GNU General Public License,
# wie von der Free Software Foundation veröffentlicht, weitergeben und/oder modifizieren,
# entweder gemäß Version 3 der Lizenz oder (nach Ihrer Option) jeder späteren Version.
# Die Veröffentlichung dieses Programms erfolgt in der Hoffnung, daß es Ihnen von Nutzen sein wird,
# aber OHNE IRGENDEINE GARANTIE, sogar ohne die implizite Garantie der
# MARKTREIFE oder der VERWENDBARKEIT FÜR EINEN BESTIMMTEN ZWECK.
# Details finden Sie in der GNU General Public License. Sie sollten ein Exemplar der GNU General Public License
# zusammen mit diesem Programm erhalten haben. Falls nicht, siehe <http://www.gnu.org/licenses/>.


# Path/name to file
file_my_releases="my_releases.txt"
# Number of lines you want to show
lines=30
# Colors
col_dt='${color white}'
col_artist='${color yellow}'
col_album='${color green}'
col_frm='${color red}'
col_main='${color black}'



# ----------------------------------------------------------------------------------------------------------------
# end if "file_my_releases" doesn't exists
if ! [ -f "$file_my_releases" ] ; then
  exit 1
fi
# ----------------------------------------------------------------------------------------------------------------
old_IFS="$IFS"
IFS=$'\n'
# ----------------------------------------------------------------------------------------------------------------
# Headline
echo "${col_main}New releases:"
# ----------------------------------------------------------------------------------------------------------------
# Read "lines" lines from file to "data"
data=($(cat "$file_my_releases" | tail -n "$lines"))
# ----------------------------------------------------------------------------------------------------------------
# extract/format data from one line
for line in "${data[@]}" ; do
  artist=$(echo "$line" | awk -F '\t' '{print $2}')
  album=$(echo "$line" | awk -F '\t' '{print $3}')
  frm=$(echo "$line" | awk -F '\t' '{print $4}')
  dt=$(echo "$line" | awk -F '\t' '{print $1}')
  # Output
  echo "$col_dt$dt $col_artist$artist $col_album$album $col_frm$frm"
done
# ----------------------------------------------------------------------------------------------------------------
IFS="$old_IFS"
exit 0

