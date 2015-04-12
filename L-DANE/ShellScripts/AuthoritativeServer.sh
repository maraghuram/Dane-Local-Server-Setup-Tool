#! bin/sh
cd ShellScripts
dig @f.root-servers.net . axfr +onesoa | grep -v DNSKEY > root.zone
named-checkzone . root.zone
cat root.zone | awk -f sc1.awk > root.zone
cat rootConfig.txt >> root.zone
echo $1"            86400    IN      NS        "$2 >> root.zone
cat locConfig.txt > loc.zone
echo $1"            86400    IN      NS        "$2 >> loc.zone
cat bindConfig.txt > named.conf

mv -f root.zone /etc/bind/root.zone
mv -f loc.zone /etc/bind/loc.zone
mv -f named.conf /etc/bind/named.conf

cd /etc/bind

dnssec-keygen -r /dev/urandom -a RSASHA256 -b 2048 -n ZONE .
dnssec-keygen -r /dev/urandom -a RSASHA256 -b 4096 -f KSK  -n ZONE .
cat K.+008+*.key >> root.zone
dnssec-signzone -o . -t -R -S root.zone

dnssec-keygen -r /dev/urandom -a RSASHA256 -b 2048 -n ZONE loc
dnssec-keygen -r /dev/urandom -a RSASHA256 -b 4096 -f KSK -n ZONE loc
kskFile=`ls -1t | head -n 2 | grep -E "*.key"`

named-checkconf-z
service bind9 start
errorFlag=`tail -n 50 /var/log/syslog | grep error`
rndc sign loc
dig @localhost soa loc +dnssec +m
dsRecord=`dnssec-dsfromkey $kskFile`

echo "ttl 86400" > nsFile.txt
echo "$dsRecord" | awk '{print "add " $0}' >> nsFile.txt
echo "send" >> nsFile.txt
echo "quit" >> nsFile.txt
nsupdate -l -v nsFile.txt








