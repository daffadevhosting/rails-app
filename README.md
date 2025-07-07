# 🎨 AI Image Generator - Bayar & Dapat Gambar Instan!

Sebuah aplikasi AI generator gambar berbasis **Ruby on Rails** + **Tailwind CSS**, terintegrasi dengan **Midtrans Snap** untuk pembayaran per gambar.

---

## 🚀 Fitur Utama

- ✨ **Generate gambar AI hanya dengan prompt teks**
- 💳 **Bayar hanya Rp 2.000 per gambar** via Midtrans (Snap Sandbox)
- ⚡ **Gambar langsung diproses setelah pembayaran sukses**
- 📵 **Limit 1 gambar per IP per hari** *(anti-spam & hemat resource)*
- 🎨 **Desain minimalis dengan Tailwind dan animasi GSAP**

---

## 📸 Contoh UI

<img src="public/demo.png" alt="Tampilan UI" width="600">

---

## 🛠️ Tech Stack

- **Frontend**: ERB, Tailwind CSS (CDN), GSAP (CDN)
- **Backend**: Ruby on Rails
- **AI Image Engine**: Cloudflare AI (Stable Diffusion XL)
- **Pembayaran**: Midtrans Snap Sandbox

---

## 📄 FAQ

**Q: Berapa biaya per gambar?**  
A: Rp 2.000 / generate.

**Q: Berapa lama prosesnya?**  
A: Instan! Gambar langsung diproses setelah bayar.

**Q: Apakah bisa refund?**  
A: Tidak, karena layanan berbasis instan.

---

## ⚖️ Terms of Service

Dengan menggunakan aplikasi ini, Anda setuju untuk tidak menggunakan hasil generate untuk konten ilegal, kekerasan, atau SARA. Kami berhak menolak prompt yang melanggar kebijakan kami.

---

## 📥 Instalasi Lokal

```bash
git clone https://github.com/daffadevhosting/rails-app.git
cd rails-app

bundle install
rails db:setup

bin/dev
```
