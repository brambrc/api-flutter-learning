import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/user.dart';

// Data Provider untuk Users
// Menangani akses data user dari API

abstract class UserDataProvider {
  Future<List<User>> getAllUsers();
  Future<User> getUserById(int id);
}

class UserApiProvider implements UserDataProvider {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const Duration timeoutDuration = Duration(seconds: 10);

  @override
  Future<List<User>> getAllUsers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }

  @override
  Future<User> getUserById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$id'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return User.fromJson(jsonData);
      } else {
        throw Exception('Failed to load user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }
}

// Mock Data Provider untuk testing
class MockUserDataProvider implements UserDataProvider {
  final List<User> _users = [
    User(
      id: 1,
      name: 'John Doe',
      username: 'johndoe',
      email: 'john@example.com',
      phone: '123-456-7890',
      website: 'john.example.com',
      address: Address(
        street: 'Main St',
        suite: 'Apt 1',
        city: 'Jakarta',
        zipcode: '12345',
        geo: Geo(lat: '-6.2088', lng: '106.8456'),
      ),
      company: Company(
        name: 'Tech Corp',
        catchPhrase: 'Innovation First',
        bs: 'technology solutions',
      ),
    ),
  ];

  @override
  Future<List<User>> getAllUsers() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return List.from(_users);
  }

  @override
  Future<User> getUserById(int id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final user = _users.firstWhere(
      (u) => u.id == id,
      orElse: () => throw Exception('User not found'),
    );
    return user;
  }
}
