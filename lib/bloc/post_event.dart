import 'package:equatable/equatable.dart';
import '../models/post.dart';

// Events untuk PostBloc
// Event adalah aksi yang dikirim dari UI ke BLoC untuk memicu perubahan state
// Event menggunakan Equatable untuk memudahkan comparison dan testing

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object?> get props => [];
}

// Event untuk mengambil semua posts
class LoadPosts extends PostEvent {
  const LoadPosts();
}

// Event untuk refresh data posts
class RefreshPosts extends PostEvent {
  const RefreshPosts();
}

// Event untuk mengambil post berdasarkan ID
class LoadPostById extends PostEvent {
  final int postId;

  const LoadPostById(this.postId);

  @override
  List<Object?> get props => [postId];
}

// Event untuk membuat post baru
class CreatePost extends PostEvent {
  final Post post;

  const CreatePost(this.post);

  @override
  List<Object?> get props => [post];
}

// Event untuk mengupdate post
class UpdatePost extends PostEvent {
  final int postId;
  final Post post;

  const UpdatePost(this.postId, this.post);

  @override
  List<Object?> get props => [postId, post];
}

// Event untuk menghapus post
class DeletePost extends PostEvent {
  final int postId;

  const DeletePost(this.postId);

  @override
  List<Object?> get props => [postId];
}

// Event untuk mencari posts
class SearchPosts extends PostEvent {
  final String query;

  const SearchPosts(this.query);

  @override
  List<Object?> get props => [query];
}

// Event untuk clear search
class ClearSearch extends PostEvent {
  const ClearSearch();
}

// Event untuk retry operation saat error
class RetryPostOperation extends PostEvent {
  const RetryPostOperation();
}
