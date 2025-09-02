import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/user_repository.dart';
import '../models/user.dart';
import 'user_state.dart';

// UserCubit - Pendekatan sederhana untuk state management
// Cubit tidak menggunakan Events, melainkan method langsung
// Cocok untuk use case yang sederhana dan straightforward

class UserCubit extends Cubit<UserState> {
  final UserRepository _userRepository;
  
  // Cache untuk users
  List<User> _allUsers = [];

  UserCubit(this._userRepository) : super(const UserInitial());

  // Method untuk memuat semua users
  Future<void> loadUsers() async {
    emit(const UserLoading());
    
    try {
      final users = await _userRepository.getAllUsers();
      _allUsers = users;
      emit(UserLoaded(users: users));
    } catch (error) {
      emit(UserError('Gagal memuat users: ${error.toString()}'));
    }
  }

  // Method untuk refresh users
  Future<void> refreshUsers() async {
    _userRepository.clearCache();
    await loadUsers();
  }

  // Method untuk memuat user berdasarkan ID
  Future<void> loadUserById(int id) async {
    emit(const UserLoading());
    
    try {
      final user = await _userRepository.getUserById(id);
      emit(UserDetailLoaded(user));
    } catch (error) {
      emit(UserError('Gagal memuat user: ${error.toString()}'));
    }
  }

  // Method untuk search users
  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      emit(UserLoaded(users: _allUsers));
      return;
    }

    try {
      final results = await _userRepository.searchUsers(query);
      emit(UserSearchResults(results: results, query: query));
    } catch (error) {
      emit(UserError('Gagal mencari users: ${error.toString()}'));
    }
  }

  // Method untuk clear search
  void clearSearch() {
    emit(UserLoaded(users: _allUsers));
  }

  // Method untuk retry operation
  Future<void> retry() async {
    await loadUsers();
  }

  // Getter untuk current users
  List<User> get currentUsers => _allUsers;

  // Helper untuk check loading state
  bool get isLoading => state is UserLoading;

  // Helper untuk mendapatkan error message
  String? get errorMessage => state is UserError ? (state as UserError).message : null;

  // Helper untuk check apakah sedang searching
  bool get isSearching => state is UserSearchResults;
}
