# GlucoWise Mobile

Aplikasi mobile berbasis Flutter untuk deteksi dini dan pengelolaan diabetes. GlucoWise membantu pengguna melakukan pencatatan pemeriksaan gula darah, mengelola jadwal obat, dan memperoleh edukasi serta rekomendasi gaya hidup sehat.

## Fitur Utama

- **GlucoScreening** untuk skrining awal risiko diabetes.
- **GlucoCheck** untuk pencatatan pemeriksaan gula darah dan riwayat hasil.
- **GlucoCare** untuk pengingat minum obat dan manajemen jadwal (alarm + notifikasi).
- **Glucozia AI** untuk edukasi dan rekomendasi gaya hidup sehat.
- **GlucoID** (QR identitas digital) untuk memudahkan akses informasi kesehatan.
- **Profil pengguna** dan halaman informasi aplikasi (privasi & syarat ketentuan).

## Teknologi

- **Flutter** (Dart) untuk antarmuka multi-platform.
- **GetX** untuk navigasi dan manajemen state.
- **Flutter Local Notifications** untuk pengingat/alarm.
- **Shared Preferences** untuk penyimpanan lokal sederhana.

## Prasyarat

- Flutter SDK (sesuaikan dengan versi pada `pubspec.yaml`)
- Android Studio / Xcode (untuk menjalankan emulator/simulator)

## Menjalankan Aplikasi

1. Install dependencies:
   ```bash
   flutter pub get
   ```
2. Jalankan aplikasi:
   ```bash
   flutter run
   ```

## Build Produksi

- Android APK:
  ```bash
  flutter build apk
  ```
- Android App Bundle:
  ```bash
  flutter build appbundle
  ```
- iOS:
  ```bash
  flutter build ios
  ```

## Struktur Direktori

```
lib/
  auth/         # autentikasi
  components/   # komponen UI reusable
  data/         # data statis atau dummy
  model/        # model data
  page/         # layar/halaman aplikasi
  services/     # service (API, storage, dll)
  utils/        # helper & utilitas
```

## Catatan

- Ikuti panduan privasi dan syarat & ketentuan yang tersedia di dalam aplikasi.
- Pastikan konfigurasi notifikasi/alarm di perangkat sudah diizinkan.

## Lisensi

Proyek ini bersifat privat dan tidak ditujukan untuk publikasi ke pub.dev.
