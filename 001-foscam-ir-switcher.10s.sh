#!/usr/bin/env bash
#
# foscam-ir switcher
#
# <bitbar.author.github>notthetup</bitbar.author.github>
# <bitbar.author>Chinmay Pendharkar</bitbar.author>
# <bitbar.desc>Toggle FOSCAM IR LED</bitbar.desc>
# <bitbar.image></bitbar.image>
# <bitbar.title>foscam-ir-switcher</bitbar.title>
# <bitbar.url>https://github.com/notthetup/xbar-foscam-ir-switcher</bitbar.url>
# <bitbar.version>v1.0</bitbar.version>

# Settings (update these..)
IP_ADDR="192.168.0.1"
USERNAME="admin"
PASSWORD="password"
TIMEOUT=1

get_ir_state() {
	res=$(curl -m $TIMEOUT -s "http://$IP_ADDR/cgi-bin/CGIProxy.fcgi?cmd=getDevState&usr=$USERNAME&pwd=$PASSWORD" | grep "infraLedState")
	state=$(sed "s/<infraLedState>\(.\).*/\1/" <<<"$res")
	echo "$state " | xargs
}

enable_ir(){
	curl -m $TIMEOUT -s "http://$IP_ADDR/cgi-bin/CGIProxy.fcgi?cmd=openInfraLed&usr=$USERNAME&pwd=$PASSWORD"
}

disable_ir(){
	curl -m $TIMEOUT -s "http://$IP_ADDR/cgi-bin/CGIProxy.fcgi?cmd=closeInfraLed&usr=$USERNAME&pwd=$PASSWORD"
}

st=$(get_ir_state)

if [ "$1" == "toggle" ]; then 
	[ "$st" == "0" ] && enable_ir
	[ "$st" == "1" ] && disable_ir
fi 

[ "$st" == "0" ] && echo "🌑"
[ "$st" == "1" ] && echo "🌕"
[ -z "$st" ] && echo "🤷‍♀️"

echo "---"
echo "Toggle IR Switch | shell='$0' param1=toggle"
echo "Open Stream 📽 | href=rtsp://$USERNAME:$PASSWORD@$IP_ADDR:80/videoMain"
