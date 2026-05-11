#!/usr/bin/env python3
import imaplib
import email
import subprocess
import time
from email.header import decode_header
import ssl

# Config
EMAIL = "satriaegovania04@gmail.com"
PASSWORD = "rocl bgkz esey fjyq"  # dari myaccount.google.com/apppasswords
IMAP_SERVER = "imap.gmail.com"
CHECK_INTERVAL = 5  # Interval pengecekan dalam detik (bisa diubah)
NOTIFICATION_ICON = "/home/ego/media/picture/asset/notify/gmailnotif.jpg"  # Path gambar notifikasi

# Track seen emails
seen_emails = set()

def notify(title, body):
    # Notifikasi dengan gambar custom
    subprocess.run([
        'notify-send', 
        '-i', NOTIFICATION_ICON,  # Gambar custom
        '-u', 'normal',  # Urgency level
        '-t', '10000',  # Tampil 10 detik
        title, 
        body
    ])
    # Play sound
    subprocess.Popen(['paplay', '/home/ego/media/picture/asset/notify/notifemail.mp3'], 
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

def check_new_emails(mail):
    global seen_emails
    
    try:
        status, messages = mail.search(None, 'UNSEEN')
        if status != 'OK' or not messages[0]:
            return
        
        email_ids = messages[0].split()
        
        # Konversi semua ke string dulu
        current_unseen = set()
        for num in email_ids:
            if isinstance(num, bytes):
                current_unseen.add(num.decode('utf-8'))
            else:
                current_unseen.add(str(num))
        
        # Cari email yang benar-benar baru (belum pernah dilihat)
        new_emails = current_unseen - seen_emails
        
        if not new_emails:
            return
        
        print(f"Found {len(new_emails)} new email(s)")
        
        for num_str in new_emails:
            try:
                # Fetch email
                fetch_id = num_str.encode('utf-8')
                
                status, msg_data = mail.fetch(fetch_id, '(RFC822)')
                
                # DEBUG: Lihat struktur response
                print(f"DEBUG email {num_str} - status: {status}")
                print(f"DEBUG email {num_str} - msg_data type: {type(msg_data)}")
                print(f"DEBUG email {num_str} - msg_data: {msg_data}")
                
                if status != 'OK' or not msg_data:
                    print(f"Failed to fetch email {num_str}, will retry later")
                    continue
                
                # Cari email body dari response (struktur bisa beda-beda)
                email_body = None
                for item in msg_data:
                    if isinstance(item, tuple) and len(item) >= 2:
                        if isinstance(item[1], bytes):
                            email_body = item[1]
                            break
                
                if email_body is None:
                    print(f"Email {num_str}: Could not find email body in response, will retry later")
                    continue
                
                msg = email.message_from_bytes(email_body)
                subject = decode_str(msg.get('Subject', 'No Subject'))
                from_addr = decode_str(msg.get('From', 'Unknown'))
                
                if '<' in from_addr:
                    from_addr = from_addr.split('<')[0].strip().strip('"')
                
                print(f"New email from: {from_addr}")
                print(f"Subject: {subject}")
                
                # Format notifikasi yang lebih menarik
                notify_title = "Ada email mas!"
                notify_body = f"{from_addr}\n{subject}"
                
                notify(notify_title, notify_body)
                
                # HANYA tambahkan ke seen_emails kalau BERHASIL diproses
                seen_emails.add(num_str)
                
            except Exception as e:
                print(f"Error processing email {num_str}: {e}, will retry later")
                import traceback
                traceback.print_exc()
                continue
                
    except Exception as e:
        print(f"Error checking emails: {e}")
        import traceback
        traceback.print_exc()

def idle_loop():
    global seen_emails
    
    while True:
        mail = None
        try:
            print("Connecting to Gmail...")
            context = ssl.create_default_context()
            mail = imaplib.IMAP4_SSL(IMAP_SERVER, 993, ssl_context=context)
            mail.login(EMAIL, PASSWORD)
            mail.select('INBOX')
            
            # Inisialisasi: tandai semua email UNSEEN yang sudah ada sebelum monitoring dimulai
            if not seen_emails:
                status, messages = mail.search(None, 'UNSEEN')
                if status == 'OK' and messages[0]:
                    for msg_id in messages[0].split():
                        if isinstance(msg_id, bytes):
                            seen_emails.add(msg_id.decode('utf-8'))
                        else:
                            seen_emails.add(str(msg_id))
                    print(f"Initialized with {len(seen_emails)} existing unread emails (will not notify)")
            
            print("Connected. Monitoring for new emails...")
            
            last_check = time.time()
            
            while True:
                try:
                    mail.noop()
                    
                    if time.time() - last_check > CHECK_INTERVAL:
                        check_new_emails(mail)
                        last_check = time.time()
                    
                    time.sleep(CHECK_INTERVAL)
                    
                except imaplib.IMAP4.abort:
                    print("Connection lost, reconnecting...")
                    break
                except Exception as e:
                    print(f"Error in loop: {e}")
                    break
                
        except KeyboardInterrupt:
            print("\nShutting down...")
            break
        except Exception as e:
            print(f"Connection error: {e}")
            print("Reconnecting in 10 seconds...")
            time.sleep(10)
        finally:
            if mail:
                try:
                    mail.logout()
                except:
                    pass

if __name__ == '__main__':
    print("Gmail Real-time Notification Monitor")
    print("Ctrl+C to stop")
    idle_loop()
