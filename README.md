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
<h3 align="left">Create the `marzban-backup.sh` file by running the following command</h3>
  
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
<h3 align="right">با اجرای دستور زیر، مجوز اجرای فایل marzban-backup.sh صادر می‌شود</h3>
  
```bash
chmod +x /usr/local/bin/marzban-backup.sh
``` 
<br clear="both">

<h3 align="right">مرحله آخر</h3>
<h3 align="right">برای تنظیم کرون جاب و اجرای خودکار اسکریپت، دستور زیر را اجرا کنید</h3>
  
```bash
crontab -e
``` 
<br clear="both">

<h3 align="right">در انتهای فایل کرون، دستور زیر را اضافه کنید</h3>
  
```bash
0 */12 * * * /usr/local/bin/marzban-backup.sh >/dev/null 2>&1
``` 
<p align="right">به‌صورت پیش‌فرض، این دستور هر ۱۲ ساعت یک‌بار اجرا می‌شود. در صورت تمایل، می‌توانید بازه زمانی دلخواه برای اجرای بک‌آپ را مشخص کنید</p>
<p align="right">پس از افزودن دستور، با فشردن Ctrl+S فایل را ذخیره و با فشردن Ctrl+X از ویرایشگر خارج شوید</p>
<br clear="both">

<h3 align="right">برای اجرای دستی و بررسی عملکرد اسکریپت، می‌توانید دستور زیر را اجرا کنید</h3>
  
```bash
bash -x /usr/local/bin/marzban-backup.sh
``` 
<h1 align="right">پشتیبانی</h1>
<p align="right">برای دریافت راهنمایی یا حل مشکلات، با پشتیبانی از طریق تلگرام در ارتباط باشید</p>
<p align="right">https://t.me/silentcatsupport</p>
