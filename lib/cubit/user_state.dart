import 'package:equatable/equatable.dart';
import '../models/user.dart';

// States untuk UserCubit
// Cubit menggunakan pendekatan yang lebih sederhana daripada BLoC
// State langsung di-emit tanpa menggunakan Events

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

// Initial state
class UserInitial extends UserState {
  const UserInitial();
}

// Loading state
class UserLoading extends UserState {
  const UserLoading();
}

// State saat users berhasil dimuat
class UserLoaded extends UserState {
  final List<User> users;
  final bool isSearching;
  final String searchQuery;

  const UserLoaded({
    required this.users,
    this.isSearching = false,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [users, isSearching, searchQuery];

  UserLoaded copyWith({
    List<User>? users,
    bool? isSearching,
    String? searchQuery,
  }) {
    return UserLoaded(
      users: users ?? this.users,
      isSearching: isSearching ?? this.isSearching,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

// State saat single user berhasil dimuat
class UserDetailLoaded extends UserState {
  final User user;

  const UserDetailLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

// Error state
class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}

// Search results state
class UserSearchResults extends UserState {
  final List<User> results;
  final String query;

  const UserSearchResults({
    required this.results,
    required this.query,
  });

  @override
  List<Object?> get props => [results, query];
}
