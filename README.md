<h1 align="left">Silent Cat Backup</h1>
<p align="center">
 <a href="./README.md">
 English
 </a>
 /
 <a href="./README-fa.md">
 فارسی
 </a>
</p>
<br clear="both">

<p align="left">The Silent Cat Backup script automatically takes backups of important Marzban files, such as the database, according to your schedule and sends them to you via Telegram</p>
<p align="left">‏<br>‏</p>

<h1 align="left">Configuration Guide</h1>
<h3 align="left">Step One</h3>
<h3 align="left">Create the marzban-backup.sh file by running the following command</h3>
  
```bash
nano /usr/local/bin/marzban-backup.sh
``` 
<br clear="both">

<h3 align="left">Step Two</h3>
<h3 align="left">Place the following content into the opened file</h3>
  
```bash
#!/bin/bash

SRC1="/opt/marzban"
SRC2="/var/lib/marzban"
DEST="/var/backups"
mkdir -p "$DEST"

FILENAME="marzban-backup.zip"
FILEPATH="${DEST}/${FILENAME}"

if ! command -v zip &> /dev/null; then
    apt update -y && apt install zip -y
fi

rm -f "$FILEPATH"
zip -r "$FILEPATH" "$SRC1" "$SRC2" >/dev/null 2>&1

BOT_TOKEN=""
CHAT_ID=""
CAPTION="Created by @silentcatvpn"

curl -s -F chat_id="$CHAT_ID" -F document=@"$FILEPATH" -F caption="$CAPTION" "https://api.telegram.org/bot${BOT_TOKEN}/sendDocument" >/dev/null 2>&1

find "$DEST" -type f -name "marzban-backup.zip" -mtime +7 -delete
``` 
<br clear="both">

<h3 align="left">Step Three</h3>
<h3 align="left">Creating a Telegram Bot and Obtaining the API Token</h3>
<p align="left">Go to https://t.me/botfather</p>
<p align="left">Create a new bot</p>
<p align="left">Place the received API token in the marzban-backup.sh file in the BOT_TOKEN field between the quotes ("")</p>
<br clear="both">

<h3 align="left">Step Four</h3>
<h3 align="left">Obtaining the Chat ID</h3>
<p align="left">Forward a message from yourself to the https://t.me/userinfobot and enter the received Chat ID in the CHAT_ID field between the quotes ("")</p>
<p align="left">Press Ctrl+S to save the file and Ctrl+X to exit the editor</p>
<br clear="both">

<h3 align="left">Step Five</h3>
<h3 align="left">By running the following command, execution permission is granted to the marzban-backup.sh file</h3>
  
```bash
chmod +x /usr/local/bin/marzban-backup.sh
``` 
<br clear="both">

<h3 align="left">Final Step</h3>
<h3 align="left">To set up a cron job and run the script automatically, execute the following command</h3>
  
```bash
crontab -e
``` 
<br clear="both">

<h3 align="left">At the end of the cron file, add the following line</h3>
  
```bash
0 */12 * * * /usr/local/bin/marzban-backup.sh >/dev/null 2>&1
``` 
<p align="left">By default, this command runs every 12 hours, If desired, you can adjust the interval for the backups</p>
<p align="left">After adding the line, press Ctrl+S to save the file and Ctrl+X to exit the editor</p>
<br clear="both">

<h3 align="left">To run the script manually and verify its operation, you can execute the following command</h3>
  
```bash
bash -x /usr/local/bin/marzban-backup.sh
``` 
<h1 align="left">Support</h1>
<p align="left">For guidance or troubleshooting, contact support via Telegram</p>
<p align="left">https://t.me/silentcatsupport</p>
