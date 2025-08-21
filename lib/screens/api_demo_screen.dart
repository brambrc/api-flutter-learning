import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';

// Screen untuk demo dan testing semua API operations
// Tempat untuk belajar dan eksperimen dengan API calls
class ApiDemoScreen extends StatefulWidget {
  const ApiDemoScreen({super.key});

  @override
  State<ApiDemoScreen> createState() => _ApiDemoScreenState();
}

class _ApiDemoScreenState extends State<ApiDemoScreen> {
  String outputText = 'Pilih operasi API untuk melihat hasilnya...';
  bool isLoading = false;

  void _updateOutput(String text) {
    setState(() {
      outputText = text;
    });
  }

  void _setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }

  // Demo GET all posts
  Future<void> _testGetAllPosts() async {
    _setLoading(true);
    _updateOutput('🔄 Mengambil semua posts...\n');

    try {
      final posts = await ApiService.getAllPosts();
      _updateOutput(
        '✅ Berhasil mengambil ${posts.length} posts\n\n'
        'Contoh post pertama:\n'
        'ID: ${posts.first.id}\n'
        'User ID: ${posts.first.userId}\n'
        'Title: ${posts.first.title}\n'
        'Body: ${posts.first.body.substring(0, 100)}...\n\n'
        'HTTP Method: GET\n'
        'Endpoint: /posts\n'
        'Response: List<Post>'
      );
    } catch (e) {
      _updateOutput('❌ Error: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Demo GET single post
  Future<void> _testGetSinglePost() async {
    _setLoading(true);
    _updateOutput('🔄 Mengambil post dengan ID 1...\n');

    try {
      final post = await ApiService.getPostById(1);
      _updateOutput(
        '✅ Berhasil mengambil post:\n\n'
        'ID: ${post.id}\n'
        'User ID: ${post.userId}\n'
        'Title: ${post.title}\n'
        'Body: ${post.body}\n\n'
        'HTTP Method: GET\n'
        'Endpoint: /posts/1\n'
        'Response: Post object'
      );
    } catch (e) {
      _updateOutput('❌ Error: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Demo POST new post
  Future<void> _testCreatePost() async {
    _setLoading(true);
    _updateOutput('🔄 Membuat post baru...\n');

    try {
      final newPost = Post(
        id: 0, // Will be assigned by server
        userId: 1,
        title: 'Post dari Flutter API Demo',
        body: 'Ini adalah contoh post yang dibuat menggunakan HTTP POST request dari Flutter aplikasi. '
              'Data ini dikirim dalam format JSON ke server.',
      );

      final createdPost = await ApiService.createPost(newPost);
      _updateOutput(
        '✅ Berhasil membuat post baru:\n\n'
        'ID yang diberikan server: ${createdPost.id}\n'
        'User ID: ${createdPost.userId}\n'
        'Title: ${createdPost.title}\n'
        'Body: ${createdPost.body}\n\n'
        'HTTP Method: POST\n'
        'Endpoint: /posts\n'
        'Request Body: JSON object\n'
        'Response: Created Post object'
      );
    } catch (e) {
      _updateOutput('❌ Error: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Demo PUT update post
  Future<void> _testUpdatePost() async {
    _setLoading(true);
    _updateOutput('🔄 Mengupdate post dengan ID 1...\n');

    try {
      final updatedPost = Post(
        id: 1,
        userId: 1,
        title: 'Post yang Sudah Diupdate dari Flutter',
        body: 'Ini adalah contoh post yang telah diupdate menggunakan HTTP PUT request. '
              'Method PUT digunakan untuk mengupdate data yang sudah ada di server.',
      );

      final result = await ApiService.updatePost(1, updatedPost);
      _updateOutput(
        '✅ Berhasil mengupdate post:\n\n'
        'ID: ${result.id}\n'
        'User ID: ${result.userId}\n'
        'Title: ${result.title}\n'
        'Body: ${result.body}\n\n'
        'HTTP Method: PUT\n'
        'Endpoint: /posts/1\n'
        'Request Body: JSON object\n'
        'Response: Updated Post object'
      );
    } catch (e) {
      _updateOutput('❌ Error: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Demo DELETE post
  Future<void> _testDeletePost() async {
    _setLoading(true);
    _updateOutput('🔄 Menghapus post dengan ID 1...\n');

    try {
      final success = await ApiService.deletePost(1);
      _updateOutput(
        success
            ? '✅ Berhasil menghapus post dengan ID 1\n\n'
              'HTTP Method: DELETE\n'
              'Endpoint: /posts/1\n'
              'Response: Success status'
            : '❌ Gagal menghapus post'
      );
    } catch (e) {
      _updateOutput('❌ Error: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Test API connection
  Future<void> _testConnection() async {
    _setLoading(true);
    _updateOutput('🔄 Mengecek koneksi ke API...\n');

    try {
      final isConnected = await ApiService.checkApiConnection();
      _updateOutput(
        isConnected
            ? '✅ Koneksi ke API berhasil!\n\n'
              'Base URL: https://jsonplaceholder.typicode.com\n'
              'Status: Online\n'
              'Response Time: < 1s'
            : '❌ Koneksi ke API gagal'
      );
    } catch (e) {
      _updateOutput('❌ Error: $e');
    } finally {
      _setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Demo & Testing'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      
      body: Column(
        children: [
          // Info header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.orange.withOpacity(0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'API Testing Console',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Test semua HTTP methods (GET, POST, PUT, DELETE) dan lihat response-nya',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          
          // Buttons grid
          Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.5,
              children: [
                _buildTestButton(
                  'Test Connection',
                  Icons.wifi,
                  Colors.blue,
                  _testConnection,
                ),
                _buildTestButton(
                  'GET All Posts',
                  Icons.list,
                  Colors.green,
                  _testGetAllPosts,
                ),
                _buildTestButton(
                  'GET Single Post',
                  Icons.article,
                  Colors.teal,
                  _testGetSinglePost,
                ),
                _buildTestButton(
                  'POST New Post',
                  Icons.add,
                  Colors.blue,
                  _testCreatePost,
                ),
                _buildTestButton(
                  'PUT Update Post',
                  Icons.edit,
                  Colors.orange,
                  _testUpdatePost,
                ),
                _buildTestButton(
                  'DELETE Post',
                  Icons.delete,
                  Colors.red,
                  _testDeletePost,
                ),
              ],
            ),
          ),
          
          // Output area
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.terminal, size: 16),
                      const SizedBox(width: 8),
                      const Text(
                        'Output Console',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      if (isLoading)
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                    ],
                  ),
                  const Divider(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        outputText,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: Icon(icon, size: 16),
      label: Text(
        label,
        style: const TextStyle(fontSize: 11),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
