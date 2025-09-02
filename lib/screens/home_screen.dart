import 'package:flutter/material.dart';
import 'posts_screen.dart';
import 'users_screen.dart';
import 'api_demo_screen.dart';
import 'bloc_posts_screen.dart';
import 'cubit_users_screen.dart';

// Screen utama dengan navigation ke berbagai contoh API
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Learning Flutter'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Card(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.api,
                            size: 32,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Belajar API dengan Flutter',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                                    Text(
                'Aplikasi ini mendemonstrasikan penggunaan HTTP package dan BLoC architecture untuk berkomunikasi dengan API menggunakan JSONPlaceholder.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              const Text(
                'Pilih contoh yang ingin dipelajari:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Menu items
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.0,
                  children: [
                    _buildMenuCard(
                      context,
                      title: 'Posts API',
                      subtitle: 'setState pattern',
                      icon: Icons.article,
                      color: Colors.blue,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PostsScreen(),
                        ),
                      ),
                    ),
                    
                    _buildMenuCard(
                      context,
                      title: 'Posts BLoC',
                      subtitle: 'Event + State pattern',
                      icon: Icons.architecture,
                      color: Colors.indigo,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BlocPostsScreen(),
                        ),
                      ),
                    ),
                    
                    _buildMenuCard(
                      context,
                      title: 'Users API',
                      subtitle: 'setState pattern',
                      icon: Icons.people,
                      color: Colors.green,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UsersScreen(),
                        ),
                      ),
                    ),
                    
                    _buildMenuCard(
                      context,
                      title: 'Users Cubit',
                      subtitle: 'Method pattern',
                      icon: Icons.people_alt,
                      color: Colors.teal,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CubitUsersScreen(),
                        ),
                      ),
                    ),
                    
                    _buildMenuCard(
                      context,
                      title: 'API Demo',
                      subtitle: 'Test semua operasi',
                      icon: Icons.code,
                      color: Colors.orange,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ApiDemoScreen(),
                        ),
                      ),
                    ),
                    
                    _buildMenuCard(
                      context,
                      title: 'Architecture Info',
                      subtitle: 'BLoC vs Cubit patterns',
                      icon: Icons.info,
                      color: Colors.purple,
                      onTap: () => _showArchitectureInfo(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              
              const SizedBox(height: 12),
              
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 4),
              
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showArchitectureInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Architecture Patterns'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Package yang digunakan:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• http: ^1.2.0 - Untuk HTTP requests'),
              Text('• flutter_bloc: ^8.1.3 - BLoC state management'),
              Text('• get_it: ^7.6.4 - Dependency injection'),
              Text('• equatable: ^2.0.5 - State comparison'),
              SizedBox(height: 16),
              Text(
                'Architecture Patterns:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('🔄 BLoC Pattern:'),
              Text('  • Events + States'),
              Text('  • Complex business logic'),
              Text('  • Reactive programming'),
              SizedBox(height: 8),
              Text('🧊 Cubit Pattern:'),
              Text('  • Method calls'),
              Text('  • Simple state changes'),
              Text('  • Less boilerplate'),
              SizedBox(height: 16),
              Text(
                'Layer Architecture:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Presentation Layer (UI)'),
              Text('• Business Logic Layer (BLoC/Cubit)'),
              Text('• Data Layer (Repository + Provider)'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
