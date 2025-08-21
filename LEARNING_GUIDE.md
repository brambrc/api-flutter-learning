# 📖 Panduan Belajar API dengan Flutter

## 🎯 Tujuan Pembelajaran

Setelah menyelesaikan tutorial ini, Anda akan memahami:
- Cara menggunakan package HTTP di Flutter
- Implementasi CRUD operations (GET, POST, PUT, DELETE)
- Penanganan state management sederhana
- Error handling yang baik
- Struktur project Flutter yang rapi

## 📋 Langkah-langkah Belajar

### 1. Persiapan (5 menit)
```bash
cd api_learning_flutter
flutter pub get
flutter run
```

### 2. Eksplorasi Struktur Project (10 menit)
Buka dan pelajari file-file berikut secara berurutan:

1. **`lib/main.dart`** - Entry point aplikasi
2. **`lib/models/post.dart`** - Model data sederhana
3. **`lib/models/user.dart`** - Model data kompleks
4. **`lib/services/api_service.dart`** - Service untuk API calls

### 3. Praktik GET Request (15 menit)

#### Langkah:
1. Buka aplikasi di emulator/device
2. Pilih menu "Posts API"
3. Amati bagaimana data dimuat
4. Coba refresh dengan pull-to-refresh
5. Lihat console output untuk memahami proses

#### Yang dipelajari:
- HTTP GET request
- JSON parsing
- Loading states
- Error handling

### 4. Praktik POST Request (15 menit)

#### Langkah:
1. Di Posts screen, tekan tombol "+" (floating action button)
2. Isi form untuk membuat post baru
3. Tekan "Simpan Post"
4. Amati response dari server

#### Yang dipelajari:
- HTTP POST request
- Form handling
- Sending JSON data
- Response handling

### 5. Praktik PUT Request (10 menit)

#### Langkah:
1. Di Posts screen, tekan tombol "Edit" pada salah satu post
2. Ubah title atau body
3. Tekan "Update Post"
4. Lihat perubahan data

#### Yang dipelajari:
- HTTP PUT request
- Update existing data
- Form validation

### 6. Praktik DELETE Request (10 menit)

#### Langkah:
1. Di Posts screen, tekan tombol "Delete" pada salah satu post
2. Konfirmasi penghapusan
3. Amati post hilang dari list

#### Yang dipelajari:
- HTTP DELETE request
- Confirmation dialogs
- Local state update

### 7. Eksplorasi Data Kompleks (10 menit)

#### Langkah:
1. Pilih menu "Users API" 
2. Lihat bagaimana data nested (address, company) ditampilkan
3. Tap pada user card untuk melihat detail

#### Yang dipelajari:
- Handling nested JSON objects
- Complex data structures
- UI design for complex data

### 8. API Testing Console (15 menit)

#### Langkah:
1. Pilih menu "API Demo"
2. Coba semua tombol test satu per satu
3. Baca output console untuk memahami request/response

#### Yang dipelajari:
- Raw API responses
- Request/response debugging
- API testing methodology

## 🔍 Hal Penting yang Perlu Diperhatikan

### 1. Error Handling
```dart
try {
  final posts = await ApiService.getAllPosts();
  // Handle success
} catch (e) {
  // Handle error
  print('Error: $e');
}
```

### 2. Loading States
```dart
setState(() {
  isLoading = true;
});

// API call here

setState(() {
  isLoading = false;
});
```

### 3. JSON Parsing
```dart
// From JSON
factory Post.fromJson(Map<String, dynamic> json) {
  return Post(
    id: json['id'] ?? 0,
    title: json['title'] ?? '',
  );
}

// To JSON
Map<String, dynamic> toJson() {
  return {
    'id': id,
    'title': title,
  };
}
```

## 🧪 Latihan Mandiri

### Latihan 1: Modifikasi Model
Tambahkan field baru di model Post (misalnya: `createdAt`, `tags`)

### Latihan 2: Custom Error Handling
Buat custom error widget dengan pesan yang lebih informatif

### Latihan 3: Search Functionality
Implementasikan pencarian posts berdasarkan title

### Latihan 4: Pagination
Implementasikan pagination untuk mengambil posts secara bertahap

### Latihan 5: Offline Storage
Simpan data posts ke local storage menggunakan SharedPreferences

## ❓ Troubleshooting

### Error: "No internet connection"
- Pastikan device/emulator terkoneksi internet
- Coba test connection di API Demo screen

### Error: "Failed to load data"
- Cek console untuk error detail
- JSONPlaceholder mungkin sedang down, coba lagi nanti

### Error: "JSON parsing failed"
- Periksa struktur model vs API response
- Gunakan tools seperti Postman untuk debug API

### App crash
- Cek console log untuk stack trace
- Restart app dan coba lagi

## 📚 Resources Tambahan

1. **Flutter HTTP Documentation**: https://pub.dev/packages/http
2. **JSONPlaceholder API Guide**: https://jsonplaceholder.typicode.com/guide/
3. **Flutter State Management**: https://docs.flutter.dev/data-and-backend/state-mgmt
4. **REST API Best Practices**: https://restfulapi.net/

## 🎉 Selamat!

Jika Anda sudah menyelesaikan semua langkah di atas, Anda sudah memahami dasar-dasar penggunaan API di Flutter. Lanjutkan dengan membuat project sendiri untuk mempraktikkan lebih lanjut!

---

Happy Coding! 🚀
