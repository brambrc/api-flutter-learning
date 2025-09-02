# API Learning Flutter

Aplikasi Flutter untuk belajar penggunaan API dengan package HTTP dan BLoC Architecture. Proyek ini mendemonstrasikan konsep-konsep penting dalam konsumsi API dan state management menggunakan Flutter.

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
  flutter_bloc: ^8.1.3           # BLoC state management
  get_it: ^7.6.4                 # Dependency injection
  equatable: ^2.0.5              # State comparison helper

dev_dependencies:
  bloc_test: ^9.1.4              # Testing BLoC components
  mocktail: ^1.0.1               # Mocking untuk testing
```

### 3. Pengenalan API

**API (Application Programming Interface)** adalah antarmuka yang memungkinkan aplikasi berkomunikasi dengan server atau layanan lain.

#### Metode HTTP yang Digunakan:
- **GET**: Mengambil data dari server
- **POST**: Mengirim data ke server (membuat data baru)
- **PUT**: Memperbarui data di server
- **DELETE**: Menghapus data di server

### 4. BLoC Architecture

Proyek ini mengimplementasikan **BLoC (Business Logic Component) Architecture**:

#### Layer Architecture:
- **Presentation Layer**: UI components (Widgets)
- **Business Logic Layer**: BLoC dan Cubit untuk state management
- **Data Layer**: Repository dan Data Provider untuk akses data

#### Pattern yang Digunakan:
- **BLoC Pattern**: Event + State untuk complex logic
- **Cubit Pattern**: Method calls untuk simple state changes
- **Repository Pattern**: Abstraksi data sources
- **Dependency Injection**: GetIt untuk loose coupling

### 5. API yang Digunakan

Proyek ini menggunakan **JSONPlaceholder** - API gratis untuk testing dan prototyping:
- Base URL: `https://jsonplaceholder.typicode.com`
- Menyediakan data fake yang realistis
- Mendukung semua HTTP methods
- Tidak memerlukan authentication

## 🏗️ Struktur Proyek

```
lib/
├── main.dart                     # Entry point dengan DI setup
├── core/                         # Core functionalities
│   └── dependency_injection.dart # GetIt setup dan configuration
├── models/                       # Data models
│   ├── post.dart                # Model untuk Post
│   └── user.dart                # Model untuk User (complex model)
├── data/                         # Data Layer
│   ├── providers/               # Data providers (API access)
│   │   ├── post_data_provider.dart
│   │   └── user_data_provider.dart
│   └── repositories/            # Repository pattern
│       ├── post_repository.dart
│       └── user_repository.dart
├── bloc/                         # BLoC components
│   ├── post_bloc.dart           # BLoC untuk Posts
│   ├── post_event.dart          # Events untuk PostBloc
│   └── post_state.dart          # States untuk PostBloc
├── cubit/                        # Cubit components
│   ├── user_cubit.dart          # Cubit untuk Users
│   └── user_state.dart          # States untuk UserCubit
├── screens/                      # UI screens
│   ├── home_screen.dart         # Home dengan menu navigation
│   ├── posts_screen.dart        # setState pattern demo
│   ├── bloc_posts_screen.dart   # BLoC pattern demo
│   ├── users_screen.dart        # setState pattern demo
│   ├── cubit_users_screen.dart  # Cubit pattern demo
│   ├── create_post_screen.dart  # Form setState version
│   ├── bloc_create_post_screen.dart # Form BLoC version
│   └── api_demo_screen.dart     # API testing console
├── widgets/                      # Reusable widgets
│   ├── post_card.dart           # Widget untuk display post
│   ├── user_card.dart           # Widget untuk display user
│   └── loading_widget.dart      # Loading, error, empty states
└── services/                     # Legacy API service
    └── api_service.dart         # Direct API calls (for comparison)
```

## 🚀 Fitur Aplikasi

### 1. **State Management Comparison**
- ✅ **setState Pattern** - Posts & Users (traditional approach)
- ✅ **BLoC Pattern** - Posts dengan Events + States
- ✅ **Cubit Pattern** - Users dengan method calls
- ✅ **Dependency Injection** - GetIt untuk loose coupling

### 2. **CRUD Operations**
- ✅ **GET** - Mengambil semua posts/users
- ✅ **POST** - Membuat post baru
- ✅ **PUT** - Mengupdate post yang ada
- ✅ **DELETE** - Menghapus post

### 3. **Advanced Features**
- ✅ **Search & Filter** - Pencarian posts dan users
- ✅ **Caching** - Repository layer caching
- ✅ **Error Handling** - Comprehensive error states
- ✅ **Loading States** - Proper loading indicators
- ✅ **Unit Testing** - BLoC dan Cubit testing

