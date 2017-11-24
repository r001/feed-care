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
4. `cp setzer-bot.service /etc/systemd/system/ && systemctl daemon-reload && systemctl start setzer-bot` # create setzer-bot service (this one automatically restarts setzer if it stops)
5. `cp geth.service /etc/systemd/system/ && systemctl daemon-reload && systemctl start geth`  #create service for geth (this one automatically restarts geth if process gets terminated) 
6. Use `crontab_example` to edit crontab file `crontab -e`
7. You are all set. 

## Setup settings - alert_settings.sh
**PLEASE EDIT THIS FILE BEFORE USING SCRIPTS**
This file is the system wide setup where you can add alert email address, account number, and threshold values.

## Alert if balance too low - alert_balance.sh

Alerts email address if balance of feeds account is below THRESHOLD Ether defined in alert_settings.sh.

Script should be run every hour. 

## Alert if geth stops working - alert_ethereum.sh

Alerts user if geth client stops updating blocks (ie. geth is not operational). 
Script should be run every hour. (Note: should not be called more often, because it takes geth sometimes 40 minutes to even start syncing blocks.)

## Alert if file system is close to full - alert_filesystem.sh

Alerts EMAIL if free disk space is under DISK_SPACE_THRESHOLD in alert_settings.sh.
This script should be run once every hour.

## Alert if feed was not updated for more than 6 hours - alert_txcount.sh

This script alerts EMAIL if feed update count did not increase. (Meaning the feed has not been updated since last run of this script.)
This script should be run in every 6 houras
