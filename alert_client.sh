#!/usr/bin/env bash
DIR=/root/.scripts
#DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. "$DIR/alert_lib.sh"
. "$DIR/alert.conf"

function log {
  echo "[$(date "+%D %T")] $*"
}

function messageuser {
	if (( $running_client < 2  )); then 
		printf "Alert from VOX!\r\n\r\n\
			Only $running_client node is available, please make more redundancy!\r\n\r\n\
			Best regards\r\n\
			cron@"`hostname`":$DIR/`basename "$0"`"\
			|/usr/bin/mail -a "X-Priority:1" -s "Vox alert - $running_client Ethereum node left!" $EMAIL
	fi
}

checketh
if [ "${running_client:-0}" -eq 1 ]; then
  export PATH="$PATH:/usr/local/bin/:/usr/bin/"
  
  eval "$( [[ -e /etc/setzer.conf ]] && cat /etc/setzer.conf \
  	  | grep 'export[[:space:]]\+\(RPC_TIMEOUT\|RPC_PORTS\|SETZER_FEED\|SETZER_VERBOSE\|SETZER_CONF\)' \
  	  | sed -e "s/\n/;/g") "
  eval "$( [[ -e $SETZER_CONF ]] && cat $SETZER_CONF \
  	  | grep 'export[[:space:]]\+\(RPC_TIMEOUT\|RPC_PORTS\|SETZER_FEED\|SETZER_VERBOSE\|SETZER_CONF\)' \
  	  | sed -e "s/\n/;/g") "
  
  # Check if connected to node
  export RPC_TIMEOUT=${RPC_TIMEOUT:-15s}
  
  running_client=0
  for PORT in ${RPC_PORTS:-8545}; do
    export ETH_RPC_PORT=$PORT
    log "Trying on rpc port $ETH_RPC_PORT."
    syncing="$(timeout $RPC_TIMEOUT seth rpc eth_syncing 2> /dev/null)" \
  	  && peers="$(timeout $RPC_TIMEOUT seth rpc net_peerCount 2> /dev/null)" \
      && timestamp="$(($(date +%s)-$(timeout $RPC_TIMEOUT seth block latest timestamp 2>/dev/null || echo 0) ))" \
         	  && sanity="($(timeout $RPC_TIMEOUT setzer peek "$SETZER_FEED" 2> /dev/null || true))"
    [[ $syncing == "false" ]] && [[ $peers -gt 0 ]] && [[ $timestamp -lt 60 ]] && [[ $sanity ]] \
  	  && running_client="$((running_client+1))" &&
    log "Node running on RPC port $ETH_RPC_PORT."
  done
  
  log "Node count: $running_client."
  messageuser
else
  running_client=0
  log "Node count: $running_client."
	messageuser
fi
