import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';
import '../widgets/post_card.dart';
import '../widgets/loading_widget.dart' as widgets;
import 'create_post_screen.dart';

// Screen untuk menampilkan dan mengelola posts
// Demonstrasi GET, POST, PUT, DELETE operations
class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List<Post> posts = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  // Method untuk load posts dari API (GET)
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

  // Method untuk delete post (DELETE)
  Future<void> _deletePost(Post post) async {
    // Konfirmasi sebelum delete
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Post'),
        content: Text('Apakah Anda yakin ingin menghapus post "${post.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        // Show loading indicator
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Menghapus post...')),
          );
        }

        await ApiService.deletePost(post.id);
        
        // Remove from local list (simulated deletion)
        setState(() {
          posts.removeWhere((p) => p.id == post.id);
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Post berhasil dihapus'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  // Method untuk edit post (PUT)
  Future<void> _editPost(Post post) async {
    final result = await Navigator.push<Post>(
      context,
      MaterialPageRoute(
        builder: (context) => CreatePostScreen(postToEdit: post),
      ),
    );

    if (result != null) {
      // Update local list
      setState(() {
        final index = posts.indexWhere((p) => p.id == result.id);
        if (index != -1) {
          posts[index] = result;
        }
      });
    }
  }

  // Method untuk create new post
  Future<void> _createPost() async {
    final result = await Navigator.push<Post>(
      context,
      MaterialPageRoute(
        builder: (context) => const CreatePostScreen(),
      ),
    );

    if (result != null) {
      // Add to local list
      setState(() {
        posts.insert(0, result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts API Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: _loadPosts,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      
      body: Column(
        children: [
          // Info header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue.withOpacity(0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Demonstrasi CRUD Operations',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'GET: Ambil semua posts • POST: Buat post baru • PUT: Edit post • DELETE: Hapus post',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: _createPost,
        tooltip: 'Buat Post Baru',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const widgets.LoadingWidget(message: 'Memuat posts...');
    }

    if (errorMessage != null) {
      return widgets.ApiErrorWidget(
        message: errorMessage!,
        onRetry: _loadPosts,
      );
    }

    if (posts.isEmpty) {
      return const widgets.EmptyWidget(
        message: 'Tidak ada posts yang ditemukan',
        icon: Icons.article_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadPosts,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return PostCard(
            post: post,
            onTap: () => _showPostDetail(post),
            onEdit: () => _editPost(post),
            onDelete: () => _deletePost(post),
          );
        },
      ),
    );
  }

  void _showPostDetail(Post post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Post #${post.id}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'User ID: ${post.userId}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                post.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                post.body,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _editPost(post);
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }
}
