#!/bin/sh

if [ "$#" -lt 5 ] ;then
    echo "Renew Cloudflare DNS Record"
    echo
    echo " Usage: $0 <email> <app-key> <zone-id> <record-id> <domain>"
    exit
fi

EMAIL=$1
API_KEY=$2
ZONE_ID=$3
RECORD_ID=$4
DOMAIN=$5

IP=$(curl -s https://myip.ipip.net |  awk -F'：' '{print $2}' | awk -F' ' '{print $1}')
grep -qF "$IP" /tmp/myip && echo "Unchanged since last renewal, do nothing" && exit

curl -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
     -H "X-Auth-Email: $EMAIL" \
     -H "X-Auth-Key: $API_KEY" \
     -H "Content-Type: application/json" \
     --data '{"type": "A", "name": "'"$DOMAIN"'", "content": "'"$IP"'"}'

echo "$IP" > /tmp/myip
