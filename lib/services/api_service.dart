import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';
import '../models/user.dart';

// Service class untuk menangani semua operasi API
// Menggunakan JSONPlaceholder sebagai contoh API yang mudah dipahami

class ApiService {
  // Base URL untuk JSONPlaceholder API (API gratis untuk testing)
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  
  // Timeout untuk request (opsional, untuk handling error)
  static const Duration timeoutDuration = Duration(seconds: 10);

  // ====== CONTOH GET REQUEST ======
  
  // Mengambil semua posts (GET /posts)
  static Future<List<Post>> getAllPosts() async {
    try {
      print('🔄 Mengambil semua posts...');
      
      final response = await http.get(
        Uri.parse('$baseUrl/posts'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(timeoutDuration);

      print('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Decode JSON response menjadi List
        final List<dynamic> jsonData = json.decode(response.body);
        
        // Convert setiap item JSON menjadi Post object
        final List<Post> posts = jsonData
            .map((json) => Post.fromJson(json))
            .toList();
            
        print('✅ Berhasil mengambil ${posts.length} posts');
        return posts;
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error saat mengambil posts: $e');
      throw Exception('Error fetching posts: $e');
    }
  }

  // Mengambil single post berdasarkan ID (GET /posts/{id})
  static Future<Post> getPostById(int id) async {
    try {
      print('🔄 Mengambil post dengan ID: $id');
      
      final response = await http.get(
        Uri.parse('$baseUrl/posts/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(timeoutDuration);

      print('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final Post post = Post.fromJson(jsonData);
        
        print('✅ Berhasil mengambil post: ${post.title}');
        return post;
      } else {
        throw Exception('Failed to load post: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error saat mengambil post: $e');
      throw Exception('Error fetching post: $e');
    }
  }

  // Mengambil semua users (GET /users)
  static Future<List<User>> getAllUsers() async {
    try {
      print('🔄 Mengambil semua users...');
      
      final response = await http.get(
        Uri.parse('$baseUrl/users'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(timeoutDuration);

      print('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final List<User> users = jsonData
            .map((json) => User.fromJson(json))
            .toList();
            
        print('✅ Berhasil mengambil ${users.length} users');
        return users;
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error saat mengambil users: $e');
      throw Exception('Error fetching users: $e');
    }
  }

  // ====== CONTOH POST REQUEST ======
  
  // Membuat post baru (POST /posts)
  static Future<Post> createPost(Post post) async {
    try {
      print('🔄 Membuat post baru: ${post.title}');
      
      final response = await http.post(
        Uri.parse('$baseUrl/posts'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(post.toJson()),
      ).timeout(timeoutDuration);

      print('📡 Response status: ${response.statusCode}');
      print('📤 Data yang dikirim: ${json.encode(post.toJson())}');

      if (response.statusCode == 201) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final Post newPost = Post.fromJson(jsonData);
        
        print('✅ Berhasil membuat post dengan ID: ${newPost.id}');
        return newPost;
      } else {
        throw Exception('Failed to create post: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error saat membuat post: $e');
      throw Exception('Error creating post: $e');
    }
  }

  // ====== CONTOH PUT REQUEST ======
  
  // Mengupdate post yang sudah ada (PUT /posts/{id})
  static Future<Post> updatePost(int id, Post post) async {
    try {
      print('🔄 Mengupdate post dengan ID: $id');
      
      final response = await http.put(
        Uri.parse('$baseUrl/posts/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(post.toJson()),
      ).timeout(timeoutDuration);

      print('📡 Response status: ${response.statusCode}');
      print('📤 Data yang dikirim: ${json.encode(post.toJson())}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final Post updatedPost = Post.fromJson(jsonData);
        
        print('✅ Berhasil mengupdate post: ${updatedPost.title}');
        return updatedPost;
      } else {
        throw Exception('Failed to update post: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error saat mengupdate post: $e');
      throw Exception('Error updating post: $e');
    }
  }

  // ====== CONTOH DELETE REQUEST ======
  
  // Menghapus post (DELETE /posts/{id})
  static Future<bool> deletePost(int id) async {
    try {
      print('🔄 Menghapus post dengan ID: $id');
      
      final response = await http.delete(
        Uri.parse('$baseUrl/posts/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(timeoutDuration);

      print('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('✅ Berhasil menghapus post dengan ID: $id');
        return true;
      } else {
        throw Exception('Failed to delete post: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error saat menghapus post: $e');
      throw Exception('Error deleting post: $e');
    }
  }

  // ====== UTILITY METHODS ======
  
  // Method untuk check koneksi ke API
  static Future<bool> checkApiConnection() async {
    try {
      print('🔄 Mengecek koneksi ke API...');
      
      final response = await http.get(
        Uri.parse('$baseUrl/posts/1'),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        print('✅ Koneksi ke API berhasil');
        return true;
      } else {
        print('❌ Koneksi ke API gagal: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Error koneksi ke API: $e');
      return false;
    }
  }
}
