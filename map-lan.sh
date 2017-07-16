#!/bin/bash
normal='\e[0m'
blue='\e[1;34m'
red='\e[1;31m'
yellow='\e[1;33m'
ul='\e[1;4m'
purp='\e[1;35m'
green='\e[1;32m'
white='\e[97m'
function maplan {
   echo
   if [[ -d .workspace ]] ; then rm -rf .workspace ; fi
   mkdir .workspace ; cd .workspace

   function set_interface {
      if ! [[ $( ifconfig wlan0 | awk NR==1 ) =~ "error" ]] ; then
         interface="wlan0"
      elif [[ $(ifconfig eth0) =~ "inet " ]] ; then
         interface="eth0"
      else
         echo "[X] Could Not find stable interface to scan with"
      fi
   }
#  set_interface

   target=$t1
   nmap -sn $target  > nmap.txt
   cat nmap.txt | grep -e "Nmap scan"   | awk {' print $5 '} > ips.txt
   cat nmap.txt | grep -e "MAC Address" | awk {' print $3 '} > macs.txt
   cat nmap.txt | grep -e "MAC Address" | awk {' print $4" "$5" "$6" "$7" "$8'} > vendors.txt
   for i in $( cat ips.txt ) ; do
      echo $i >> nmp.txt
      nmap $i $t2 $t3 $t4 $t5 $t6 $t7 $t8 $t9 $t10 $t11 $t12 | grep -e "open" -e "\|" | grep -ve "Nmap" -e "latency" -e "   STATE" -e "MAC Address:" -e "nmap.org" >> nmp.txt
   done
   x=1
   cat nmp.txt | while read i ; do
      if [[ $i == $( cat ips.txt | awk NR==$x ) ]] && [[ $i != "" ]] ; then
         local_ip=$(ifconfig $interface | grep "inet " | awk {' print $2 '})
         mac_addr=$(ifconfig $interface | grep "ether" | awk {' print $2 '})
         if [[ $i =~ $local_ip ]] ; then
            echo -e "${red}[+] ${blue}$local_ip \t ${yellow}$mac_addr \t ${green}(You)"
         else
            echo -e "${red}[+] $blue`cat ips.txt | awk NR==$x` \t $yellow`cat macs.txt | awk NR==$x` ${green}`cat vendors.txt | awk NR==$x`"
         fi
         let x=$x+1
      else
         if [[ $i =~ '|' ]] ; then
            if [[ $i =~ "VULNERABLE" ]] ; then
              ii=$(echo $i | sed 's/VULNERABLE/\\e[1;31m VULNERABLE/g')
              echo -e "${green}        | $purp $ii"
            else
              echo -e "${green}        | $purp $i"
            fi
         else
            echo -e "${green}     |__ $white $i"
         fi
      fi
   done
}

function stup {
   target="192.168.1.1/24"
   echo -en "${white}[-] Set target to scan [$target] " ; read tt
   if ! [[ $tt == "" ]] ; then
      target=$tt
   fi
   t1=$target
}

function onlan {
   if [[ $target =~ "192.168" ]] ; then
      t5='-PR'
   fi
}
function whatport {
   ports="Well known ports"
   echo -e  "${white}[-] Set port range or spesefic ports to scan "
   echo -en "${white}    eg. 1-500 or 21,445,22,23,139 [$ports] : " ; read pp
   if ! [[ $pp == "" ]] ; then
      ports=$pp
      t6='-p'
      t7=$pp
   fi
}

while true ; do
   clear
   echo -e "$yellow"
   echo '		                             '
   echo '   _____                  .__ ___________  '
   echo '  /     \ _____  ______   |   \__    ___/   '
   echo ' /  \ /  \\__  \ \____ \  |   | |    |     '
   echo '/    Y    \/ __ \|  |_> > |   | |    |      '
   echo '\____|__  (____  /   __/  |___| |____|     '
   echo '        \/     \/|__|                       ' ; echo -en "$white"
   echo '          CODED BY @rebellionil            '  ; echo -e "$green"
   echo ' _______________          |*\_/*|________   '
   echo '|  ___________  |        ||_/-\_|______  | '
   echo '| |           | |        | |           | |  '
   echo '| |   0   0   | |        | |   0   0   | | '
   echo '| |     -     | | MAP IT | |     -     | |  '
   echo '| |   \___/   | | ====== | |   \___/   | | '
   echo '| |___     ___| |  V0.1  | |___________| |  '
   echo '|_____|\_/|_____|  ====  |_______________| '
   echo '..|__|/ \|_|__............._|________|_     '
   echo ' / ********** \           / ********** \   '
   echo '/ ************ \         / ************ \   ' ; echo -en "$purp"
   echo '==========================================='  ; echo -en "$red"
   echo '1) Map and try to discover OSs              ' ; echo -en "$purp"
   echo '==========================================='  ; echo -en "$red"
   echo '2) Map with port and service scan           ' ; echo -en "$purp"
   echo '==========================================='  ; echo -en "$red"
   echo '3) Map with vulnerability scan              ' ; echo -en "$purp"
   echo '==========================================='  ; echo -en "$red"
   echo '4) Map with very advanced and detailed scan ' ; echo -en "$purp"
   echo '==========================================='

   echo  -en "${red}[${yellow}>>>${red}] " ; read nom

   case $nom in
   1)
      stup
      t2='-O'
      t3='-sS'
      t4='--osscan-guess'
      maplan
   ;;
   2)
      stup
      t2='-sS'
      t4='-sV'
      onlan
      whatport
      maplan
   ;;
   3)
      stup
      t2='-sS'
      t4='-sV'
      onlan
      whatport
      t8='--script'
      t9='vuln'
      maplan
   ;;
   4)
      stup
      t2='-sS'
      t4='-sV'
      onlan
      whatport
      t8='--script'
      t9='all'
      t10='-A'
      maplan
   ;;
   *)

   esac
   echo -en "${yellow}[-] Press any key to reload or type exit to exit : " ; read whattodo
   if [[ $whattodo == "exit" ]] ; then
      break
      exit 0
   fi
done