### 4. **API Integration**
- ✅ **Data Providers** - Abstraksi API calls
- ✅ **Repository Pattern** - Data source abstraction
- ✅ **Mock Data** - Testing dengan mock providers
- ✅ **API Testing Console** - Live API testing tools

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
1. **Home Screen**: Pilih pattern dan demo yang ingin dipelajari
2. **Posts API** (setState): Traditional state management
3. **Posts BLoC**: Event-driven state management
4. **Users API** (setState): Traditional approach untuk data kompleks
5. **Users Cubit**: Simple state management dengan methods
6. **API Demo**: Testing console untuk semua operations

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

#### Step 3: Pelajari Data Layer
Eksplorasi arsitektur data layer:
- **Data Providers** (`lib/data/providers/`) - Akses langsung ke API
- **Repositories** (`lib/data/repositories/`) - Abstraksi dan caching
- **Dependency Injection** (`lib/core/dependency_injection.dart`)

#### Step 4: Pahami BLoC Pattern
Buka `lib/bloc/` untuk mempelajari:
- **Events** (`post_event.dart`) - Actions yang dikirim ke BLoC
- **States** (`post_state.dart`) - Representasi kondisi aplikasi
- **BLoC** (`post_bloc.dart`) - Business logic dan event handling

#### Step 5: Pahami Cubit Pattern
Lihat `lib/cubit/` untuk memahami:
- **States** (`user_state.dart`) - Kondisi aplikasi
- **Cubit** (`user_cubit.dart`) - Simple state management dengan methods

#### Step 6: Bandingkan UI Patterns
Bandingkan implementasi yang berbeda:
- **setState**: `posts_screen.dart` vs `bloc_posts_screen.dart`
- **BlocBuilder**: Rebuild UI berdasarkan state
- **BlocListener**: Handle side effects (snackbar, navigation)
- **BlocConsumer**: Kombinasi builder + listener

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

### 4. BLoC Event and State
```dart
// Event - Action yang dikirim ke BLoC
abstract class PostEvent extends Equatable {
  const PostEvent();
}

class LoadPosts extends PostEvent {
  const LoadPosts();
  @override
  List<Object?> get props => [];
}

// State - Kondisi aplikasi
abstract class PostState extends Equatable {
  const PostState();
}

class PostLoading extends PostState {
  const PostLoading();
  @override
  List<Object?> get props => [];
}

class PostLoaded extends PostState {
  final List<Post> posts;
  const PostLoaded({required this.posts});
  @override
  List<Object?> get props => [posts];
}
```

### 5. BLoC Implementation
```dart
class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository _repository;
  
  PostBloc(this._repository) : super(const PostInitial()) {
    on<LoadPosts>(_onLoadPosts);
  }

  Future<void> _onLoadPosts(LoadPosts event, Emitter<PostState> emit) async {
    emit(const PostLoading());
    try {
      final posts = await _repository.getAllPosts();
      emit(PostLoaded(posts: posts));
    } catch (error) {
      emit(PostError(error.toString()));
    }
  }
}
```

### 6. BLoC UI Integration
```dart
BlocBuilder<PostBloc, PostState>(
  builder: (context, state) {
    if (state is PostLoading) {
      return const CircularProgressIndicator();
    } else if (state is PostLoaded) {
      return ListView.builder(
        itemCount: state.posts.length,
        itemBuilder: (context, index) {
          return PostCard(post: state.posts[index]);
        },
      );
    } else if (state is PostError) {
      return Text('Error: ${state.message}');
    }
    return const SizedBox();
  },
)
```

### 7. Cubit Implementation
```dart
class UserCubit extends Cubit<UserState> {
  final UserRepository _repository;
  
  UserCubit(this._repository) : super(const UserInitial());

  Future<void> loadUsers() async {
    emit(const UserLoading());
    try {
      final users = await _repository.getAllUsers();
      emit(UserLoaded(users: users));
    } catch (error) {
      emit(UserError(error.toString()));
    }
  }
}
```

### 8. Dependency Injection
```dart
// Setup dependencies
Future<void> setupDependencyInjection() async {
  getIt.registerLazySingleton<PostDataProvider>(() => PostApiProvider());
  getIt.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(getIt<PostDataProvider>()),
  );
  getIt.registerFactory<PostBloc>(() => PostBloc(getIt<PostRepository>()));
}

// Usage in UI
BlocProvider(
  create: (context) => getIt<PostBloc>()..add(const LoadPosts()),
  child: PostsView(),
)
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