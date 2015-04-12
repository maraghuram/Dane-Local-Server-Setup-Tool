#! bin/sh
service bind9 stop

# Prepare config file
cat CacheConfig.txt > named.conf
initKey=`dig schnouki.net DNSKEY | sed -n -e 's/^.*DNSKEY\t257//p'`
onlyKey=`echo "$initKey" | sed -n -e 's/^ 3 [0-9] //p'`
echo  " \".\" initial-key 257 3 8    \"$onlyKey\";" >> named.conf
echo "};" >> named.conf

cd /etc/bind

dig @$1 ns . > root.hint
named-checkconf -z
service bind9 start
tail /var/log/syslog
