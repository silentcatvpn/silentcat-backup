<h1 align="right">Silent Cat Backup</h1>
<br clear="both">

<p align="right">اسکریپت SilentCat Marzban Backup به‌صورت خودکار طبق زمان بندی شما از فایل‌های مهم مرزبان بک‌آپ می‌گیرد و آن را از طریق تلگرام برای شما ارسال می‌کند.</p>
<br clear="both">

<p align="left">‏<br>‏</p>

<h1 align="right">آموزش پیکربندی</h1>
<h3 align="right">مرحله اول</h3>
<h3 align="right">با دستور زیر فایل marzban-backup.sh را بسازید</h3>
  
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
<p align="right">در https://t.me/BotFather یک ربات بسازید و توکن API آن را در قسمت BOT_TOKEN بین "" قرار دهید</p>
<br clear="both">

<h3 align="right">مرحله چهارم</h3>
<h3 align="right">دریافت Chat ID</h3>
<p align="right">رای دریافت Chat ID خود یک پیام از خود به ربات https://t.me/userinfobot فروارد کنید، سپس Chat ID خود را در قسمت CHAT_ID بین ""  قرار دهید</p>
<p align="right">سپس ctrl+s برای ذخیره سازی و ctrl+x برای خروج را بزنید</p>
<br clear="both">

<h3 align="right">مرحله پنجم</h3>
<h3 align="right">با دستور زیر مجوز اجرا فایل marzban-backup.sh رو صادر کن</h3>
  
```bash
chmod +x /usr/local/bin/marzban-backup.sh
``` 
<br clear="both">

<h3 align="right">مرحله ششم</h3>
<h3 align="right">برای تنظیم کرون جاب ابتدا دستور زیر رو بزن</h3>
  
```bash
crontab -e
``` 
<br clear="both">

<h3 align="right">حالا اینو به خط آخرش اضافه کن</h3>
  
```bash
0 */12 * * * /usr/local/bin/marzban-backup.sh >/dev/null 2>&1
``` 
<p align="right">به صورت پیش فرض روی ۱۲ ساعت تنظیم شده ولی در صورت تمایل میتونید تعیین کنید هر چند ساعت بک‌آپ براتون ارسال بشه</p>
<p align="right">سپس ctrl+s برای ذخیره سازی و ctrl+x برای خروج را بزنید</p>
###
<h3 align="right">بک‌آپ شما هر ۱۲ ساعت و در ساعات ۰۳:۳۰ و ۱۵:۳۰ برای شما ارسال میشه</h3>
<h3 align="right">برای دریافت بک‌آپ لحظه ای، دستور زیر را وارد کنید</h3>
  
```bash
bash -x /usr/local/bin/marzban-backup.sh
``` 
