import 'package:get_it/get_it.dart';

// Data Providers
import '../data/providers/post_data_provider.dart';
import '../data/providers/user_data_provider.dart';

// Repositories
import '../data/repositories/post_repository.dart';
import '../data/repositories/user_repository.dart';

// BLoC & Cubit
import '../bloc/post_bloc.dart';
import '../cubit/user_cubit.dart';

// Dependency Injection menggunakan GetIt
// Service Locator pattern untuk mengelola dependencies
// Memudahkan testing, mengurangi coupling, dan meningkatkan skalabilitas

final GetIt getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // ===== DATA PROVIDERS =====
  // Registrasi Data Providers (sumber data)
  getIt.registerLazySingleton<PostDataProvider>(
    () => PostApiProvider(),
  );
  
  getIt.registerLazySingleton<UserDataProvider>(
    () => UserApiProvider(),
  );

  // ===== REPOSITORIES =====
  // Registrasi Repositories (abstraksi data)
  getIt.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(getIt<PostDataProvider>()),
  );
  
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(getIt<UserDataProvider>()),
  );

  // ===== BUSINESS LOGIC =====
  // Registrasi BLoC dan Cubit
  // Factory = new instance setiap kali dibutuhkan
  // LazySingleton = shared instance, dibuat saat pertama kali dibutuhkan
  
  getIt.registerFactory<PostBloc>(
    () => PostBloc(getIt<PostRepository>()),
  );
  
  getIt.registerFactory<UserCubit>(
    () => UserCubit(getIt<UserRepository>()),
  );
}

// ===== SETUP UNTUK TESTING =====
// Configuration untuk testing dengan mock objects
Future<void> setupTestDependencyInjection() async {
  // Reset semua dependencies
  await getIt.reset();
  
  // Register mock providers
  getIt.registerLazySingleton<PostDataProvider>(
    () => MockPostDataProvider(),
  );
  
  getIt.registerLazySingleton<UserDataProvider>(
    () => MockUserDataProvider(),
  );

  // Register repositories dengan mock providers
  getIt.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(getIt<PostDataProvider>()),
  );
  
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(getIt<UserDataProvider>()),
  );

  // Register BLoC dan Cubit
  getIt.registerFactory<PostBloc>(
    () => PostBloc(getIt<PostRepository>()),
  );
  
  getIt.registerFactory<UserCubit>(
    () => UserCubit(getIt<UserRepository>()),
  );
}

// ===== DEVELOPMENT CONFIGURATION =====
// Configuration untuk development dengan debugging enabled
Future<void> setupDevelopmentDependencies() async {
  await setupDependencyInjection();
  
  // Tambahan konfigurasi untuk development
  // Misalnya: logging, debugging tools, etc.
}

// ===== PRODUCTION CONFIGURATION =====
// Configuration untuk production
Future<void> setupProductionDependencies() async {
  await setupDependencyInjection();
  
  // Konfigurasi khusus production
  // Misalnya: analytics, crash reporting, etc.
}

// ===== HELPER FUNCTIONS =====

// Function untuk mendapatkan PostBloc instance
PostBloc createPostBloc() => getIt<PostBloc>();

// Function untuk mendapatkan UserCubit instance
UserCubit createUserCubit() => getIt<UserCubit>();

// Function untuk reset dependencies (berguna untuk testing)
Future<void> resetDependencies() async {
  await getIt.reset();
}

// Function untuk check apakah dependency sudah registered
bool isDependencyRegistered<T extends Object>() {
  return getIt.isRegistered<T>();
}

// Function untuk unregister specific dependency
void unregisterDependency<T extends Object>() {
  if (getIt.isRegistered<T>()) {
    getIt.unregister<T>();
  }
}

// ===== CONFIGURATION ENUMS =====
enum EnvironmentType {
  development,
  testing,
  production,
}

// Function untuk setup berdasarkan environment
Future<void> setupDependenciesForEnvironment(EnvironmentType environment) async {
  switch (environment) {
    case EnvironmentType.development:
      await setupDevelopmentDependencies();
      break;
    case EnvironmentType.testing:
      await setupTestDependencyInjection();
      break;
    case EnvironmentType.production:
      await setupProductionDependencies();
      break;
  }
}
