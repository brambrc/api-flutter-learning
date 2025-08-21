import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../widgets/user_card.dart';
import '../widgets/loading_widget.dart' as widgets;

// Screen untuk menampilkan data users
// Demonstrasi GET request dengan data yang lebih kompleks
class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<User> users = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final loadedUsers = await ApiService.getAllUsers();
      setState(() {
        users = loadedUsers;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users API Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: _loadUsers,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      
      body: Column(
        children: [
          // Info header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.green.withOpacity(0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Demonstrasi GET Request - Data Kompleks',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Mengambil data user dengan nested objects (address, company) dari API',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const widgets.LoadingWidget(message: 'Memuat data users...');
    }

    if (errorMessage != null) {
      return widgets.ApiErrorWidget(
        message: errorMessage!,
        onRetry: _loadUsers,
      );
    }

    if (users.isEmpty) {
      return const widgets.EmptyWidget(
        message: 'Tidak ada users yang ditemukan',
        icon: Icons.people_outline,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadUsers,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return UserCard(
            user: user,
            onTap: () => _showUserDetail(user),
          );
        },
      ),
    );
  }

  void _showUserDetail(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(user.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailSection('Basic Info', [
                'ID: ${user.id}',
                'Username: ${user.username}',
                'Email: ${user.email}',
                'Phone: ${user.phone}',
                'Website: ${user.website}',
              ]),
              
              const SizedBox(height: 16),
              
              _buildDetailSection('Address', [
                'Street: ${user.address.street}',
                'Suite: ${user.address.suite}',
                'City: ${user.address.city}',
                'Zipcode: ${user.address.zipcode}',
                'Coordinates: ${user.address.geo.lat}, ${user.address.geo.lng}',
              ]),
              
              const SizedBox(height: 16),
              
              _buildDetailSection('Company', [
                'Name: ${user.company.name}',
                'Catch Phrase: ${user.company.catchPhrase}',
                'Business: ${user.company.bs}',
              ]),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 4),
          child: Text(
            item,
            style: const TextStyle(fontSize: 12),
          ),
        )),
      ],
    );
  }
}
