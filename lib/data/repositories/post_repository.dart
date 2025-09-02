import '../providers/post_data_provider.dart';
import '../../models/post.dart';

// Repository Pattern: Abstraksi antara BLoC dan Data Provider
// Bertanggung jawab untuk:
// 1. Caching data
// 2. Menggabungkan multiple data sources (API, local DB, cache)
// 3. Business rules sederhana terkait data
// 4. Memudahkan unit testing dengan mock

abstract class PostRepository {
  Future<List<Post>> getAllPosts();
  Future<Post> getPostById(int id);
  Future<Post> createPost(Post post);
  Future<Post> updatePost(int id, Post post);
  Future<bool> deletePost(int id);
  Future<List<Post>> searchPosts(String query);
  void clearCache();
}

class PostRepositoryImpl implements PostRepository {
  final PostDataProvider _dataProvider;
  
  // Simple in-memory cache
  List<Post>? _cachedPosts;
  DateTime? _lastCacheTime;
  static const Duration _cacheExpiry = Duration(minutes: 5);

  PostRepositoryImpl(this._dataProvider);

  @override
  Future<List<Post>> getAllPosts() async {
    // Check if cache is valid
    if (_cachedPosts != null && 
        _lastCacheTime != null && 
        DateTime.now().difference(_lastCacheTime!) < _cacheExpiry) {
      return _cachedPosts!;
    }

    // Fetch from data provider and cache
    final posts = await _dataProvider.getAllPosts();
    _cachedPosts = posts;
    _lastCacheTime = DateTime.now();
    return posts;
  }

  @override
  Future<Post> getPostById(int id) async {
    // Check cache first
    if (_cachedPosts != null) {
      try {
        return _cachedPosts!.firstWhere((post) => post.id == id);
      } catch (e) {
        // Post not found in cache, fetch from API
      }
    }

    return await _dataProvider.getPostById(id);
  }

  @override
  Future<Post> createPost(Post post) async {
    final createdPost = await _dataProvider.createPost(post);
    
    // Update cache
    if (_cachedPosts != null) {
      _cachedPosts!.insert(0, createdPost);
    }
    
    return createdPost;
  }

  @override
  Future<Post> updatePost(int id, Post post) async {
    final updatedPost = await _dataProvider.updatePost(id, post);
    
    // Update cache
    if (_cachedPosts != null) {
      final index = _cachedPosts!.indexWhere((p) => p.id == id);
      if (index != -1) {
        _cachedPosts![index] = updatedPost;
      }
    }
    
    return updatedPost;
  }

  @override
  Future<bool> deletePost(int id) async {
    final result = await _dataProvider.deletePost(id);
    
    // Update cache
    if (result && _cachedPosts != null) {
      _cachedPosts!.removeWhere((post) => post.id == id);
    }
    
    return result;
  }

  @override
  Future<List<Post>> searchPosts(String query) async {
    final allPosts = await getAllPosts();
    
    if (query.isEmpty) return allPosts;
    
    // Simple search implementation
    return allPosts.where((post) {
      return post.title.toLowerCase().contains(query.toLowerCase()) ||
             post.body.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  void clearCache() {
    _cachedPosts = null;
    _lastCacheTime = null;
  }
}

// Repository untuk testing dengan mock data
class MockPostRepository implements PostRepository {
  final PostDataProvider _dataProvider;
  
  MockPostRepository(this._dataProvider);

  @override
  Future<List<Post>> getAllPosts() => _dataProvider.getAllPosts();

  @override
  Future<Post> getPostById(int id) => _dataProvider.getPostById(id);

  @override
  Future<Post> createPost(Post post) => _dataProvider.createPost(post);

  @override
  Future<Post> updatePost(int id, Post post) => _dataProvider.updatePost(id, post);

  @override
  Future<bool> deletePost(int id) => _dataProvider.deletePost(id);

  @override
  Future<List<Post>> searchPosts(String query) async {
    final posts = await getAllPosts();
    if (query.isEmpty) return posts;
    
    return posts.where((post) {
      return post.title.toLowerCase().contains(query.toLowerCase()) ||
             post.body.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  void clearCache() {
    // Mock implementation - no cache to clear
  }
}
