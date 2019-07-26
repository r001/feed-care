#!/usr/bin/env bash
DIR=/root/.scripts
#DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. "$DIR/alert_lib.sh"
. "$DIR/alert.conf"
function messageuser {
	if (( $running_client < 2  )); then 
		printf "Alert from VOX!\r\n\r\n\
			Only $running_client node is available, please make more redundancy!\r\n\r\n\
			Best regards\r\n\
			cron@"`hostname`":$DIR/`basename "$0"`"\
			|/usr/bin/mail -a "X-Priority:1" -s "Vox alert - $running_client Ethereum node left!" $EMAIL
	fi
}

# Global configuration
if [[ -e /etc/setzer.conf ]]; then
  # shellcheck source=/dev/null
  . "/etc/setzer.conf"
  #verbose "Imported configuration from /etc/setzer.conf"
fi

checketh

if [ "${running_client:-0}" -ge 1 ]; then
  export PATH="$PATH:/usr/local/bin/:/usr/bin/"
  log "Node count: $running_client."
  messageuser
else
  running_client=0
  log "Node count: $running_client."
  messageuser
fi
