<h1 align="right">Silent Cat Backup</h1>

<p align="center">
 <a href="./README.md">
 English
 </a>
 /
 <a href="./README-fa.md">
 فارسی
 </a>
</p>

###

<p align="right">اسکریپت SilentCat Marzban Backup به‌صورت خودکار طبق زمان بندی شما از فایل‌های مهم مرزبان بک‌آپ می‌گیرد و آن را از طریق تلگرام برای شما ارسال می‌کند.</p>

###

<br clear="both">

<p align="left">‏<br>‏</p>

###

<h1 align="right">آموزش پیکربندی</h1>

###
<h3 align="right">مرحله اول</h3>
<h3 align="right">با دستور زیر فایل marzban-backup.sh را بسازید</h3>
  
```bash
nano /usr/local/bin/marzban-backup.sh
``` 
###
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
###

<p align="right">سپس از ما توکن ربات می خواهد، شما باید یک ربات از https://t.me/BotFather بسازید و توکن را بدهید</p>

###
<h3 align="right">مرحله سوم</h3>
<h3 align="right">ساخت ربات تلگرام، دریافت توکن API و دریافت آیدی عددی</h3>
<p align="right">در https://t.me/BotFather یک ربات بسازید و توکن API آن را در قسمت BOT_TOKEN بین "" قرار دهید، سپس برای دریافت آیدی عددی خود یک پیام از خود به ربات https://t.me/userinfobot فروارد کنید، سپس آیدی عددی خود را در قسمت CHAT_ID بین "" کد قرار دهید، سپس ctrls+s برای ذخیره سازی و ctrl+x برای خروج را بزنید</p>
###

<p align="right">سپس از ما یک چت آیدی می‌خواهد و برای دریافت چت آیدی یا کانالی که برای پشتیبان‌گیری اختصاص داده‌اید، باید یک پیام از خود یا کانال به این ربات https://t.me/userinfobot فوروارد کنید که این ربات چت آیدی را بهتون بده</p>

###
<h3 align="right">مرحله سوم</h3>
<h3 align="right">با دستور زیر فایل marzban-backup.sh را بسازید</h3>
  
```bash
nano /usr/local/bin/marzban-backup.sh
``` 
