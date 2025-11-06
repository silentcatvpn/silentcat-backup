#!/bin/bash

echo "Enter your Telegram Bot Token:"
read BOT_TOKEN
echo "Enter your Telegram Chat ID:"
read CHAT_ID
echo "Enter backup interval in hours (e.g. 12):"
read INTERVAL

cat <<EOF >/usr/local/bin/silentcat-backup.sh
#!/bin/bash
SRC1="/opt/marzban"
SRC2="/var/lib/marzban"
DEST="/var/backups"
mkdir -p "\$DEST"

FILENAME="marzban_backup_[by_silentcat].zip"
FILEPATH="\${DEST}/\${FILENAME}"

zip -r "\$FILEPATH" "\$SRC1" "\$SRC2" >/dev/null 2>&1

curl -s -F chat_id="$CHAT_ID" \
     -F document=@"\$FILEPATH" \
     -F caption="Created by @silentcatsupport" \
     "https://api.telegram.org/bot${BOT_TOKEN}/sendDocument" >/dev/null 2>&1

find "\$DEST" -type f -name "marzban_backup_[by_silentcat].zip" -mtime +7 -delete
EOF

chmod +x /usr/local/bin/silentcat-backup.sh

echo "Setting up cron job every $INTERVAL hours..."
CRON_FILE="/etc/cron.d/silentcat-backup"
echo "0 */$INTERVAL * * * root /usr/local/bin/silentcat-backup.sh" > "\$CRON_FILE"
chmod 644 "\$CRON_FILE"
systemctl restart cron >/dev/null 2>&1

echo "Backup system installed successfully!"
echo "Backups will be sent every $INTERVAL hours to your Telegram."
