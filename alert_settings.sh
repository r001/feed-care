#email for alerts
export EMAIL=rob@nyar.eu
#ethereum account for paying feed
export ACC=0x8afbd9c3d794ed8df903b3468f4c4ea85be953fb
#balance threshold in Ether under which alert is sent
export THRESHOLD=0.01
#disk space in percentage to send alert
export DISK_SPACE_THRESHOLD=90
#parity rpc port number (should be different from $GETH_RPC_PORT)
export PARITY_RPC_PORT=8555
#parity node port number, where parity expects outher nodes
export PARITY_NODE_PORT=30305
#geth rpc port
export GETH_RPC_PORT=8565
#geth node port number, where geth expects outher nodes
export GETH_NODE_PORT=30303
#time we allow nodes to respond
export ALERT_NODE_TIMEOUT=10s
