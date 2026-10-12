# 🤝 Panduan Kontribusi (Contributing Guidelines)

Terima kasih atas minat Anda pada proyek **Aplikasi Mobile GlucoWise - Akses Umum**!

Aplikasi ini dikelola dan dirancang oleh **Yanuar Ardhika Rahmadhani Ubaidillah (@ardhikaxx)**. Karena proyek berlisensi **Proprietary (All Rights Reserved)**, kontribusi berlangsung dengan ketentuan sebagai berikut.

---

## 📌 Prinsip & Kebijakan Hak Cipta

1. **Kepemilikan Kode**: Proyek ini dilindungi hak cipta atas nama **Yanuar Ardhika Rahmadhani Ubaidillah (@ardhikaxx)**.
2. **Larangan Plagiarisme**: Dilarang keras menghapus watermark, metadata hak cipta, atau mengubah *author attribution* yang tertanam dalam sistem (lihat [LICENSE](./LICENSE)).
3. Setiap kontribusi kode yang diterima menjadi bagian dari basis kode proyek berlisensi resmi, dan hak ciptanya melekat pada pemilik proyek.
4. Kontribusi dilakukan melalui *pull request*; dengan mengirimkan kontribusi, Anda menyatakan bahwa kode tersebut adalah karya Anda sendiri dan Anda memberikannya kepada pemilik proyek.

---

## 🛠️ Standar Pengembangan Kode (Code Standards)

* **Ikuti stack yang sudah ada** (Mobile, Backend) dan konvensi direktori yang berlaku.
* **Standar Kode**: PHP mematuhi **PSR-12** (`vendor/bin/pint --dirty`); JS/Dart mengikuti formatter bawaan (`npm run format` / `dart format`).
* **Struktur**: Logika bisnis kompleks wajib di layer Service, bukan di controller/UI. Validasi via FormRequest/validator dengan pesan Bahasa Indonesia.
* **Keamanan**:
  * Semua endpoint wajib otorisasi backend sesuai matriks akses role.
  * Jangan menyimpan data sensitif plaintext; password selalu hashing.
  * Gunakan ORM/query builder (anti SQL Injection) + escaping output (anti XSS) + CSRF.
* **Bahasa Antarmuka**: Seluruh label UI dan pesan validasi menggunakan **Bahasa Indonesia**.
* **Testing**: Setiap fitur baru wajib disertai test. Pastikan seluruh test suite lolos sebelum PR.

---

## 🌿 Alur Kerja Git (Git Workflow)

1. **Fork & Clone Repository**:
   ```bash
   git clone https://github.com/ardhikaxx/mobile-glucowise.git
   cd mobile-glucowise
   ```

2. **Buat Branch Fitur / Perbaikan**:
   * `feat/nama-fitur` (untuk fitur baru)
   * `fix/nama-bug` (untuk perbaikan bug)
   * `docs/nama-dokumentasi` (untuk dokumentasi)

   ```bash
   git checkout -b feat/modul-baru
   ```

3. **Format Commit Message**:
   Gunakan konvensi [Conventional Commits](https://www.conventionalcommits.org/) dengan deskripsi berbahasa Indonesia:
   * `feat: penambahan laporan bulanan`
   * `fix: perbaikan perhitungan kembalian`
   * `docs: perbaikan panduan instalasi`

4. **Kirim Pull Request**:
   * Satu PR berfokus pada satu perubahan logis.
   * Sertakan deskripsi perubahan, alasan, dan bukti verifikasi lolos.
   * PR akan ditinjau oleh maintainer sebelum digabungkan.

---

## 🐞 Melaporkan Bug

* Gunakan [GitHub Issues](https://github.com/ardhikaxx/mobile-glucowise/issues) dengan template yang tersedia.
* Sertakan versi stack, langkah reproduksi, dan perilaku yang diharapkan.
* Untuk celah keamanan, **jangan** gunakan Issues — ikuti [SECURITY.md](./SECURITY.md).

---

Terima kasih telah membantu proyek ini berkembang!

**Yanuar Ardhika Rahmadhani Ubaidillah (@ardhikaxx)**
