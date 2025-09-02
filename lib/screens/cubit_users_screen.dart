import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/user_cubit.dart';
import '../cubit/user_state.dart';
import '../models/user.dart';
import '../widgets/user_card.dart';
import '../widgets/loading_widget.dart' as widgets;
import '../core/dependency_injection.dart';

// Cubit Users Screen - Demonstrasi Cubit pattern
// Menunjukkan perbedaan Cubit vs BLoC:
// 1. Cubit tidak menggunakan Events, method langsung
// 2. Lebih sederhana untuk use case yang straightforward
// 3. State management yang lebih simple

class CubitUsersScreen extends StatelessWidget {
  const CubitUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => createUserCubit()..loadUsers(),
      child: const _CubitUsersView(),
    );
  }
}

class _CubitUsersView extends StatefulWidget {
  const _CubitUsersView();

  @override
  State<_CubitUsersView> createState() => _CubitUsersViewState();
}

class _CubitUsersViewState extends State<_CubitUsersView> {
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
        title: const Text('Cubit Users Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              return IconButton(
                onPressed: state is UserLoading 
                    ? null 
                    : () => context.read<UserCubit>().refreshUsers(),
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh Users',
              );
            },
          ),
        ],
      ),
      
      body: Column(
        children: [
          // Info header dengan Cubit state
          _buildInfoHeader(),
          
          // Search bar
          _buildSearchBar(),
          
          // Users content
          Expanded(
            child: BlocConsumer<UserCubit, UserState>(
              listener: (context, state) {
                if (state is UserError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                      action: SnackBarAction(
                        label: 'Retry',
                        textColor: Colors.white,
                        onPressed: () => context.read<UserCubit>().retry(),
                      ),
                    ),
                  );
                }
              },
              builder: (context, state) {
                return _buildContent(context, state);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoHeader() {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        Color bgColor = Colors.green.withOpacity(0.1);
        String title = 'Cubit State Management Demo';
        String subtitle = 'Current State: ${state.runtimeType}';
        
        if (state is UserError) {
          bgColor = Colors.red.withOpacity(0.1);
          title = 'Error State';
        } else if (state is UserLoading) {
          bgColor = Colors.orange.withOpacity(0.1);
          title = 'Loading State';
        } else if (state is UserLoaded) {
          bgColor = Colors.green.withOpacity(0.1);
          title = 'Data Loaded';
          subtitle = '${state.users.length} users loaded';
        } else if (state is UserSearchResults) {
          bgColor = Colors.blue.withOpacity(0.1);
          title = 'Search Results';
          subtitle = '${state.results.length} users found for "${state.query}"';
        }
        
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: bgColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.people,
                    color: Colors.green[700],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Cubit: Method langsung tanpa Events • State management sederhana',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
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
          hintText: 'Cari users berdasarkan nama, username, email...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              context.read<UserCubit>().clearSearch();
            },
          ),
          border: const OutlineInputBorder(),
        ),
        onChanged: (query) {
          // Debounce search untuk performance
          Future.delayed(const Duration(milliseconds: 500), () {
            if (_searchController.text == query) {
              context.read<UserCubit>().searchUsers(query);
            }
          });
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, UserState state) {
    if (state is UserInitial || state is UserLoading) {
      return const widgets.LoadingWidget(message: 'Memuat data users...');
    }

    if (state is UserError) {
      return widgets.ApiErrorWidget(
        message: state.message,
        onRetry: () => context.read<UserCubit>().retry(),
      );
    }

    List<User> users = [];
    bool isSearching = false;
    
    if (state is UserLoaded) {
      users = state.users;
      isSearching = state.isSearching;
    } else if (state is UserSearchResults) {
      users = state.results;
      isSearching = true;
    }

    if (users.isEmpty) {
      return widgets.EmptyWidget(
        message: isSearching 
            ? 'Tidak ditemukan users yang sesuai dengan pencarian' 
            : 'Tidak ada users yang ditemukan',
        icon: isSearching ? Icons.search_off : Icons.people_outline,
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<UserCubit>().refreshUsers(),
      child: Column(
        children: [
          // Results info
          if (isSearching)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.blue.withOpacity(0.1),
              child: Text(
                'Menampilkan ${users.length} hasil pencarian',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                ),
              ),
            ),
          
          // Users list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return UserCard(
                  user: user,
                  onTap: () => _showUserDetail(context, user),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showUserDetail(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.green.withOpacity(0.1),
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                user.name,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
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
              
              const SizedBox(height: 16),
              
              // Cubit info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🧊 Cubit Pattern:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Data dimuat menggunakan Cubit dengan method loadUsers() langsung tanpa Events',
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
