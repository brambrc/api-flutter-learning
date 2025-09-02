import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:api_learning_flutter/bloc/post_bloc.dart';
import 'package:api_learning_flutter/bloc/post_event.dart';
import 'package:api_learning_flutter/bloc/post_state.dart';
import 'package:api_learning_flutter/data/repositories/post_repository.dart';
import 'package:api_learning_flutter/models/post.dart';

// Mock class untuk PostRepository
class MockPostRepository extends Mock implements PostRepository {}

void main() {
  group('PostBloc', () {
    late PostBloc postBloc;
    late MockPostRepository mockPostRepository;

    // Sample data untuk testing
    final samplePosts = [
      Post(id: 1, userId: 1, title: 'Test Post 1', body: 'Test Body 1'),
      Post(id: 2, userId: 1, title: 'Test Post 2', body: 'Test Body 2'),
    ];

    final samplePost = Post(id: 1, userId: 1, title: 'Test Post', body: 'Test Body');

    setUp(() {
      mockPostRepository = MockPostRepository();
      postBloc = PostBloc(mockPostRepository);
    });

    tearDown(() {
      postBloc.close();
    });

    test('initial state is PostInitial', () {
      expect(postBloc.state, equals(const PostInitial()));
    });

    group('LoadPosts', () {
      blocTest<PostBloc, PostState>(
        'emits [PostLoading, PostLoaded] when LoadPosts succeeds',
        build: () {
          when(() => mockPostRepository.getAllPosts())
              .thenAnswer((_) async => samplePosts);
          return postBloc;
        },
        act: (bloc) => bloc.add(const LoadPosts()),
        expect: () => [
          const PostLoading(),
          PostLoaded(posts: samplePosts),
        ],
        verify: (_) {
          verify(() => mockPostRepository.getAllPosts()).called(1);
        },
      );

      blocTest<PostBloc, PostState>(
        'emits [PostLoading, PostError] when LoadPosts fails',
        build: () {
          when(() => mockPostRepository.getAllPosts())
              .thenThrow(Exception('Failed to load posts'));
          return postBloc;
        },
        act: (bloc) => bloc.add(const LoadPosts()),
        expect: () => [
          const PostLoading(),
          const PostError('Gagal memuat posts: Exception: Failed to load posts'),
        ],
        verify: (_) {
          verify(() => mockPostRepository.getAllPosts()).called(1);
        },
      );
    });

    group('CreatePost', () {
      blocTest<PostBloc, PostState>(
        'emits [PostOperationInProgress, PostCreated, PostLoaded] when CreatePost succeeds',
        build: () {
          when(() => mockPostRepository.createPost(any()))
              .thenAnswer((_) async => samplePost);
          return postBloc;
        },
        act: (bloc) => bloc.add(CreatePost(samplePost)),
        expect: () => [
          const PostOperationInProgress('creating'),
          PostCreated(samplePost),
          PostLoaded(posts: [samplePost]),
        ],
        verify: (_) {
          verify(() => mockPostRepository.createPost(samplePost)).called(1);
        },
      );

      blocTest<PostBloc, PostState>(
        'emits [PostOperationInProgress, PostError] when CreatePost fails',
        build: () {
          when(() => mockPostRepository.createPost(any()))
              .thenThrow(Exception('Failed to create post'));
          return postBloc;
        },
        act: (bloc) => bloc.add(CreatePost(samplePost)),
        expect: () => [
          const PostOperationInProgress('creating'),
          const PostError('Gagal membuat post: Exception: Failed to create post'),
        ],
        verify: (_) {
          verify(() => mockPostRepository.createPost(samplePost)).called(1);
        },
      );
    });

    group('UpdatePost', () {
      blocTest<PostBloc, PostState>(
        'emits [PostOperationInProgress, PostUpdated, PostLoaded] when UpdatePost succeeds',
        build: () {
          when(() => mockPostRepository.updatePost(any(), any()))
              .thenAnswer((_) async => samplePost);
          return postBloc;
        },
        seed: () => PostLoaded(posts: [samplePost]),
        act: (bloc) => bloc.add(UpdatePost(1, samplePost)),
        expect: () => [
          const PostOperationInProgress('updating', postId: 1),
          PostUpdated(samplePost),
          PostLoaded(posts: [samplePost]),
        ],
        verify: (_) {
          verify(() => mockPostRepository.updatePost(1, samplePost)).called(1);
        },
      );
    });

    group('DeletePost', () {
      blocTest<PostBloc, PostState>(
        'emits [PostOperationInProgress, PostDeleted, PostLoaded] when DeletePost succeeds',
        build: () {
          when(() => mockPostRepository.deletePost(any()))
              .thenAnswer((_) async => true);
          return postBloc;
        },
        seed: () => PostLoaded(posts: [samplePost]),
        act: (bloc) => bloc.add(const DeletePost(1)),
        expect: () => [
          const PostOperationInProgress('deleting', postId: 1),
          const PostDeleted(1),
          const PostLoaded(posts: []),
        ],
        verify: (_) {
          verify(() => mockPostRepository.deletePost(1)).called(1);
        },
      );
    });

    group('SearchPosts', () {
      blocTest<PostBloc, PostState>(
        'emits [PostSearchResults] when SearchPosts succeeds',
        build: () {
          when(() => mockPostRepository.searchPosts(any()))
              .thenAnswer((_) async => [samplePost]);
          return postBloc;
        },
        act: (bloc) => bloc.add(const SearchPosts('test')),
        expect: () => [
          const PostSearchResults(results: [], query: 'test', isLoading: true),
          PostSearchResults(results: [samplePost], query: 'test', isLoading: false),
        ],
        verify: (_) {
          verify(() => mockPostRepository.searchPosts('test')).called(1);
        },
      );

      blocTest<PostBloc, PostState>(
        'emits [PostLoaded] when SearchPosts with empty query',
        build: () => postBloc,
        seed: () => PostLoaded(posts: samplePosts),
        act: (bloc) => bloc.add(const SearchPosts('')),
        expect: () => [
          PostLoaded(posts: samplePosts),
        ],
        verify: (_) {
          verifyNever(() => mockPostRepository.searchPosts(any()));
        },
      );
    });

    group('RefreshPosts', () {
      blocTest<PostBloc, PostState>(
        'calls clearCache and loads posts when RefreshPosts is added',
        build: () {
          when(() => mockPostRepository.clearCache()).thenReturn(null);
          when(() => mockPostRepository.getAllPosts())
              .thenAnswer((_) async => samplePosts);
          return postBloc;
        },
        act: (bloc) => bloc.add(const RefreshPosts()),
        verify: (_) {
          verify(() => mockPostRepository.clearCache()).called(1);
          verify(() => mockPostRepository.getAllPosts()).called(1);
        },
      );
    });

    group('ClearSearch', () {
      blocTest<PostBloc, PostState>(
        'emits [PostLoaded] with current posts when ClearSearch is added',
        build: () => postBloc,
        seed: () => PostLoaded(posts: samplePosts),
        act: (bloc) => bloc.add(const ClearSearch()),
        expect: () => [
          PostLoaded(posts: samplePosts),
        ],
      );
    });

    group('Helper methods', () {
      test('isLoading returns true when state is PostLoading', () {
        postBloc.emit(const PostLoading());
        expect(postBloc.isLoading, isTrue);
      });

      test('isLoading returns true when state is PostOperationInProgress', () {
        postBloc.emit(const PostOperationInProgress('creating'));
        expect(postBloc.isLoading, isTrue);
      });

      test('isLoading returns false when state is PostLoaded', () {
        postBloc.emit(PostLoaded(posts: samplePosts));
        expect(postBloc.isLoading, isFalse);
      });

      test('errorMessage returns message when state is PostError', () {
        const errorMessage = 'Test error';
        postBloc.emit(const PostError(errorMessage));
        expect(postBloc.errorMessage, equals(errorMessage));
      });

      test('errorMessage returns null when state is not PostError', () {
        postBloc.emit(PostLoaded(posts: samplePosts));
        expect(postBloc.errorMessage, isNull);
      });
    });
  });
}
