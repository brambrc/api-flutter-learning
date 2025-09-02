import '../providers/user_data_provider.dart';
import '../../models/user.dart';

// Repository untuk User data
// Mengelola cache dan business logic sederhana untuk user data

abstract class UserRepository {
  Future<List<User>> getAllUsers();
  Future<User> getUserById(int id);
  Future<List<User>> searchUsers(String query);
  void clearCache();
}

class UserRepositoryImpl implements UserRepository {
  final UserDataProvider _dataProvider;
  
  // Cache untuk user data
  List<User>? _cachedUsers;
  DateTime? _lastCacheTime;
  static const Duration _cacheExpiry = Duration(minutes: 10);

  UserRepositoryImpl(this._dataProvider);

  @override
  Future<List<User>> getAllUsers() async {
    // Check cache validity
    if (_cachedUsers != null && 
        _lastCacheTime != null && 
        DateTime.now().difference(_lastCacheTime!) < _cacheExpiry) {
      return _cachedUsers!;
    }

    // Fetch and cache
    final users = await _dataProvider.getAllUsers();
    _cachedUsers = users;
    _lastCacheTime = DateTime.now();
    return users;
  }

  @override
  Future<User> getUserById(int id) async {
    // Check cache first
    if (_cachedUsers != null) {
      try {
        return _cachedUsers!.firstWhere((user) => user.id == id);
      } catch (e) {
        // User not found in cache
      }
    }

    return await _dataProvider.getUserById(id);
  }

  @override
  Future<List<User>> searchUsers(String query) async {
    final allUsers = await getAllUsers();
    
    if (query.isEmpty) return allUsers;
    
    // Search by name, username, or email
    return allUsers.where((user) {
      return user.name.toLowerCase().contains(query.toLowerCase()) ||
             user.username.toLowerCase().contains(query.toLowerCase()) ||
             user.email.toLowerCase().contains(query.toLowerCase()) ||
             user.company.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  void clearCache() {
    _cachedUsers = null;
    _lastCacheTime = null;
  }
}
