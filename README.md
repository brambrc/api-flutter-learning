# API Learning Flutter

Aplikasi Flutter untuk belajar penggunaan API dengan package HTTP. Proyek ini mendemonstrasikan konsep-konsep penting dalam konsumsi API menggunakan Flutter.

## 📚 Materi Pembelajaran

### 1. Mengenal Package Flutter

**Package** adalah kumpulan kode atau pustaka yang dapat digunakan kembali untuk menambahkan fungsionalitas pada aplikasi Flutter.

#### Jenis Package:
- **Official Packages**: Dikembangkan oleh tim Flutter (contoh: `path_provider`, `image_picker`)
- **Third-Party Packages**: Dikembangkan oleh komunitas (contoh: `http`, `dio`, `flutter_bloc`)

#### Keuntungan Menggunakan Package:
- Menghemat waktu pengembangan
- Mengurangi jumlah kode yang perlu ditulis
- Mendukung berbagai fitur seperti animasi, navigasi, dan penanganan API

### 2. Package yang Digunakan dalam Proyek Ini

```yaml
dependencies:
  http: ^1.2.0                    # Untuk HTTP requests
  provider: ^6.1.1               # State management sederhana  
  shared_preferences: ^2.2.2     # Penyimpanan data lokal
```

### 3. Pengenalan API

**API (Application Programming Interface)** adalah antarmuka yang memungkinkan aplikasi berkomunikasi dengan server atau layanan lain.

#### Metode HTTP yang Digunakan:
- **GET**: Mengambil data dari server
- **POST**: Mengirim data ke server (membuat data baru)
- **PUT**: Memperbarui data di server
- **DELETE**: Menghapus data di server

### 4. API yang Digunakan

Proyek ini menggunakan **JSONPlaceholder** - API gratis untuk testing dan prototyping:
- Base URL: `https://jsonplaceholder.typicode.com`
- Menyediakan data fake yang realistis
- Mendukung semua HTTP methods
- Tidak memerlukan authentication

## 🏗️ Struktur Proyek

```
lib/
├── main.dart                 # Entry point aplikasi
├── models/                   # Data models
│   ├── post.dart            # Model untuk Post
│   └── user.dart            # Model untuk User
├── services/                 # API services
│   └── api_service.dart     # Service untuk semua API calls
├── screens/                  # UI screens
│   ├── home_screen.dart     # Home screen dengan menu
│   ├── posts_screen.dart    # CRUD operations untuk posts
│   ├── users_screen.dart    # Display users data
│   ├── create_post_screen.dart # Form untuk create/edit post
│   └── api_demo_screen.dart # Testing console untuk API
└── widgets/                  # Reusable widgets
    ├── post_card.dart       # Widget untuk display post
    ├── user_card.dart       # Widget untuk display user
    └── loading_widget.dart  # Loading, error, dan empty states
```

## 🚀 Fitur Aplikasi

### 1. **Posts API Demo**
- ✅ **GET** - Mengambil semua posts
- ✅ **POST** - Membuat post baru
- ✅ **PUT** - Mengupdate post yang ada
- ✅ **DELETE** - Menghapus post

### 2. **Users API Demo**
- ✅ **GET** - Mengambil data users dengan nested objects
- ✅ Menampilkan data kompleks (address, company, dll)

### 3. **API Testing Console**
- ✅ Test semua HTTP methods
- ✅ Melihat request dan response
- ✅ Error handling
- ✅ Connection testing

## 📖 Cara Menggunakan

### 1. Setup Project
```bash
# Clone atau copy project
cd api_learning_flutter

# Install dependencies
flutter pub get

# Run aplikasi
flutter run
```

### 2. Navigasi Aplikasi
1. **Home Screen**: Pilih jenis demo yang ingin dipelajari
2. **Posts Screen**: Praktik CRUD operations
3. **Users Screen**: Lihat cara handle data kompleks
4. **API Demo**: Test dan eksperimen dengan API calls

