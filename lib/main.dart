import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'core/dependency_injection.dart';

// Entry point aplikasi Flutter untuk belajar API dengan BLoC
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Setup dependency injection
  await setupDependencyInjection();
  
  runApp(const ApiLearningApp());
}

class ApiLearningApp extends StatelessWidget {
  const ApiLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Learning Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Theme yang modern dan menarik
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        
        // Custom theme untuk card dan button
        cardTheme: const CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      
      // Home screen sebagai entry point
      home: const HomeScreen(),
    );
  }
}