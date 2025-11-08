<h1 align="left">Silent Cat Backup</h1>
<br clear="both">

<p align="right">اسکریپت SilentCat Marzban Backup به‌صورت خودکار طبق زمان بندی شما از فایل‌های مهم مرزبان بک‌آپ می‌گیرد و آن را از طریق تلگرام برای شما ارسال می‌کند.</p>
<br clear="both">
<p align="left">‏<br>‏</p>

<h1 align="right">آموزش پیکربندی</h1>
<h3 align="right">مرحله اول</h3>
<h3 align="right">با اجرای دستور زیر، فایل marzban-backup.sh را ایجاد کنید</h3>
  
```bash
nano /usr/local/bin/marzban-backup.sh
``` 
<br clear="both">

<h3 align="right">مرحله دوم</h3>
<h3 align="right">محتوای زیر را در فایل  باز شده قرار دهید</h3>
  
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

<h3 align="right">مرحله سوم</h3>
<h3 align="right">ساخت ربات تلگرام و دریافت API Token</h3>
<p align="right"> به آدرس https://t.me/botfather مراجعه کنید</p>
<p align="right">یک ربات جدید بسازید</p>
<p align="right">توکن API دریافتی را در فایل marzban-backup.sh در قسمت BOT_TOKEN بین ("") قرار دهید</p>
<br clear="both">

<h3 align="right">مرحله چهارم</h3>
<h3 align="right">دریافت Chat ID</h3>
<p align="right">یک پیام از خود به ربات https://t.me/userinfobot فوروارد کنید و Chat ID دریافتی را در قسمت CHAT_ID بین ("") وارد کنید</p>
<p align="right">با فشردن Ctrl+S فایل را ذخیره و با فشردن Ctrl+X از ویرایشگر خارج شوید</p>
<br clear="both">

<h3 align="right">مرحله پنجم</h3>
<h3 align="right">با اجرای دستور زیر، اجازه اجرای فایل marzban-backup.sh صادر می‌شود</h3>
  
```bash
chmod +x /usr/local/bin/marzban-backup.sh
``` 
<br clear="both">

<h3 align="right">مرحله آخر</h3>
<h3 align="right">برای تنظیم کرون جاب ابتدا دستور زیر رو بزن</h3>
  
```bash
crontab -e
``` 
<br clear="both">

<h3 align="right">در انتهای فایل، دستور زیر را اضافه کنید</h3>
  
```bash
0 */12 * * * /usr/local/bin/marzban-backup.sh >/dev/null 2>&1
``` 
<p align="right">به‌صورت پیش‌فرض، این دستور هر ۱۲ ساعت یک‌بار اجرا می‌شود. در صورت تمایل، می‌توانید بازه زمانی دلخواه برای اجرای بک‌آپ را مشخص کنید</p>
<p align="right">پس از افزودن دستور، با فشردن Ctrl+S فایل را ذخیره و با فشردن Ctrl+X از ویرایشگر خارج شوید</p>
<br clear="both">

<h3 align="right">پس از افزودن دستور، با فشردن Ctrl+S فایل را ذخیره و با فشردن Ctrl+X از ویرایشگر خارج شوید</h3>
  
```bash
bash -x /usr/local/bin/marzban-backup.sh
``` 