### 3. Belajar Step by Step

#### Step 1: Pahami Model Data
Lihat file `lib/models/post.dart` dan `lib/models/user.dart` untuk memahami:
- Cara membuat model dari JSON
- Factory constructors
- Method `fromJson()` dan `toJson()`

#### Step 2: Pelajari API Service
Buka `lib/services/api_service.dart` untuk mempelajari:
- Cara setup HTTP client
- Implementasi GET, POST, PUT, DELETE
- Error handling
- Timeout handling

#### Step 3: Pahami UI Integration
Lihat screen files untuk memahami:
- Cara handle loading states
- Error handling di UI
- Integrasi dengan API service
- State management sederhana

## 🔧 Penjelasan Kode Penting

### 1. HTTP GET Request
```dart
static Future<List<Post>> getAllPosts() async {
  final response = await http.get(
    Uri.parse('$baseUrl/posts'),
    headers: {'Content-Type': 'application/json'},
  );
  
  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body);
    return jsonData.map((json) => Post.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load posts');
  }
}
```

### 2. HTTP POST Request
```dart
static Future<Post> createPost(Post post) async {
  final response = await http.post(
    Uri.parse('$baseUrl/posts'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(post.toJson()),
  );
  
  if (response.statusCode == 201) {
    return Post.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to create post');
  }
}
```

### 3. State Management dengan setState
```dart
Future<void> _loadPosts() async {
  setState(() {
    isLoading = true;
    errorMessage = null;
  });

  try {
    final loadedPosts = await ApiService.getAllPosts();
    setState(() {
      posts = loadedPosts;
      isLoading = false;
    });
  } catch (e) {
    setState(() {
      errorMessage = e.toString();
      isLoading = false;
    });
  }
}
```

## 🎯 Learning Points

### 1. **Package Management**
- Cara menambah dependency di `pubspec.yaml`
- Import package yang benar
- Menggunakan package documentation

### 2. **API Integration**
- Setup base URL dan headers
- Handle different HTTP methods
- Parse JSON response
- Error handling yang proper

### 3. **State Management**
- Loading states
- Error states
- Empty states
- Data refresh

### 4. **UI/UX Best Practices**
- Loading indicators
- Error messages yang user-friendly
- Pull-to-refresh
- Form validation

## 🛠️ Tools untuk API Development

Aplikasi ini juga mengenalkan tools yang berguna untuk API development:

1. **Postman**: Testing API endpoints
2. **Browser Developer Tools**: Inspect network requests
3. **Flutter DevTools**: Debug network calls
4. **JSONPlaceholder**: Free API for testing

## 📝 Latihan

### Latihan 1: Basic
1. Jalankan aplikasi dan coba semua fitur
2. Lihat console output saat melakukan API calls
3. Coba edit dan hapus posts

### Latihan 2: Intermediate
1. Tambahkan field baru di model Post
2. Implementasi comments API (endpoint: `/comments`)
3. Tambahkan search functionality

### Latihan 3: Advanced
1. Implementasi pagination
2. Tambahkan offline caching
3. Implementasi proper error handling dengan retry mechanism

## 🔍 Debug Tips

1. **Network Issues**: Cek console untuk error messages
2. **JSON Parsing**: Pastikan model sesuai dengan API response
3. **State Issues**: Gunakan Flutter Inspector
4. **API Issues**: Test endpoint di Postman dulu

## 📚 Resources Tambahan

1. [Flutter HTTP Package Documentation](https://pub.dev/packages/http)
2. [JSONPlaceholder Guide](https://jsonplaceholder.typicode.com/guide/)
3. [Flutter Networking Tutorial](https://docs.flutter.dev/cookbook/networking)
4. [REST API Best Practices](https://restfulapi.net/)

---

**Happy Learning! 🚀**

Proyek ini dibuat untuk memudahkan pemahaman konsep API dalam Flutter. Jangan ragu untuk eksperimen dan modify kode untuk pembelajaran yang lebih mendalam.