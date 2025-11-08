#!/bin/bash
set -euo pipefail

INSTALLER_PATH="/usr/local/bin/silentcat-backup.sh"
CRON_FILE="/etc/cron.d/silentcat-backup"
DESTDIR="/var/backups"
SRC1="/opt/marzban"
SRC2="/var/lib/marzban"
FNAME="marzban-backup-[by-silentcat].zip"
FILEPATH="${DESTDIR}/${FNAME}"

echo
read -p "Telegram Bot Token: " BOT_TOKEN
read -p "Telegram Chat ID: " CHAT_ID

while true; do
  read -p "Backup interval in hours (1-24): " INTERVAL
  if [[ "$INTERVAL" =~ ^[1-9]$|^1[0-9]$|^2[0-4]$ ]]; then break; fi
  echo "Enter a number between 1 and 24."
done

while true; do
  read -p "Remove previous cron jobs for silentcat-backup? (y/n): " DELPREV
  case "$DELPREV" in
    y|Y) REMOVE_PREV=yes; break ;;
    n|N) REMOVE_PREV=no; break ;;
    *) echo "y or n please." ;;
  esac
done

# deps
if ! command -v zip >/dev/null 2>&1; then
  if command -v apt >/dev/null 2>&1; then
    apt update -y && apt install -y zip curl
  else
    echo "zip not found and apt unavailable — install zip and curl manually." >&2
    exit 1
  fi
fi

mkdir -p "$DESTDIR"

# remove previous cron jobs if asked
if [[ "$REMOVE_PREV" == "yes" ]]; then
  if [ -f "$CRON_FILE" ]; then
    rm -f "$CRON_FILE"
  fi
  # remove lines from root crontab that reference silentcat-backup.sh
  if crontab -l 2>/dev/null | grep -q silentcat-backup.sh; then
    (crontab -l 2>/dev/null | grep -v silentcat-backup.sh) | crontab -
  fi
fi

# write backup runner
cat > "$INSTALLER_PATH" <<'EOF'
#!/bin/bash
set -euo pipefail
SRC1="/opt/marzban"
SRC2="/var/lib/marzban"
DESTDIR="/var/backups"
FNAME="marzban-backup-[by-silentcat].zip"
FILEPATH="${DESTDIR}/${FNAME}"
mkdir -p "${DESTDIR}"
rm -f "${FILEPATH}"
zip -r -q "${FILEPATH}" "${SRC1}" "${SRC2}" >/dev/null 2>&1
# send to telegram (BOT_TOKEN and CHAT_ID are substituted by installer)
curl -s -F chat_id="__CHAT_ID__" -F document=@"${FILEPATH}" -F caption="Created by @silentcatsupport" "https://api.telegram.org/bot__BOT_TOKEN__/sendDocument" >/dev/null 2>&1 || exit 0
EOF

# substitute token and chat id
sed -i "s|__BOT_TOKEN__|${BOT_TOKEN}|g" "$INSTALLER_PATH"
sed -i "s|__CHAT_ID__|${CHAT_ID}|g" "$INSTALLER_PATH"

chmod 750 "$INSTALLER_PATH"
chown root:root "$INSTALLER_PATH"

# create cron.d file to run every INTERVAL hours (at minute 0)
echo "0 0-23/${INTERVAL} * * * root ${INSTALLER_PATH}" > "$CRON_FILE"
chmod 644 "$CRON_FILE"

# reload cron (best-effort)
if command -v systemctl >/dev/null 2>&1; then
  systemctl restart cron 2>/dev/null || true
fi

echo
echo "Installed: ${INSTALLER_PATH}"
echo "Cron: ${CRON_FILE} -> runs every ${INTERVAL} hour(s) at minute 0"
echo "Backup file: ${FILEPATH}"
echo
echo "Running a test backup now..."
/bin/bash -x "$INSTALLER_PATH" >/tmp/silentcat-backup-install.log 2>&1 || true
echo "Test run finished. Check /tmp/silentcat-backup-install.log for details."
echo "Done."
