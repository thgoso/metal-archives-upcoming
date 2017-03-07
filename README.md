# metal-archives-upcoming

Downloadoad/show infos for upcoming releases from you favourite metal artists. You can use it with conky or show new releases in other form.

You have to install the package 'jq' like: sudo apt-get install jq

You need to change the file "my_artists.txt" (ONE artist/band per line)


load-releases.sh

Loads upcoming releases from metal-archives for all the artists located in "my_artists.txt". All upcoming releases will be added to your outputfile "my_releases.txt", so you will always be informed. The entries are sortet chronologically and you can manually delete some (or the file). Line format: yyyy-mm-dd TAB Artist TAB Release TAB Format. I use this script with autostart on every system start.


show-releases-xx.sh

This script I use in my ".conkyrc" to display the releases on desktop background with: ${execp show-releases.sh} Script gets the newest 30 releases from file "my_releases.txt" in formated/collored text.

