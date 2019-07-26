run_by_cron=$1

function log {
  [[ "$run_by_cron" == "-c" ]] && /usr/bin/logger -t "$0[$$]" "$*"
  [[ "$run_by_cron" != "-c" ]] && echo "$*"
}

function verbose {
  [[ $SETZER_VERBOSE ]] && log "[V] $*"
}

function checketh {
	# Global configuration
	if [[ -e /etc/setzer.conf ]]; then
		# shellcheck source=/dev/null
		. "/etc/setzer.conf"
	fi

  # Check if connected to node
  export RPC_TIMEOUT=${RPC_TIMEOUT:-30s}
  unset ETH_RPC_URL
  for port in ${RPC_PORTS:-8545}; do
    export ETH_RPC_PORT=$port
    log "Trying on rpc port $ETH_RPC_PORT."
    [[ "$(/usr/local/bin/setzer connected)" == "true" ]] && running_client="$((running_client+1))" && log "Node running on RPC port $ETH_RPC_PORT." && ok=true
  done
	for url in $RPC_URLS; do
		export ETH_RPC_URL=$url
		log "Trying on rpc url $ETH_RPC_URL"
		[[ "$(/usr/local/bin/setzer connected)" == "true" ]] && running_client="$((running_client+1))" && log "Node running on RPC url $ETH_RPC_URL."
	done
	[[ "$ok" == "true" ]] && unset ETH_RPC_URL
}

function getnode {

	# check we're connected to ethereum
	while [[ "$(/usr/local/bin/setzer connected)" != "true" ]]; do
		unset ETH_RPC_URL
		for port in ${RPC_PORTS:-8545}; do
			export ETH_RPC_PORT=$port
			log "Trying on rpc port $ETH_RPC_PORT."
			[[ "$(/usr/local/bin/setzer connected)" == "true" ]] && ok=true && break
		done
		if [[ "$ok" != "true" ]]; then
			for url in $RPC_URLS; do
				export ETH_RPC_URL=$url
				log "Trying on rpc url $ETH_RPC_URL"
				[[ "$(/usr/local/bin/setzer connected)" == "true" ]] && break && url_ok=true
			done
			[[ "$ok" == "true" ]] && unset ETH_RPC_URL 
			[[ "$url_ok" == "true" ]] && ok=true
		fi
		[[ "$ok" != "true" ]] && log "Not connected to Ethereum, retry in 10 seconds..." && sleep 10
	done
	[[ -z "$ETH_RPC_URL" ]] && log "Node running on rpc port ${ETH_RPC_PORT:-8545}."
	[[ -n "$ETH_RPC_URL" ]] && log "Node running on rpc url $ETH_RPC_URL."
}
