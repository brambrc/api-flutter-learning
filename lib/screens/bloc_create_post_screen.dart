import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/post_bloc.dart';
import '../bloc/post_event.dart';
import '../bloc/post_state.dart';
import '../models/post.dart';
import '../core/dependency_injection.dart';

// BLoC Create Post Screen
// Demonstrasi form handling dengan BLoC pattern

class BlocCreatePostScreen extends StatelessWidget {
  final Post? postToEdit;

  const BlocCreatePostScreen({
    super.key,
    this.postToEdit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => createPostBloc(),
      child: _BlocCreatePostView(postToEdit: postToEdit),
    );
  }
}

class _BlocCreatePostView extends StatefulWidget {
  final Post? postToEdit;

  const _BlocCreatePostView({this.postToEdit});

  @override
  State<_BlocCreatePostView> createState() => _BlocCreatePostViewState();
}

class _BlocCreatePostViewState extends State<_BlocCreatePostView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _userIdController = TextEditingController();
  
  bool get isEditing => widget.postToEdit != null;

  @override
  void initState() {
    super.initState();
    
    if (isEditing) {
      _titleController.text = widget.postToEdit!.title;
      _bodyController.text = widget.postToEdit!.body;
      _userIdController.text = widget.postToEdit!.userId.toString();
    } else {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Post (BLoC)' : 'Buat Post Baru (BLoC)'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          BlocConsumer<PostBloc, PostState>(
            listener: (context, state) {
              if (state is PostCreated || state is PostUpdated) {
                Navigator.pop(context, 
                  state is PostCreated 
                    ? (state as PostCreated).post 
                    : (state as PostUpdated).post
                );
              }
              
              if (state is PostError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is PostOperationInProgress;
              
              return isLoading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    )
                  : TextButton(
                      onPressed: _savePost,
                      child: Text(
                        isEditing ? 'UPDATE' : 'SIMPAN',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
            },
          ),
        ],
      ),
      
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info card dengan state information
                  _buildInfoCard(state),
                  
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
                    enabled: !(state is PostOperationInProgress),
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
                    enabled: !(state is PostOperationInProgress),
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
                    enabled: !(state is PostOperationInProgress),
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
                      onPressed: state is PostOperationInProgress ? null : _savePost,
                      icon: state is PostOperationInProgress
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(isEditing ? Icons.update : Icons.save),
                      label: Text(
                        state is PostOperationInProgress
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
                  
                  // BLoC info card
                  _buildBlocInfoCard(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(PostState state) {
    Color bgColor = (isEditing ? Colors.orange : Colors.blue).withOpacity(0.1);
    String stateInfo = 'Current State: ${state.runtimeType}';
    
    if (state is PostOperationInProgress) {
      bgColor = Colors.orange.withOpacity(0.2);
      stateInfo = 'Processing: ${state.operation}';
    } else if (state is PostError) {
      bgColor = Colors.red.withOpacity(0.1);
      stateInfo = 'Error occurred';
    }
    
    return Card(
      color: bgColor,
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
                    stateInfo,
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
    );
  }

  Widget _buildBlocInfoCard() {
    return Card(
      color: Colors.grey.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🔄 BLoC Pattern Info:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '• Event dikirim ke BLoC: ${isEditing ? 'UpdatePost' : 'CreatePost'}\n'
              '• BLoC mengelola business logic dan API call\n'
              '• State di-emit kembali ke UI untuk update tampilan\n'
              '• BlocListener menangani side effects (navigation, snackbar)',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _savePost() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final post = Post(
      id: isEditing ? widget.postToEdit!.id : 0,
      userId: int.parse(_userIdController.text),
      title: _titleController.text,
      body: _bodyController.text,
    );

    if (isEditing) {
      context.read<PostBloc>().add(UpdatePost(post.id, post));
    } else {
      context.read<PostBloc>().add(CreatePost(post));
    }
  }
}
