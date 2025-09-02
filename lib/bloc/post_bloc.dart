import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/post_repository.dart';
import '../models/post.dart';
import 'post_event.dart';
import 'post_state.dart';

// PostBloc - Business Logic Component untuk mengelola Posts
// BLoC menangani:
// 1. Event yang datang dari UI
// 2. Business logic dan data transformation
// 3. Emit state baru ke UI
// 4. Error handling
// 5. Loading states

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository _postRepository;
  
  // Menyimpan data posts untuk operasi lokal
  List<Post> _allPosts = [];

  PostBloc(this._postRepository) : super(const PostInitial()) {
    // Registrasi event handlers
    on<LoadPosts>(_onLoadPosts);
    on<RefreshPosts>(_onRefreshPosts);
    on<LoadPostById>(_onLoadPostById);
    on<CreatePost>(_onCreatePost);
    on<UpdatePost>(_onUpdatePost);
    on<DeletePost>(_onDeletePost);
    on<SearchPosts>(_onSearchPosts);
    on<ClearSearch>(_onClearSearch);
    on<RetryPostOperation>(_onRetryPostOperation);
  }

  // Handler untuk memuat semua posts
  Future<void> _onLoadPosts(LoadPosts event, Emitter<PostState> emit) async {
    emit(const PostLoading());
    
    try {
      final posts = await _postRepository.getAllPosts();
      _allPosts = posts;
      emit(PostLoaded(posts: posts));
    } catch (error) {
      emit(PostError('Gagal memuat posts: ${error.toString()}'));
    }
  }

  // Handler untuk refresh posts
  Future<void> _onRefreshPosts(RefreshPosts event, Emitter<PostState> emit) async {
    // Clear cache sebelum refresh
    _postRepository.clearCache();
    
    try {
      final posts = await _postRepository.getAllPosts();
      _allPosts = posts;
      emit(PostLoaded(posts: posts));
    } catch (error) {
      emit(PostError('Gagal refresh posts: ${error.toString()}'));
    }
  }

  // Handler untuk memuat post berdasarkan ID
  Future<void> _onLoadPostById(LoadPostById event, Emitter<PostState> emit) async {
    emit(const PostLoading());
    
    try {
      final post = await _postRepository.getPostById(event.postId);
      emit(PostDetailLoaded(post));
    } catch (error) {
      emit(PostError('Gagal memuat post: ${error.toString()}'));
    }
  }

  // Handler untuk membuat post baru
  Future<void> _onCreatePost(CreatePost event, Emitter<PostState> emit) async {
    emit(const PostOperationInProgress('creating'));
    
    try {
      final createdPost = await _postRepository.createPost(event.post);
      
      // Update local posts list
      _allPosts.insert(0, createdPost);
      
      emit(PostCreated(createdPost));
      // Emit updated list
      emit(PostLoaded(posts: List.from(_allPosts)));
    } catch (error) {
      emit(PostError('Gagal membuat post: ${error.toString()}'));
    }
  }

  // Handler untuk update post
  Future<void> _onUpdatePost(UpdatePost event, Emitter<PostState> emit) async {
    emit(PostOperationInProgress('updating', postId: event.postId));
    
    try {
      final updatedPost = await _postRepository.updatePost(event.postId, event.post);
      
      // Update local posts list
      final index = _allPosts.indexWhere((post) => post.id == event.postId);
      if (index != -1) {
        _allPosts[index] = updatedPost;
      }
      
      emit(PostUpdated(updatedPost));
      // Emit updated list
      emit(PostLoaded(posts: List.from(_allPosts)));
    } catch (error) {
      emit(PostError('Gagal mengupdate post: ${error.toString()}'));
    }
  }

  // Handler untuk delete post
  Future<void> _onDeletePost(DeletePost event, Emitter<PostState> emit) async {
    emit(PostOperationInProgress('deleting', postId: event.postId));
    
    try {
      final success = await _postRepository.deletePost(event.postId);
      
      if (success) {
        // Remove from local posts list
        _allPosts.removeWhere((post) => post.id == event.postId);
        
        emit(PostDeleted(event.postId));
        // Emit updated list
        emit(PostLoaded(posts: List.from(_allPosts)));
      } else {
        emit(const PostError('Gagal menghapus post'));
      }
    } catch (error) {
      emit(PostError('Gagal menghapus post: ${error.toString()}'));
    }
  }

  // Handler untuk search posts
  Future<void> _onSearchPosts(SearchPosts event, Emitter<PostState> emit) async {
    if (event.query.isEmpty) {
      emit(PostLoaded(posts: _allPosts));
      return;
    }

    emit(PostSearchResults(
      results: [],
      query: event.query,
      isLoading: true,
    ));
    
    try {
      final results = await _postRepository.searchPosts(event.query);
      emit(PostSearchResults(
        results: results,
        query: event.query,
        isLoading: false,
      ));
    } catch (error) {
      emit(PostError('Gagal mencari posts: ${error.toString()}'));
    }
  }

  // Handler untuk clear search
  Future<void> _onClearSearch(ClearSearch event, Emitter<PostState> emit) async {
    emit(PostLoaded(posts: _allPosts));
  }

  // Handler untuk retry operation
  Future<void> _onRetryPostOperation(RetryPostOperation event, Emitter<PostState> emit) async {
    // Retry with load posts
    add(const LoadPosts());
  }

  // Helper method untuk mendapatkan current posts
  List<Post> get currentPosts => _allPosts;

  // Helper method untuk check apakah sedang loading
  bool get isLoading => state is PostLoading || state is PostOperationInProgress;

  // Helper method untuk mendapatkan error message
  String? get errorMessage => state is PostError ? (state as PostError).message : null;
}
