import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';

// Screen untuk membuat post baru atau edit post yang sudah ada
// Demonstrasi POST dan PUT operations
class CreatePostScreen extends StatefulWidget {
  final Post? postToEdit;

  const CreatePostScreen({
    super.key,
    this.postToEdit,
  });

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _userIdController = TextEditingController();
  
  bool isLoading = false;
  bool get isEditing => widget.postToEdit != null;

  @override
  void initState() {
    super.initState();
    
    // Jika sedang edit, isi form dengan data yang ada
    if (isEditing) {
      _titleController.text = widget.postToEdit!.title;
      _bodyController.text = widget.postToEdit!.body;
      _userIdController.text = widget.postToEdit!.userId.toString();
    } else {
      // Default user ID untuk post baru
      _userIdController.text = '1';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _userIdController.dispose();
    super.dispose();
  }

  Future<void> _savePost() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final post = Post(
        id: isEditing ? widget.postToEdit!.id : 0,
        userId: int.parse(_userIdController.text),
        title: _titleController.text,
        body: _bodyController.text,
      );

      Post savedPost;
      
      if (isEditing) {
        // PUT request untuk update
        savedPost = await ApiService.updatePost(post.id, post);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Post berhasil diupdate'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // POST request untuk create
        savedPost = await ApiService.createPost(post);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Post berhasil dibuat'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }

      if (mounted) {
        Navigator.pop(context, savedPost);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Post' : 'Buat Post Baru'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _savePost,
              child: Text(
                isEditing ? 'UPDATE' : 'SIMPAN',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info card
              Card(
                color: (isEditing ? Colors.orange : Colors.blue).withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        isEditing ? Icons.edit : Icons.add,
                        color: isEditing ? Colors.orange : Colors.blue,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isEditing ? 'Mode Edit (PUT Request)' : 'Mode Buat Baru (POST Request)',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              isEditing
                                  ? 'Mengupdate post yang sudah ada'
                                  : 'Membuat post baru dengan data yang dikirim ke server',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // User ID field
              TextFormField(
                controller: _userIdController,
                decoration: const InputDecoration(
                  labelText: 'User ID',
                  helperText: 'ID user yang membuat post (1-10)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'User ID harus diisi';
                  }
                  final userId = int.tryParse(value);
                  if (userId == null || userId < 1 || userId > 10) {
                    return 'User ID harus berupa angka 1-10';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Title field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul Post',
                  helperText: 'Judul yang menarik untuk post Anda',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul harus diisi';
                  }
                  if (value.length < 3) {
                    return 'Judul minimal 3 karakter';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Body field
              TextFormField(
                controller: _bodyController,
                decoration: const InputDecoration(
                  labelText: 'Isi Post',
                  helperText: 'Konten atau isi dari post Anda',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.article),
                  alignLabelWithHint: true,
                ),
                maxLines: 8,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Isi post harus diisi';
                  }
                  if (value.length < 10) {
                    return 'Isi post minimal 10 karakter';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 32),
              
              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : _savePost,
                  icon: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(isEditing ? Icons.update : Icons.save),
                  label: Text(
                    isLoading
                        ? (isEditing ? 'Mengupdate...' : 'Menyimpan...')
                        : (isEditing ? 'Update Post' : 'Simpan Post'),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: isEditing ? Colors.orange : Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Info text
              Card(
                color: Colors.grey.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ℹ️ Informasi:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isEditing
                            ? 'Data akan dikirim ke server menggunakan HTTP PUT request untuk mengupdate post yang sudah ada.'
                            : 'Data akan dikirim ke server menggunakan HTTP POST request untuk membuat post baru.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
