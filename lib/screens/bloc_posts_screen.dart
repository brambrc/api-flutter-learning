import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/post_bloc.dart';
import '../bloc/post_event.dart';
import '../bloc/post_state.dart';
import '../models/post.dart';
import '../widgets/post_card.dart';
import '../widgets/loading_widget.dart' as widgets;
import '../core/dependency_injection.dart';
import 'bloc_create_post_screen.dart';

// BLoC Posts Screen - Demonstrasi penggunaan BLoC pattern
// Menunjukkan:
// 1. BlocProvider untuk menyediakan BLoC
// 2. BlocBuilder untuk rebuild UI berdasarkan state
// 3. BlocListener untuk side effects (snackbar, navigation)
// 4. BlocConsumer untuk kombinasi builder + listener

class BlocPostsScreen extends StatelessWidget {
  const BlocPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Menggunakan dependency injection untuk membuat PostBloc
      create: (context) => createPostBloc()..add(const LoadPosts()),
      child: const _BlocPostsView(),
    );
  }
}

class _BlocPostsView extends StatefulWidget {
  const _BlocPostsView();

  @override
  State<_BlocPostsView> createState() => _BlocPostsViewState();
}

class _BlocPostsViewState extends State<_BlocPostsView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLoC Posts Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Refresh button
          BlocBuilder<PostBloc, PostState>(
            builder: (context, state) {
              return IconButton(
                onPressed: state is PostLoading 
                    ? null 
                    : () => context.read<PostBloc>().add(const RefreshPosts()),
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh Posts',
              );
            },
          ),
        ],
      ),
      
      body: Column(
        children: [
          // Info header dengan status BLoC
          _buildInfoHeader(),
          
          // Search bar
          _buildSearchBar(),
          
          // Posts content dengan BlocConsumer
          Expanded(
            child: BlocConsumer<PostBloc, PostState>(
              // Listener untuk side effects (snackbar, navigation)
              listener: (context, state) {
                if (state is PostError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                      action: SnackBarAction(
                        label: 'Retry',
                        textColor: Colors.white,
                        onPressed: () => context.read<PostBloc>().add(const RetryPostOperation()),
                      ),
                    ),
                  );
                }
                
                if (state is PostCreated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Post berhasil dibuat!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
                
                if (state is PostUpdated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Post berhasil diupdate!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
                
                if (state is PostDeleted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Post berhasil dihapus!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              
              // Builder untuk membangun UI berdasarkan state
              builder: (context, state) {
                return _buildContent(context, state);
              },
            ),
          ),
        ],
      ),
      
      floatingActionButton: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          return FloatingActionButton(
            onPressed: state is PostOperationInProgress 
                ? null 
                : () => _createPost(context),
            tooltip: 'Buat Post Baru',
            child: state is PostOperationInProgress && 
                   (state as PostOperationInProgress).operation == 'creating'
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.add),
          );
        },
      ),
    );
  }

  Widget _buildInfoHeader() {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        Color bgColor = Colors.blue.withOpacity(0.1);
        String title = 'BLoC State Management Demo';
        String subtitle = 'Current State: ${state.runtimeType}';
        
        if (state is PostError) {
          bgColor = Colors.red.withOpacity(0.1);
          title = 'Error State';
        } else if (state is PostLoading) {
          bgColor = Colors.orange.withOpacity(0.1);
          title = 'Loading State';
        } else if (state is PostLoaded) {
          bgColor = Colors.green.withOpacity(0.1);
          title = 'Data Loaded';
          subtitle = '${state.posts.length} posts loaded';
        }
        
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: bgColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Cari posts...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              context.read<PostBloc>().add(const ClearSearch());
            },
          ),
          border: const OutlineInputBorder(),
        ),
        onChanged: (query) {
          context.read<PostBloc>().add(SearchPosts(query));
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, PostState state) {
    if (state is PostInitial || state is PostLoading) {
      return const widgets.LoadingWidget(message: 'Memuat posts...');
    }

    if (state is PostError) {
      return widgets.ApiErrorWidget(
        message: state.message,
        onRetry: () => context.read<PostBloc>().add(const RetryPostOperation()),
      );
    }

    List<Post> posts = [];
    bool isSearching = false;
    
    if (state is PostLoaded) {
      posts = state.posts;
      isSearching = state.isSearching;
    } else if (state is PostSearchResults) {
      posts = state.results;
      isSearching = true;
    }

    if (posts.isEmpty) {
      return widgets.EmptyWidget(
        message: isSearching 
            ? 'Tidak ditemukan posts yang sesuai' 
            : 'Tidak ada posts yang ditemukan',
        icon: isSearching ? Icons.search_off : Icons.article_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<PostBloc>().add(const RefreshPosts());
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return PostCard(
            post: post,
            onTap: () => _showPostDetail(context, post),
            onEdit: () => _editPost(context, post),
            onDelete: () => _deletePost(context, post),
          );
        },
      ),
    );
  }

  Future<void> _createPost(BuildContext context) async {
    final result = await Navigator.push<Post>(
      context,
      MaterialPageRoute(
        builder: (context) => const BlocCreatePostScreen(),
      ),
    );

    if (result != null) {
      context.read<PostBloc>().add(CreatePost(result));
    }
  }

  Future<void> _editPost(BuildContext context, Post post) async {
    final result = await Navigator.push<Post>(
      context,
      MaterialPageRoute(
        builder: (context) => BlocCreatePostScreen(postToEdit: post),
      ),
    );

    if (result != null) {
      context.read<PostBloc>().add(UpdatePost(post.id, result));
    }
  }

  Future<void> _deletePost(BuildContext context, Post post) async {
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

    if (confirm == true && context.mounted) {
      context.read<PostBloc>().add(DeletePost(post.id));
    }
  }

  void _showPostDetail(BuildContext context, Post post) {
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
              _editPost(context, post);
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }
}
