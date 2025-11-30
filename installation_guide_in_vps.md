# Panduan Instalasi Web2Apk di VPS

Dokumen ini berisi langkah-langkah lengkap untuk menginstall semua dependensi yang diperlukan agar project **Web2Apk** dapat berjalan di VPS (Virtual Private Server). Panduan ini diasumsikan menggunakan OS **Ubuntu 20.04 / 22.04 LTS**.

## Spesifikasi Server (Minimum Requirements)
Sebelum memulai, pastikan VPS Anda memenuhi spesifikasi berikut agar proses build Android (Gradle) berjalan lancar:

| Komponen | Minimum | Disarankan |
| :--- | :--- | :--- |
| **CPU** | 1 Core | 2 Core atau lebih |
| **RAM** | 2 GB | 4 GB atau lebih |
| **Storage** | 20 GB SSD | 40 GB SSD |
| **OS** | Ubuntu 20.04 LTS | Ubuntu 22.04 LTS |
| **Port** | 3000 (Default) | - |

> **Catatan:** Proses build Android menggunakan Gradle memakan cukup banyak RAM dan CPU. Jika menggunakan RAM 1GB, kemungkinan besar proses akan gagal (Out of Memory).

## 1. Update System
Pastikan sistem operasi dalam keadaan terbaru.
```bash
sudo apt update && sudo apt upgrade -y
```

## 2. Install Node.js & NPM
Project ini membutuhkan Node.js. Disarankan menggunakan versi LTS (misal v18 atau v20).

```bash
# Install curl jika belum ada
sudo apt install curl -y

# Setup repository Node.js v18 (LTS)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -

# Install Node.js
sudo apt install -y nodejs

# Verifikasi instalasi
node -v
npm -v
```

## 3. Install Java Development Kit (JDK)
Android build membutuhkan Java. Gradle versi 8.x membutuhkan minimal JDK 17.

```bash
sudo apt install openjdk-17-jdk -y

# Verifikasi java (harus menampilkan versi 17.x.x)
java -version
```

## 4. Install Android SDK & Command Line Tools
Ini adalah bagian paling krusial untuk build APK.

### a. Buat direktori untuk Android SDK
```bash
mkdir -p ~/Android/cmdline-tools
cd ~/Android/cmdline-tools
```

### b. Download Command Line Tools
Kunjungi [Android Studio Download](https://developer.android.com/studio#command-tools) untuk link terbaru, atau gunakan perintah di bawah (versi commandlinetools-linux-9477386_latest.zip):

```bash
wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O cmdline-tools.zip
unzip cmdline-tools.zip
mv cmdline-tools latest
rm cmdline-tools.zip
```
*Struktur folder harus: `~/Android/cmdline-tools/latest/bin/sdkmanager`*

### c. Setup Environment Variables
Agar sistem mengenali perintah `sdkmanager` dan `adb`.

Edit file `.bashrc`:
```bash
nano ~/.bashrc
```

Tambahkan baris berikut di bagian paling bawah:
```bash
# Set JAVA_HOME secara dinamis (mengikuti versi 'java' yang aktif)
export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))

# Android SDK
export ANDROID_HOME=$HOME/Android
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$JAVA_HOME/bin
```

Simpan (Ctrl+O, Enter) dan Keluar (Ctrl+X).
Lalu reload konfigurasi:
```bash
source ~/.bashrc
```

### d. Install SDK Platform & Build Tools
Jalankan perintah berikut untuk menginstall komponen Android yang dibutuhkan Cordova:

```bash
# Terima lisensi terlebih dahulu
yes | sdkmanager --licenses

# Install Platform Tools, SDK Platform (Android 14/UpsideDownCake), dan Build Tools 35.0.0
sdkmanager "platform-tools" "platforms;android-34" "build-tools;35.0.0"
```

## 5. Install Gradle
Cordova membutuhkan Gradle untuk memproses build Android.

```bash
# Download Gradle 8.5 (Versi Stabil)
wget -c https://services.gradle.org/distributions/gradle-8.5-bin.zip -P /tmp
sudo unzip -d /opt/gradle /tmp/gradle-8.5-bin.zip

# Buat symlink (pastikan tidak ada symlink lama)
sudo rm /usr/bin/gradle
sudo ln -s /opt/gradle/gradle-8.5/bin/gradle /usr/bin/gradle

# Verifikasi
gradle -v
```

## 6. Install Cordova
Install Cordova secara global menggunakan npm.

```bash
sudo npm install -g cordova
```

## 7. Install Dependensi Project (OPSIONAL JIKA INGIN DI JALANKAN DI VPS)
Sekarang masuk ke direktori project Anda dan install paket-paket npm yang terdaftar di `package.json`.

```bash
# Masuk ke folder project (sesuaikan path-nya)
cd /path/to/Web2Apk

# Install dependencies
npm install
```

## 8. (Opsional) Install PM2
Untuk menjalankan server terus-menerus di background (production mode), disarankan menggunakan PM2.

```bash
sudo npm install -g pm2
```

---

### Ringkasan Package yang Diinstall:
1.  **System**: `curl`, `unzip`, `openjdk-17-jdk`
2.  **Node.js**: `nodejs`
3.  **Android**: `commandlinetools`, `platform-tools`, `platforms;android-33`, `build-tools;33.0.2`
4.  **Build System**: `gradle`
5.  **NPM Global**: `cordova`, `pm2`
6.  **NPM Local**: `express`, `cors`, `multer`, `node-telegram-bot-api`, `uuid`, `body-parser`

Sekarang VPS Anda sudah siap untuk menjalankan perintah `node server.js` atau `pm2 start server.js`.
