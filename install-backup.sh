#!/bin/bash

# SilentCat Backup Installer
# Author: @silentcatsupport

set -e

# پاکسازی احتمالی کاراکترهای ویندوزی فقط در صورت وجود
sed -i 's/\r$//' "$0"

clear
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "      🐾 SilentCat Backup Setup 🐾"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Remove old cron jobs (optional)
read -p "آیا می‌خواهید کرون‌جاب‌های قبلی حذف شوند؟ (y/n): " REMOVE_CRON
if [[ "$REMOVE_CRON" == "y" || "$REMOVE_CRON" == "Y" ]]; then
    crontab -l | grep -v "silentcat-backup.sh" | crontab -
    echo "✅ کرون‌جاب‌های قبلی حذف شدند."
    sleep 1
fi

# Get user input
read -p "توکن بات تلگرام را وارد کنید: " BOT_TOKEN
read -p "چت آیدی تلگرام را وارد کنید: " CHAT_ID
read -p "ساعت اجرای بکاپ را (0 تا 23) وارد کنید: " BACKUP_HOUR

# Create backup script
BACKUP_SCRIPT="/usr/local/bin/silentcat-backup.sh"

cat <<'EOF' > "$BACKUP_SCRIPT"
#!/bin/bash
SRC1="/opt/marzban"
SRC2="/var/lib/marzban"
DEST="/var/backups"
mkdir -p "$DEST"

FILENAME="marzban-backup.zip [by silentcat]"
FILEPATH="${DEST}/${FILENAME}"

cd /
zip -r "$FILEPATH" "$SRC1" "$SRC2" >/dev/null 2>&1

curl -s -F chat_id="$CHAT_ID" -F document=@"$FILEPATH" -F caption="Created by @silentcatsupport" "https://api.telegram.org/bot$BOT_TOKEN/sendDocument" >/dev/null 2>&1

find "$DEST" -type f -name "marzban-backup.zip*" -mtime +7 -delete >/dev/null 2>&1
EOF

chmod +x "$BACKUP_SCRIPT"

# Add cron jobs
(crontab -l 2>/dev/null; echo "0 $BACKUP_HOUR * * * bash $BACKUP_SCRIPT") | crontab -

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ نصب با موفقیت انجام شد!"
echo "📦 مسیر فایل بکاپ: /var/backups/marzban-backup.zip [by silentcat]"
echo "⏰ زمان بکاپ روزانه: ساعت $BACKUP_HOUR:00"
echo "📤 ارسال به تلگرام با آیدی: $CHAT_ID"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
