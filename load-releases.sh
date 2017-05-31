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



# path/name to your artist-file (ONE artist every line)
file_my_artists="my_artists.txt"
# path/name output-file (new releases will be add here, if file doesn't exist it will be created)
file_my_releases="my_releases.txt"
# path/name tmp-file
file_tmp="my_releases.tmp"

# metal-archives-pages
pge_str_start="https://www.metal-archives.com/release/ajax-upcoming/json/1?sEcho=1&iColumns=4&sColumns=&iDisplayStart="
pge_str_end="&iDisp$"
# agent-name for curl
agent="script_github.com/thgoso/metal-archives-upcoming"


# -------------------------------------------------------------------------------------------------------------------
# save & set new
old_IFS="$IFS"
IFS=$'\n'
# -------------------------------------------------------------------------------------------------------------------
# end if "file_my_artists" doesn't exists
if ! [ -f "$file_my_artists" ] ; then
  echo "$file_my_artists doesn't exists!"
  IFS="$old_IFS"
  exit 1
fi
# -------------------------------------------------------------------------------------------------------------------
# copy current entries from "file_my_releases" to "file_tmp"
if [ -f "$file_my_releases" ] ; then
  cat "$file_my_releases" > "$file_tmp"
fi
# -------------------------------------------------------------------------------------------------------------------
# release-data in multiple files/pages
for pge in "0" "100" "200" "300" "400" "500" "600" "700" "800" "900" ; do
  # load one release-page to "data" and get number of releases in page
  echo "Load: ${pge_str_start}${pge}${pge_str_end}"
  data=$(curl --stderr /dev/null -A "$agent" "${pge_str_start}${pge}${pge_str_end}")
  len=$(echo "$data" | jq '.aaData | length')
  echo "Releases: $len"

  # end if release-page is empty
  if [ "$len" -eq "0" ] ; then
    # sort all releases in "file_tmp", delete duplicates, save "file_my_releases" new, delete "file_tmp"
    cat "$file_tmp" | sort -b | uniq > "$file_my_releases"
    rm -f "$file_tmp"
    echo "New releases added to $file_my_releases"
    IFS="$old_IFS"
    exit 0
  fi

  # extract ALL artists from single release (can be more than one)
  for ((cnt=0;cnt<len;cnt++)) ; do
    unset artists
    artists=($(echo "$data" | jq ".aaData[$cnt][0]" | awk -F ">" '{print $2 $4 $6 $8 $10}' | sed "s/<\/a/\//g" | awk '{print substr($0, 1, length($0)-1)}' | tr "/" "\n"))
    for artist in "${artists[@]}" ; do
      # check if one of the release-artists is equal to one (line) from "file_my_artists"
      check=$(grep -i -x "$artist" "$file_my_artists")
      if [ -n "$check" ] ; then
        # show artist if equal
        echo "Found: $artist"
        # extract/format release-data
        album=$(echo "$data" | jq ".aaData[$cnt][1]" | awk -F '>' '{print substr($2, 1, length($2)-3)}' | sed "s/ \/ /\//g")
        frm=$(echo "$data" | jq ".aaData[$cnt][2]" | awk '{print substr($0, 2, length($0)-2)}' | sed -e "s/set/Set/" -e "s/Full-length/Album/" -e "s/album/Album/")
        tmp=$(echo "$data" | jq ".aaData[$cnt][4]" | awk '{print substr($0, 2, length($0)-2)}' | sed -e 's/st,/,/' -e 's/rd,/,/' -e 's/th,/,/' -e 's/nd,/,/')
        dt=$(date -d "$tmp" "+%Y-%m-%d")
        # add release-data to "file_tmp"
        echo -e "$dt\t$artist\t$album\t$frm" >> "$file_tmp"
      fi
    done
  done
done


