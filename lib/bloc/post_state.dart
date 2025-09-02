import 'package:equatable/equatable.dart';
import '../models/post.dart';

// States untuk PostBloc
// State merepresentasikan kondisi aplikasi pada waktu tertentu
// State menggunakan Equatable untuk optimasi rebuild widget

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object?> get props => [];
}

// Initial state saat aplikasi pertama kali dimuat
class PostInitial extends PostState {
  const PostInitial();
}

// Loading state - menampilkan loading indicator
class PostLoading extends PostState {
  const PostLoading();
}

// State saat data posts berhasil dimuat
class PostLoaded extends PostState {
  final List<Post> posts;
  final bool isSearching;
  final String searchQuery;

  const PostLoaded({
    required this.posts,
    this.isSearching = false,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [posts, isSearching, searchQuery];

  // Method untuk membuat copy state dengan perubahan tertentu
  PostLoaded copyWith({
    List<Post>? posts,
    bool? isSearching,
    String? searchQuery,
  }) {
    return PostLoaded(
      posts: posts ?? this.posts,
      isSearching: isSearching ?? this.isSearching,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

// State saat single post berhasil dimuat
class PostDetailLoaded extends PostState {
  final Post post;

  const PostDetailLoaded(this.post);

  @override
  List<Object?> get props => [post];
}

// State saat post berhasil dibuat
class PostCreated extends PostState {
  final Post post;

  const PostCreated(this.post);

  @override
  List<Object?> get props => [post];
}

// State saat post berhasil diupdate
class PostUpdated extends PostState {
  final Post post;

  const PostUpdated(this.post);

  @override
  List<Object?> get props => [post];
}

// State saat post berhasil dihapus
class PostDeleted extends PostState {
  final int postId;

  const PostDeleted(this.postId);

  @override
  List<Object?> get props => [postId];
}

// Error state dengan pesan error
class PostError extends PostState {
  final String message;
  final String? errorCode;

  const PostError(this.message, {this.errorCode});

  @override
  List<Object?> get props => [message, errorCode];
}

// State untuk operasi yang sedang berlangsung (create, update, delete)
class PostOperationInProgress extends PostState {
  final String operation; // 'creating', 'updating', 'deleting'
  final int? postId;

  const PostOperationInProgress(this.operation, {this.postId});

  @override
  List<Object?> get props => [operation, postId];
}

// State untuk search results
class PostSearchResults extends PostState {
  final List<Post> results;
  final String query;
  final bool isLoading;

  const PostSearchResults({
    required this.results,
    required this.query,
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [results, query, isLoading];

  PostSearchResults copyWith({
    List<Post>? results,
    String? query,
    bool? isLoading,
  }) {
    return PostSearchResults(
      results: results ?? this.results,
      query: query ?? this.query,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
