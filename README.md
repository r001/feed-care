# feed-care 
# Repository to keep alive feeds
Directory contains necessary scripts that if run from crontab, can make sure that a system running price feed using setzer, and geth --light or parity --light will become more reliable.

## Prerequisities 
- **mail** command must be operational to send email to arbitrary address. 
- **setzer** must be installed
- **seth** must be installed
- **geth** must be installed (if you install parity, the scripts wont restart it)
- **hostname** command must be installed (package **hostname** under ubuntu)

## Installation
Lets assume the git clone base directory is DIR.

0. Edit alert\_settings.sh and update EMAIL, and ACC variables.  
1. Install all the packages under Prerequisities.  
2. `mkdir /root/.scripts` # create dir for scripts  
3. `cp $DIR/\*.sh /root/.scripts` # copy all script files from DIR to /root/.scripts  
4. `cp setzer-bot.service /etc/systemd/system/ && systemctl daemon-reload && systemctl enable setzer-bot && systemctl start setzer-bot` # create setzer-bot service (this one automatically restarts setzer if it stops), and starts at boot time automatically  
### If you use **geth** as Ethereum client as well
5. Install service (only systems with systemd) 
  1. Edit geth.service replace ethereum account after `--unlock` with your ethereum feed account number.  
  2. `cp UTC--xxxx /root/.ethereum/keystore/` #Add your ethereum feed account to geth client.   
6. Add and edit the file called `/root/.scripts/p.txt` and enter your ethereum feed account password.  
7. `cp geth.service /etc/systemd/system/ && systemctl daemon-reload && systemctl enable geth && systemctl start geth`  #create service for geth (this one automatically restarts geth if process gets terminated), and starts at boot time automatically  
8. Use `crontab_example` to edit crontab file `crontab -e`  
### If you use **parity** as Ethereum client as well
9. Install service   
  1. Edit parity.service replace ethereum account after `--unlock` with your ethereum feed account number.  
  2. `cp UTC--xxxx /root/.local/share/io.parity.ethereum/keys/ethereum/` #Add your ethereum feed account to geth client.   
10. Add and edit the file called `/root/.scripts/p.txt` and enter your ethereum feed account password.  
11. `cp parity.service /etc/systemd/system/ && systemctl daemon-reload && systemctl enable parity && systemctl start parity`  #create service for parity (this one automatically restarts parity if process gets terminated), and starts at boot time automatically  
12. Use `crontab_example` to edit crontab file `crontab -e`  
13. You are all set. :)   

Note: You can install both **geth** and **parity** clients at the same time.
 
## Setup settings - alert_settings.sh
**PLEASE EDIT THIS FILE BEFORE USING SCRIPTS**
```bash
#email for alerts
export EMAIL="YOUR EMAIL ADDRESS"

#ethereum account for paying feed
export ACC="YOUR FEED ACCOUNT ADDRESS"

#balance threshold in Ether under which alert is sent
export THRESHOLD=0.01

#disk space in percentage to send alert
export DISK_SPACE_THRESHOLD=90

#parity rpc port number (should be different from GETH_RPC_PORT)
export PARITY_RPC_PORT=8545

#parity node port number, where parity expects outher nodes
#should be different from GETH_NODE_PORT
export PARITY_NODE_PORT=30303

#geth rpc port
export GETH_RPC_PORT=8555

#geth node port number, where geth expects outher nodes
#should be different from PARITY_NODE_PORT
export GETH_NODE_PORT=30305

#time we allow nodes to respond before rendering them unuseable
export ALERT_NODE_TIMEOUT=5s
```
## Alert if balance too low - alert_balance.sh

Alerts email address if balance of feeds account is below THRESHOLD Ether defined in alert_settings.sh.

Script should be run every hour. 

## Alert if geth stops working - alert_geth.sh

Alerts user if geth client stops updating blocks (ie. geth is not operational). 
Script should be run every hour. (Note: should not be called more often, because it takes geth sometimes 40 minutes to even start syncing blocks.)

## Alert if geth stops working - alert_parity.sh

Alerts user if parity client stops updating blocks (ie. geth is not operational).  
Script should be run every hour. 

## Alert if file system is close to full - alert_filesystem.sh

Alerts EMAIL if free disk space is under DISK_SPACE_THRESHOLD in alert_settings.sh.  
This script should be run once every hour.

## Alert if feed was not updated for more than 6 hours - alert_txcount.sh

This script alerts EMAIL if feed update count did not increase. (Meaning the feed has not been updated since last run of this script.)
This script should be run in every 6 hours.
