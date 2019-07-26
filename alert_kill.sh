#!/bin/bash - 
#===============================================================================
#
#          FILE: alert_kill.sh
# 
#         USAGE: ./alert_kill.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 12/16/2017 13:38
#      REVISION:  ---
#===============================================================================

set -o nounset              # Treat unset variables as an error
scripts_to_kill="alert_geth.sh alert_parity.sh alert_client.sh alert_txcount.sh alert_balance.sh"
for script in $scripts_to_kill; do 
	kill $(ps auxw|grep $script|sed -e 's/^root[[:space:]]*\([0-9]\+\).*/\1/')
done
log "$scripts_to_kill killed."
