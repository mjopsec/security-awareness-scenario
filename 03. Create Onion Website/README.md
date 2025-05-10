## 🔧 Step-by-Step Setup Tor Hidden Service di EndeavourOS

---

### 1. ✅ **Install Tor**

Jalankan perintah:

```bash
sudo pacman -S tor
```

---

### 2. ✅ **Aktifkan & Jalankan Tor**

Enable agar auto-start saat boot:

```bash
sudo systemctl enable tor
```

Jalankan sekarang:

```bash
sudo systemctl start tor
```

---

### 3. ✅ **Setup Web Server Lokal (Flask)**

Install Python dan Flask:

```bash
sudo pacman -S python python-pip
pip install flask
```

Buat file `app.py`:

```python
from flask import Flask
app = Flask(__name__)

@app.route('/')
def home():
    return "Hello from .onion!"

if __name__ == '__main__':
    app.run(host='127.0.0.1', port=8080)
```

Jalankan:

```bash
python app.py
```

---

### 4. ✅ **Konfigurasi Hidden Service di Tor**

Edit file konfigurasi Tor:

```bash
sudo nano /etc/tor/torrc
```

Tambahkan ini di akhir file:

```bash
HiddenServiceDir /var/lib/tor/hidden_web/
HiddenServicePort 80 127.0.0.1:8080
```

**Simpan dan keluar** (`Ctrl+O`, `Enter`, `Ctrl+X`).

---

### 5. ✅ **Restart Tor**

```bash
sudo systemctl restart tor
```

---

### 6. ✅ **Dapatkan Alamat .onion**

```bash
sudo cat /var/lib/tor/hidden_web/hostname
```

Kamu akan dapat hasil seperti:

```
abcdef1234567890.onion
```

Buka Tor Browser, masukin alamat `.onion` tersebut, dan boom — web kamu bisa diakses via Tor 🎉

---

### 7. ✅ (Opsional) Jika Ada Error Permission:

Kadang direktori `/var/lib/tor/hidden_web/` perlu permission:

```bash
sudo chown -R tor:tor /var/lib/tor/hidden_web/
sudo chmod 700 /var/lib/tor/hidden_web/
```

---

### ✅ Selesai!
![Onion](onion.png)

Sekarang kamu udah bisa:

* Hosting `.onion` di EndeavourOS,
* Tanpa expose IP asli,
* Tanpa domain berbayar,
* Siap buat infrastruktur stealth Red Teaming.

## 🔥 Skenario Terbaik Penggunaan Tor dalam Red Teaming

---

### 1. 🧠 **Command & Control (C2) Backup Channel (Out-of-Band / Egress Path)**

* ✅ **Tujuan**: Jadi jalur alternatif kalau domain utama di-block atau sinkhole.
* ✅ **Contoh**: Jika primary C2 pakai HTTPS biasa dan di-blacklist, fallback-nya adalah `.onion` C2 listener.
* ✅ **Keuntungan**: Tetap bisa kontrol agent secara stealth saat infrastruktur utama di-take down.

---

### 2. 💬 **Operator Panel (Dashboard) Hidden**

* ✅ **Tujuan**: Dashboard C2 atau admin panel hanya bisa diakses via Tor.
* ✅ **Contoh**: Mythic Web UI / Covenant hanya bisa dibuka dari `.onion`.
* ✅ **Keuntungan**: Menghindari scan otomatis, crawler Shodan, atau traffic visibility oleh ISP/VPS provider.

---

### 3. 📥 **Payload Hosting Stealth**

* ✅ **Tujuan**: Simpan payload, exploit, atau stager di server `.onion`.
* ✅ **Contoh**: Victim download PowerShell loader dari `xyz123abc.onion/drop.ps1`.
* ✅ **Keuntungan**: Tidak bisa ditrace balik ke domain kamu, anti-blacklist, dan sulit untuk ditakedown.

---

### 4. 🎣 **Phishing Site Stealth / Malicious Login Portal**

* ✅ **Tujuan**: Host phishing page yang meniru login perusahaan, email, dll.
* ✅ **Contoh**: Link phishing diarahkan ke `.onion` dengan lookalike domain.
* ✅ **Keuntungan**: Lebih lama hidup karena bukan di internet biasa. Sulit dilacak.

---

### 5. 🔁 **Proxy / Bounce Server (Tor2Web Style)**

* ✅ **Tujuan**: Gunakan Tor sebagai proxy keluar (misalnya melalui proxychains), atau relay komunikasi malware.
* ✅ **Contoh**: Tools seperti `proxychains` diarahkan ke SOCKS5 Tor untuk browsing dengan IP acak.
* ✅ **Keuntungan**: IP sumber kamu disembunyikan sepenuhnya, bagus untuk recon dan scanning stealth.

---

### 6. 🧪 **Simulasi APT / Adversary Emulation**

* ✅ **Tujuan**: Emulasi TTP APT yang benar-benar realistis (beberapa APT memang pakai .onion, seperti APT29).
* ✅ **Contoh**: Lab internal atau campaign red team menyimulasikan C2 via onion untuk evasion.
* ✅ **Keuntungan**: Dapat validasi blue team terhadap serangan berbasis stealth.

---

### 7. 🔐 **Authentication Service atau File Exfiltration Gateway**

* ✅ **Tujuan**: Server `.onion` sebagai endpoint untuk receive file hasil exfil (log, dump, dll).
* ✅ **Contoh**: Agent mengekstrak password hash dan POST ke `.onion/upload`.
* ✅ **Keuntungan**: File tidak lewat internet biasa, lebih sulit dilacak/detect.

---

### 📛 Yang **Kurang Cocok** (karena latency atau overhead):

| Use-case                                    | Kenapa tidak cocok via Tor            |
| ------------------------------------------- | ------------------------------------- |
| Real-time C2 (interactive shell, RDP, etc.) | Terlalu lambat dan delay tinggi       |
| File besar (tools, ZIP >10MB)               | Upload/download lambat                |
| Persistence beacon rapid (tiap detik)       | Terlalu noisy dan boros bandwidth Tor |

---

### 📌 Summary:

| Skenario                        | Status         |
| ------------------------------- | -------------- |
| Backup C2 channel (fallback)    | ✅ Sangat cocok |
| Hidden admin/operator dashboard | ✅ Cocok        |
| Payload/file hosting            | ✅ Cocok        |
| Phishing page (.onion)          | ✅ Cocok        |
| Proxychains / stealth recon     | ✅ Cocok        |
| Live shell/RDP                  | ❌ Tidak cocok  |
| Large file transfers            | ❌ Tidak cocok  |

