#!/usr/bin/env python3
import imaplib
import email
import subprocess
import time
from email.header import decode_header
import ssl
import threading
import os

# Config untuk multiple akun
ACCOUNTS = [
    {
        "email": "akun1@gmail.com",
        "password": "password_app_1",
        "name": "Akun Kerja"  # Nama untuk identifikasi di notif
    },
    {
        "email": "akun2@gmail.com",
        "password": "password_app_2",
        "name": "Akun Pribadi"
    },
    # Tambah akun lagi di sini kalau perlu
]

IMAP_SERVER = "imap.gmail.com"
CHECK_INTERVAL = 5
NOTIFICATION_ICON = "/home/ego/media/picture/asset/notify/gmailnotif.jpg"
AUDIO_PATH = "/home/ego/media/picture/asset/notify/notifemail.mp3"

# Track seen emails per account (pakai dict)
seen_emails = {}

def notify(title, body):
    subprocess.run([
        'notify-send', 
        '-i', NOTIFICATION_ICON,
        '-u', 'normal',
        '-t', '10000',
        title, 
        body
    ])
    subprocess.Popen(['paplay', AUDIO_PATH], 
                     stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

def decode_str(s):
    if s is None:
        return ""
    decoded = decode_header(s)
    result = []
    for part, encoding in decoded:
        if isinstance(part, bytes):
            result.append(part.decode(encoding or 'utf-8', errors='ignore'))
        else:
            result.append(part)
    return ''.join(result)

def check_new_emails(mail, account_email):
    global seen_emails
    
    try:
        status, messages = mail.search(None, 'UNSEEN')
        if status != 'OK' or not messages[0]:
            return
        
        email_ids = messages[0].split()
        
        current_unseen = set()
        for num in email_ids:
            if isinstance(num, bytes):
                current_unseen.add(num.decode('utf-8'))
            else:
                current_unseen.add(str(num))
        
        new_emails = current_unseen - seen_emails[account_email]
        
        if not new_emails:
            return
        
        print(f"[{account_email}] Found {len(new_emails)} new email(s)")
        
        for num_str in new_emails:
            try:
                fetch_id = num_str.encode('utf-8')
                status, msg_data = mail.fetch(fetch_id, '(RFC822)')
                
                if status != 'OK' or not msg_data:
                    print(f"[{account_email}] Failed to fetch email {num_str}")
                    continue
                
                email_body = None
                for item in msg_data:
                    if isinstance(item, tuple) and len(item) >= 2:
                        if isinstance(item[1], bytes):
                            email_body = item[1]
                            break
                
                if email_body is None:
                    print(f"[{account_email}] Could not find email body")
                    continue
                
                msg = email.message_from_bytes(email_body)
                subject = decode_str(msg.get('Subject', 'No Subject'))
                from_addr = decode_str(msg.get('From', 'Unknown'))
                
                if '<' in from_addr:
                    from_addr = from_addr.split('<')[0].strip().strip('"')
                
                print(f"[{account_email}] New email from: {from_addr}")
                print(f"[{account_email}] Subject: {subject}")
                
                # Tambah info akun di notifikasi
                account_name = next((acc['name'] for acc in ACCOUNTS if acc['email'] == account_email), account_email)
                notify_title = f"Email baru - {account_name}"
                notify_body = f"{from_addr}\n{subject}"
                
                notify(notify_title, notify_body)
                
                seen_emails[account_email].add(num_str)
                
            except Exception as e:
                print(f"[{account_email}] Error processing email {num_str}: {e}")
                continue
                
    except Exception as e:
        print(f"[{account_email}] Error checking emails: {e}")

def monitor_account(account):
    """Thread function untuk monitor satu akun"""
    email_addr = account['email']
    password = account['password']
    account_name = account['name']
    
    # Init seen_emails untuk akun ini
    if email_addr not in seen_emails:
        seen_emails[email_addr] = set()
    
    while True:
        mail = None
        try:
            print(f"[{account_name}] Connecting to Gmail...")
            context = ssl.create_default_context()
            mail = imaplib.IMAP4_SSL(IMAP_SERVER, 993, ssl_context=context)
            mail.login(email_addr, password)
            mail.select('INBOX')
            
            # Inisialisasi: tandai email UNSEEN yang sudah ada
            if not seen_emails[email_addr]:
                status, messages = mail.search(None, 'UNSEEN')
                if status == 'OK' and messages[0]:
                    for msg_id in messages[0].split():
                        if isinstance(msg_id, bytes):
                            seen_emails[email_addr].add(msg_id.decode('utf-8'))
                        else:
                            seen_emails[email_addr].add(str(msg_id))
                    print(f"[{account_name}] Initialized with {len(seen_emails[email_addr])} existing unread emails")
            
            print(f"[{account_name}] Connected. Monitoring...")
            
            last_check = time.time()
            
            while True:
                try:
                    mail.noop()
                    
                    if time.time() - last_check > CHECK_INTERVAL:
                        check_new_emails(mail, email_addr)
                        last_check = time.time()
                    
                    time.sleep(CHECK_INTERVAL)
                    
                except imaplib.IMAP4.abort:
                    print(f"[{account_name}] Connection lost, reconnecting...")
                    break
                except Exception as e:
                    print(f"[{account_name}] Error in loop: {e}")
                    break
                
        except KeyboardInterrupt:
            break
        except Exception as e:
            print(f"[{account_name}] Connection error: {e}")
            print(f"[{account_name}] Reconnecting in 10 seconds...")
            time.sleep(10)
        finally:
            if mail:
                try:
                    mail.logout()
                except:
                    pass

def main():
    print("Gmail Multi-Account Real-time Monitor")
    print(f"Monitoring {len(ACCOUNTS)} account(s)")
    print("Ctrl+C to stop\n")
    
    # Buat thread untuk setiap akun
    threads = []
    for account in ACCOUNTS:
        thread = threading.Thread(target=monitor_account, args=(account,), daemon=True)
        thread.start()
        threads.append(thread)
        time.sleep(1)  # Delay sedikit agar log gak campur
    
    # Keep main thread alive
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("\n\nShutting down all monitors...")

if __name__ == '__main__':
    main()
