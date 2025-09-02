import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/post.dart';

// Data Provider untuk Posts
// Layer ini bertanggung jawab untuk akses langsung ke API
// Tidak mengandung business logic, hanya mengambil dan mengirim data

abstract class PostDataProvider {
  Future<List<Post>> getAllPosts();
  Future<Post> getPostById(int id);
  Future<Post> createPost(Post post);
  Future<Post> updatePost(int id, Post post);
  Future<bool> deletePost(int id);
}

class PostApiProvider implements PostDataProvider {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const Duration timeoutDuration = Duration(seconds: 10);

  @override
  Future<List<Post>> getAllPosts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/posts'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching posts: $e');
    }
  }

  @override
  Future<Post> getPostById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/posts/$id'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return Post.fromJson(jsonData);
      } else {
        throw Exception('Failed to load post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching post: $e');
    }
  }

  @override
  Future<Post> createPost(Post post) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/posts'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(post.toJson()),
      ).timeout(timeoutDuration);

      if (response.statusCode == 201) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return Post.fromJson(jsonData);
      } else {
        throw Exception('Failed to create post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating post: $e');
    }
  }

  @override
  Future<Post> updatePost(int id, Post post) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/posts/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(post.toJson()),
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return Post.fromJson(jsonData);
      } else {
        throw Exception('Failed to update post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating post: $e');
    }
  }

  @override
  Future<bool> deletePost(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/posts/$id'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting post: $e');
    }
  }
}

// Mock Data Provider untuk testing
class MockPostDataProvider implements PostDataProvider {
  final List<Post> _posts = [
    Post(id: 1, userId: 1, title: 'Mock Post 1', body: 'This is a mock post'),
    Post(id: 2, userId: 1, title: 'Mock Post 2', body: 'This is another mock post'),
  ];

  @override
  Future<List<Post>> getAllPosts() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    return List.from(_posts);
  }

  @override
  Future<Post> getPostById(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final post = _posts.firstWhere(
      (p) => p.id == id,
      orElse: () => throw Exception('Post not found'),
    );
    return post;
  }

  @override
  Future<Post> createPost(Post post) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final newPost = post.copyWith(id: _posts.length + 1);
    _posts.add(newPost);
    return newPost;
  }

  @override
  Future<Post> updatePost(int id, Post post) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _posts.indexWhere((p) => p.id == id);
    if (index == -1) throw Exception('Post not found');
    
    _posts[index] = post;
    return post;
  }

  @override
  Future<bool> deletePost(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final initialLength = _posts.length;
    _posts.removeWhere((p) => p.id == id);
    return _posts.length < initialLength;
  }
}
