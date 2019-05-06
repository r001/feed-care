function log {
  echo "[$(date "+%D %T")] $*"
}

function verbose {
  [[ $SETZER_VERBOSE ]] && log "[V] $*"
}

function checketh {
  #get the minimal config
  eval "$( [[ -e /etc/setzer.conf ]] && cat /etc/setzer.conf \
	  | grep 'export[[:space:]]\+\(RPC_TIMEOUT\|RPC_PORTS\|SETZER_FEED\|SETZER_VERBOSE\|SETZER_CONF\)' \
	  | sed -e "s/\n/;/g") "
  eval "$( [[ -e $SETZER_CONF ]] && cat $SETZER_CONF \
	  | grep 'export[[:space:]]\+\(RPC_TIMEOUT\|RPC_PORTS\|SETZER_FEED\|SETZER_VERBOSE\|SETZER_CONF\)' \
	  | sed -e "s/\n/;/g") "

  # Check if connected to node
  export RPC_TIMEOUT=${RPC_TIMEOUT:-15s}
  for PORT in ${RPC_PORTS:-8545}; do
    export ETH_RPC_PORT=$PORT
    verbose "Trying on rpc port $ETH_RPC_PORT."
    syncing="$(timeout $RPC_TIMEOUT seth rpc eth_syncing 2> /dev/null)" \
  	  && peers="$(timeout $RPC_TIMEOUT seth rpc net_peerCount 2> /dev/null)" \
      && timestamp="$(( $(date +%s) - $(timeout $RPC_TIMEOUT seth block latest timestamp 2>/dev/null || echo 0) ))" \
  	  && sanity="$(timeout $RPC_TIMEOUT setzer peek "$SETZER_FEED" 2> /dev/null || true)"
    [[ $syncing == "false" ]] && [[ $peers -gt 0 ]] && [[ $timestamp -lt 60 ]] && [[ $sanity ]] \
  	  && running_client=1  && break 
  done
}

function getnode {
  checketh
  if [ "${running_client:-0}" -ne 1 ]; then
   log "Not connected to Ethereum, retry in 5 seconds..."
   verbose "Syncing:    $syncing (should be false)"
   verbose "Peers:      $peers (should be > 0)"
   verbose "Last block: $timestamp (should be < 60)"
   verbose "Sanity:     $sanity (should be not empty)"
   sleep 5
   exec "$0" "$@"
  fi
  log "Node running on RPC port $ETH_RPC_PORT."
}
