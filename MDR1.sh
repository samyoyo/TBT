#!/bin/bash
normal='\e[0m'
blue='\e[1;94m'
red='\e[1;31m'
yellow='\e[1;33m'
ul='\e[1;4m'
purp='\e[1;35m'
green='\e[1;32m'
white='\e[97m'

echo -en "$white" 
echo '  __  __ ____  ____    _
 |  \/  |  _ \|  _ \  / |
 | |\/| | | | | |_) | | |
 | |  | | |_| |  _ <  | |
 |_|  |_|____/|_| \_\ |_|
'
c=("210" "795" "111" "664" "125" "995" "775" "421" "331" "195" "920" "369" "849" "448" "108" "112" "518" "990" "557" "704" "285" "430" "104" "187" "452" "632" "558" )
a=("0" "1" "2" "3" "4" "5" "6" "7" "8" "9")
b=("M"  ';'  '!'  'F'  "A"  'S'  "X"  "B"  '%'   '#')
p=("MM" ';;' '!!' 'FF' 'AA' 'SS' "XX" "BB" '%%' '##')
l=('@' '}' "U" "O" "H" "P" "L" '{' '0' '?')
var=$2
function enc {
  xx=1
  for i in {a..z} ; do
    char=$( echo $var | sed "s/$i/${c[$xx]}/g" )
    var=$char
    let xx+=1
  done
  for i in `seq 1 9` ; do
    binx=$( echo $var | sed "s/$i/${b[$i]}/g" )
    var=$binx
  done
  for i in $( seq 1 9 ) ; do
    binx=$( echo $var | sed "s/${p[$i]}/${l[$i]}/g" )
    var=$( echo $binx | sed 's/ /V/g' )
  done
}

function key {
  for i in $( seq 1 9 ) ; do
    binx=$( echo $var | sed "s/${l[$i]}/${p[$i]}/g" )
    var=$binx
  done
  for i in $( seq 1 9 ) ; do
    binx=$( echo $var | sed "s/${b[$i]}/$i/g" )
    var=$binx
  done
  xx=1
  for i in {a..z} ; do
    char=$( echo $var | sed "s/${c[$xx]}/$i/g" )
    var=$char
    let xx+=1
  done
  function out_of_scope {
    var2=$( echo $var | sed 's/V/ /g' ) ; var=$var2
    var2=$( echo $var | sed 's/9988/q/g') ; var=$var2
    var2=$( echo $var | sed 's/4388/u/g') ; var=$var2
    var2=$( echo $var | sed 's/7884/s/g') ; var=$var2
    var2=$( echo $var | sed 's/9288/j/g') ; var=$var2
    var2=$( echo $var | sed 's/1884/v/g') ; var=$var2
    var2=$( echo $var | sed 's/1888/n/g') ; var=$var2
  }
  out_of_scope
}
if ! [[ $2 == "" ]] ; then
  if [[ $1 == "-e" ]] ; then
    enc
    echo -e "${yellow} [+] Plain text : $2 "
    echo -e "${green} [+] Encrypted value : $var "
  elif [[ $1 == "-d" ]] ; then
     key
    echo -e "${yellow} [+] Encrypted value : $2 "
    echo -e "${green} [+] Plain text : $var2 "
  else
    echo "Usage. $0 < -d / -e > <input>"
  fi
else
  echo "Usage. $0 < -d / -e > <input>"
fi

