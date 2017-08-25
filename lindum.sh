#!/bin/bash
normal='\e[0m'
blue='\e[1;94m'
red='\e[1;31m'
yellow='\e[1;33m'
ul='\e[1;4m'
purp='\e[1;35m'
green='\e[1;32m'

echo -e "$green"
echo ' __    _____ _____ ____  _____ _____ '
echo '|  |  |     |   | |    \|  |  |     |'
echo '|  |__|-   -| | | |  |  |  |  | | | |'
echo '|_____|_____|_|___|____/|_____|_|_|_|'
echo -e "|       CODED BY$purp @rebellionil   "
if [[ -d .workspace ]] ; then rm -rf .workspace ; fi
mkdir .workspace
cd .workspace

if [[ $1 == "-u" ]] ; then
	target=$2
elif [[ $3 == "-u" ]] ; then
	target=$4
else
	echo "Usage. ./$0 -u Target_url -r Number_of_rounds -f file_types"
	echo "eg. ./$0 -u google.com -r 5"
        echo "eg. ./$0 -u google.com -r 3 -f .php,.pdf,.png"
	exit
fi
echo -e "${green}|"
if [[ $1 == "-r" ]] ; then
        round=$2
elif [[ $3 == "-r" ]] ; then
        round=$4
fi

if [[ $1 =~ "http://" || "https://" ]] ; then
        url=`echo $target | sed 's/http\:\/\///g'|  sed 's/https\:\/\///g' | cut -d "/" -f1`
else
        url=`echo $target | cut -d "/" -f1`
fi

x=1
y=2
z=3
f=$( echo $6 | sed 's/,/ -e /g' )
fo=$5

echo -e "${red}|__ ${purp}`date | awk {' print $4 '}`${red}|$yellow Target :${red} $url ${yellow}Number Of Rounds ($round)$normal"
function a {
echo -e "${red}|__ ${purp}`date | awk {' print $4 '}`${red}|$yellow Start Links ${red}Dumping$yellow At Round $x $normal"
lynx -dump $url | grep $url | awk {' print $2 '} | sort -u | grep -v "javascript" | grep -ve '>' -e "<" | grep -e ^"http" -e ^"www" > $x.txt 2> /dev/null
for i in `cat $x.txt | sort -u` ; do
        if [[ $fo == '-f' ]] ; then
	       echo -e "${red}	|__${purp}`date | awk {' print $4 '}`${red}|${red} $i $normal" | grep -e "Found" -e "Start" -e "Target" -e $f
	       sleep 0.005
        else
               echo -e "${red}	|__${purp}`date | awk {' print $4 '}`${red}|${red} $i $normal" # | grep -e "Found" -e "Start" -e "Target" -e $f
               sleep 0.005
        fi
done

echo -e "${red}|__ ${purp}`date | awk {' print $4 '}`${red}|$red `wc -l $x.txt | awk {' print $1 '}`${yellow} Links Found $normal"
if [[ `wc -l $x.txt | awk {' print $1 '}` == "0" ]] ; then
                echo -e "${red}	|${purp}`date | awk {' print $4 '}`${red}|__ Exit"
                exit 0
        fi
}
a

for round in `seq 2 $round` ; do
	echo -e "${red}|__ ${purp}`date | awk {' print $4 '}`${red}|$yellow Start Links ${red}Dumping$yellow At Round $y $normal"
	for i in `cat $x.txt` ; do
       		v=`lynx -dump $i | grep $url | awk {' print $2 '} | grep -ve '>' -e "<" 2> /dev/null`
		for b in $( echo $v 2> /dev/null ) ; do
                        if [[ $fo == '-f' ]] ; then
	           		echo -e "${red}	|__ ${purp}`date | awk {' print $4 '}`${red}|$yellow $b" | grep -e "Found" -e "Start" -e "Target" -e $f
                        else
				echo -e "${red}	|__ ${purp}`date | awk {' print $4 '}`${red}|$yellow $b"
                        fi
			echo $b >> $y.txt &
		done
	done
	wait
	if ! [[ -f $y.txt ]] ; then
		echo -e "${red}|__${purp}`date | awk {' print $4 '}`${red}|$red 0${yellow} Links Found $normal"
		break
	fi
	comm -13 <(sort $x.txt ) <(sort $y.txt ) | sort -u > $z.txt
        if [[ -f $z.txt ]] ; then
		echo -e "${red}	|${green}+${red}|_ ${purp}`date | awk {' print $4 '}`${red}| ${yellow}Found"
		for i in `cat $z.txt` ; do
       			echo -e "${red}	|__ ${purp}`date | awk {' print $4 '}`|${green} $i $normal"
		done
	echo -e "${red}|__ ${purp}`date | awk {' print $4 '}`${red}|$red `wc -l $z.txt | awk {' print $1 '}`${yellow} Links Found $normal"
	elif [[ `wc -l $z.txt | awk {' print $1 '}` == "0" ]] ; then
		break
	fi
	let x+=1
	let y+=1
	let z+=1
done
exit 0

