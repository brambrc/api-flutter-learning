import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:api_learning_flutter/cubit/user_cubit.dart';
import 'package:api_learning_flutter/cubit/user_state.dart';
import 'package:api_learning_flutter/data/repositories/user_repository.dart';
import 'package:api_learning_flutter/models/user.dart';

// Mock class untuk UserRepository
class MockUserRepository extends Mock implements UserRepository {}

void main() {
  group('UserCubit', () {
    late UserCubit userCubit;
    late MockUserRepository mockUserRepository;

    // Sample data untuk testing
    final sampleUsers = [
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
      User(
        id: 2,
        name: 'Jane Smith',
        username: 'janesmith',
        email: 'jane@example.com',
        phone: '987-654-3210',
        website: 'jane.example.com',
        address: Address(
          street: 'Second St',
          suite: 'Apt 2',
          city: 'Bandung',
          zipcode: '54321',
          geo: Geo(lat: '-6.9175', lng: '107.6191'),
        ),
        company: Company(
          name: 'Design Co',
          catchPhrase: 'Creative Solutions',
          bs: 'design services',
        ),
      ),
    ];

    final sampleUser = sampleUsers.first;

    setUp(() {
      mockUserRepository = MockUserRepository();
      userCubit = UserCubit(mockUserRepository);
    });

    tearDown(() {
      userCubit.close();
    });

    test('initial state is UserInitial', () {
      expect(userCubit.state, equals(const UserInitial()));
    });

    group('loadUsers', () {
      blocTest<UserCubit, UserState>(
        'emits [UserLoading, UserLoaded] when loadUsers succeeds',
        build: () {
          when(() => mockUserRepository.getAllUsers())
              .thenAnswer((_) async => sampleUsers);
          return userCubit;
        },
        act: (cubit) => cubit.loadUsers(),
        expect: () => [
          const UserLoading(),
          UserLoaded(users: sampleUsers),
        ],
        verify: (_) {
          verify(() => mockUserRepository.getAllUsers()).called(1);
        },
      );

      blocTest<UserCubit, UserState>(
        'emits [UserLoading, UserError] when loadUsers fails',
        build: () {
          when(() => mockUserRepository.getAllUsers())
              .thenThrow(Exception('Failed to load users'));
          return userCubit;
        },
        act: (cubit) => cubit.loadUsers(),
        expect: () => [
          const UserLoading(),
          const UserError('Gagal memuat users: Exception: Failed to load users'),
        ],
        verify: (_) {
          verify(() => mockUserRepository.getAllUsers()).called(1);
        },
      );
    });

    group('refreshUsers', () {
      blocTest<UserCubit, UserState>(
        'calls clearCache and loads users when refreshUsers is called',
        build: () {
          when(() => mockUserRepository.clearCache()).thenReturn(null);
          when(() => mockUserRepository.getAllUsers())
              .thenAnswer((_) async => sampleUsers);
          return userCubit;
        },
        act: (cubit) => cubit.refreshUsers(),
        expect: () => [
          const UserLoading(),
          UserLoaded(users: sampleUsers),
        ],
        verify: (_) {
          verify(() => mockUserRepository.clearCache()).called(1);
          verify(() => mockUserRepository.getAllUsers()).called(1);
        },
      );
    });

    group('loadUserById', () {
      blocTest<UserCubit, UserState>(
        'emits [UserLoading, UserDetailLoaded] when loadUserById succeeds',
        build: () {
          when(() => mockUserRepository.getUserById(any()))
              .thenAnswer((_) async => sampleUser);
          return userCubit;
        },
        act: (cubit) => cubit.loadUserById(1),
        expect: () => [
          const UserLoading(),
          UserDetailLoaded(sampleUser),
        ],
        verify: (_) {
          verify(() => mockUserRepository.getUserById(1)).called(1);
        },
      );

      blocTest<UserCubit, UserState>(
        'emits [UserLoading, UserError] when loadUserById fails',
        build: () {
          when(() => mockUserRepository.getUserById(any()))
              .thenThrow(Exception('User not found'));
          return userCubit;
        },
        act: (cubit) => cubit.loadUserById(999),
        expect: () => [
          const UserLoading(),
          const UserError('Gagal memuat user: Exception: User not found'),
        ],
        verify: (_) {
          verify(() => mockUserRepository.getUserById(999)).called(1);
        },
      );
    });

    group('searchUsers', () {
      blocTest<UserCubit, UserState>(
        'emits [UserSearchResults] when searchUsers succeeds',
        build: () {
          when(() => mockUserRepository.searchUsers(any()))
              .thenAnswer((_) async => [sampleUser]);
          return userCubit;
        },
        act: (cubit) => cubit.searchUsers('john'),
        expect: () => [
          UserSearchResults(results: [sampleUser], query: 'john'),
        ],
        verify: (_) {
          verify(() => mockUserRepository.searchUsers('john')).called(1);
        },
      );

      blocTest<UserCubit, UserState>(
        'emits [UserLoaded] when searchUsers with empty query',
        build: () => userCubit,
        seed: () => UserLoaded(users: sampleUsers),
        act: (cubit) => cubit.searchUsers(''),
        expect: () => [
          UserLoaded(users: sampleUsers),
        ],
        verify: (_) {
          verifyNever(() => mockUserRepository.searchUsers(any()));
        },
      );

      blocTest<UserCubit, UserState>(
        'emits [UserError] when searchUsers fails',
        build: () {
          when(() => mockUserRepository.searchUsers(any()))
              .thenThrow(Exception('Search failed'));
          return userCubit;
        },
        act: (cubit) => cubit.searchUsers('test'),
        expect: () => [
          const UserError('Gagal mencari users: Exception: Search failed'),
        ],
        verify: (_) {
          verify(() => mockUserRepository.searchUsers('test')).called(1);
        },
      );
    });

    group('clearSearch', () {
      blocTest<UserCubit, UserState>(
        'emits [UserLoaded] with current users when clearSearch is called',
        build: () => userCubit,
        seed: () => UserLoaded(users: sampleUsers),
        act: (cubit) => cubit.clearSearch(),
        expect: () => [
          UserLoaded(users: sampleUsers),
        ],
      );
    });

    group('retry', () {
      blocTest<UserCubit, UserState>(
        'calls loadUsers when retry is called',
        build: () {
          when(() => mockUserRepository.getAllUsers())
              .thenAnswer((_) async => sampleUsers);
          return userCubit;
        },
        act: (cubit) => cubit.retry(),
        expect: () => [
          const UserLoading(),
          UserLoaded(users: sampleUsers),
        ],
        verify: (_) {
          verify(() => mockUserRepository.getAllUsers()).called(1);
        },
      );
    });

    group('Helper methods', () {
      test('isLoading returns true when state is UserLoading', () {
        userCubit.emit(const UserLoading());
        expect(userCubit.isLoading, isTrue);
      });

      test('isLoading returns false when state is UserLoaded', () {
        userCubit.emit(UserLoaded(users: sampleUsers));
        expect(userCubit.isLoading, isFalse);
      });

      test('errorMessage returns message when state is UserError', () {
        const errorMessage = 'Test error';
        userCubit.emit(const UserError(errorMessage));
        expect(userCubit.errorMessage, equals(errorMessage));
      });

      test('errorMessage returns null when state is not UserError', () {
        userCubit.emit(UserLoaded(users: sampleUsers));
        expect(userCubit.errorMessage, isNull);
      });

      test('isSearching returns true when state is UserSearchResults', () {
        userCubit.emit(const UserSearchResults(results: [], query: 'test'));
        expect(userCubit.isSearching, isTrue);
      });

      test('isSearching returns false when state is not UserSearchResults', () {
        userCubit.emit(UserLoaded(users: sampleUsers));
        expect(userCubit.isSearching, isFalse);
      });

      test('currentUsers returns correct list', () {
        userCubit.emit(UserLoaded(users: sampleUsers));
        expect(userCubit.currentUsers, equals(sampleUsers));
      });
    });
  });
}
