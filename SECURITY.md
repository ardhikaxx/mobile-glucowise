# 🛡️ Kebijakan Keamanan (Security Policy)

Keamanan informasi dan kerahasiaan data pengguna serta data operasional adalah prioritas utama dalam pengembangan sistem **Aplikasi Mobile GlucoWise - Akses Umum**.

Aplikasi ini dirancang dengan mematuhi prinsip pengembangan aman (secure development), **Undang-Undang Perlindungan Data Pribadi (UU PDP No. 27 Tahun 2022)**, serta standar enkripsi modern.

---

## 📦 Versi yang Didukung

Pembaruan keamanan dan perbaikan celah (*security patches*) aktif diberikan untuk versi berikut:

| Versi | Status Keamanan |
| :--- | :--- |
| **v1.0.x** | ✅ Didukung Penuh (*Active Security Support*) |
| < 1.0.0 | ❌ Tidak Didukung |

---

## 🔒 Lapisan Keamanan Bawaan (Built-in Security Layers)

1. **Autentikasi & Otorisasi**:
   * Otorisasi berbasis role menggunakan middleware, Policy & Gate sesuai matriks akses.
   * Verifikasi izin pada setiap endpoint — menu disembunyikan DAN backend menolak request ilegal (403/401).
2. **Perlindungan Akun**:
   * Session regeneration setelah login; logout aman + invalidasi sesi.
   * Password disimpan dengan hashing bcrypt/argon2, tidak pernah ditampilkan.
3. **Perlindungan Injeksi & Serangan Web**:
   * Proteksi **CSRF** pada seluruh formulir.
   * Perlindungan **SQL Injection** via ORM/prepared statements.
   * Escaping output dari **XSS**; pesan error tanpa membocorkan error mentah.
4. **Integritas Data**:
   * Kalkulasi penting dihitung ulang di backend (tidak percaya nilai dari browser).
   * Transaksi database atomik untuk operasi multi-tabel.
5. **Audit Trail & Logging**:
   * Aktivitas penting (login/logout, CRUD, transaksi, pembayaran) dicatat beserta pelakunya bila modul tersedia.

---

## 🚨 Melaporkan Celah Keamanan (Reporting a Vulnerability)

Jika Anda menemukan kerentanan atau celah keamanan (*security vulnerability*) dalam sistem ini:

> [!CAUTION]
> **JANGAN** membuat laporan publik melalui GitHub Issues terbuka demi melindungi pengguna sistem.

Silakan kirimkan laporan celah keamanan secara privat dan bertanggung jawab (*Responsible Disclosure*) melalui:

* **Email Penanggung Jawab Keamanan**: `ardhikayanuar58@gmail.com`
* **Subjek Email**: `[SECURITY VULNERABILITY] - Aplikasi Mobile GlucoWise - Akses Umum`

### Informasi yang Wajib Disertakan:
1. Deskripsi mendalam mengenai celah keamanan yang ditemukan.
2. Langkah-langkah detail atau *proof-of-concept (PoC)* untuk mereproduksi masalah.
3. Estimasi potensi dampak terhadap data pengguna atau operasional.

Tim pengembang akan merespons laporan dalam waktu **1x24 jam** dan segera merilis perbaikan (*patch*).

---

Terima kasih atas kerja sama Anda dalam menjaga keamanan ekosistem digital Indonesia.
**Yanuar Ardhika Rahmadhani Ubaidillah (@ardhikaxx)**
