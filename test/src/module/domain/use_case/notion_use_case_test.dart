// ignore_for_file: unnecessary_lambdas

import 'package:core_y/core_y.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notion_db_sdk/notion_db_sdk.dart';
import 'package:notion_db_sdk/src/module/domain/repository/notion_repository.dart';
import 'package:notion_db_sdk/src/module/domain/use_case/notion_use_case.dart';
import 'package:test/test.dart';
import 'package:network_y/src/pagination/pagination_params.dart';

class MockRepository extends Mock implements Repository {}

class MockCacheManager extends Mock implements CacheManager<Page> {}

class MockKeepAliveLink extends Mock implements KeepAliveLink {}

class MockPage extends Mock implements Page {}

class FakePage extends Fake implements Page {}

class FakePageResolver extends Fake implements PageResolver {}

void main() {
  late NotionUseCase notionUseCase;
  late MockRepository mockRepository;
  late MockCacheManager mockCacheManager;

  setUpAll(() {
    registerFallbackValue(FakePageResolver());
    registerFallbackValue(FakePage());
  });

  setUp(() {
    mockRepository = MockRepository();
    mockCacheManager = MockCacheManager();

    notionUseCase = NotionUseCase(
      options: const NotionOptions(secret: 'test_secret', version: 'test_version'),
      repository: mockRepository,
      cacheManager: mockCacheManager,
    );
  });

  group('NotionUseCase', () {
    test('query returns Pages on success', () async {
      final mockRepository = MockRepository();
      final useCase = NotionUseCase(
        options: const NotionOptions(secret: 'test', version: 'test'),
        repository: mockRepository,
        cacheManager: MockCacheManager(),
      );

      const databaseId = 'test_database_id';
      final mockPages = [
        Page(
          id: 'page1',
          properties: {
            'Title': const TextProperty(
              name: 'Title',
              valueDetails: Value(value: 'Test Page 1'),
            ),
          },
        ),
        Page(
          id: 'page2',
          properties: {
            'Title': const TextProperty(
              name: 'Title',
              valueDetails: Value(value: 'Test Page 2'),
            ),
          },
        ),
      ];

      when(() => mockRepository.query(databaseId, paginationParams: any(named: 'paginationParams')))
          .thenAnswer(
        (_) async => Success(
          PaginatedResponse(
            results: mockPages,
            hasMore: false,
            paginationParams: const CursorPaginationStrategyParams(limit: 100),
          ),
        ),
      );

      final result = await useCase.query(databaseId);

      expect(result, isA<Success<PaginatedResponse<Page>, AppException>>());
      final pages = result.valueOrNull?.results ?? [];
      expect(pages.length, equals(2));
      expect(pages[0].id, equals('page1'));
      expect(pages[0].properties['Title']?.value, equals('Test Page 1'));
      expect(pages[1].id, equals('page2'));
      expect(pages[1].properties['Title']?.value, equals('Test Page 2'));

      verify(() => mockRepository.query(databaseId)).called(1);
    });

    test('query handles failure', () async {
      const databaseId = 'test_database_id';
      const mockException = AppException(exception: 'Test error', stackTrace: StackTrace.empty);

      when(() => mockRepository.query(databaseId))
          .thenAnswer((_) async => const Failure(mockException));

      final result = await notionUseCase.query(databaseId);

      expect(result, isA<Failure<PaginatedResponse<Page>, AppException>>());
      verify(() => mockRepository.query(databaseId)).called(1);
    });

    test('fetchPageProperties returns properties on success', () async {
      const pageId = 'test_page_id';
      final mockProperties = <String, Property>{
        'Title': const TextProperty(
          name: 'Title',
          valueDetails: Value(value: 'Test Page'),
        ),
        'Date': Date(
          name: 'Date',
          valueDetails: Value(value: DateTime(2024, 8, 30)),
        ),
      };

      when(() => mockRepository.fetchPageProperties(pageId))
          .thenAnswer((_) async => Success(mockProperties));

      final result = await notionUseCase.fetchPageProperties(pageId);

      expect(result, isA<Success<Map<String, Property>, AppException>>());
      expect(result.valueOrNull, equals(mockProperties));
      verify(() => mockRepository.fetchPageProperties(pageId)).called(1);
    });

    test('fetchPageProperties handles failure', () async {
      const pageId = 'test_page_id';
      const mockException = AppException(exception: 'Test error', stackTrace: StackTrace.empty);

      when(() => mockRepository.fetchPageProperties(pageId))
          .thenAnswer((_) async => const Failure(mockException));

      final result = await notionUseCase.fetchPageProperties(pageId);

      expect(result, isA<Failure<Map<String, Property>, AppException>>());
      // expect(result.errorOrNull, equals(mockException));
      verify(() => mockRepository.fetchPageProperties(pageId)).called(1);
    });
  });

  group('Force Fetch Relation', () {
    MockPage createMockPage(String id) {
      final mockPage = MockPage();
      when(() => mockPage.id).thenReturn(id);
      return mockPage;
    }

    void setupQueryMock(String databaseId, List<Map<String, Property>> mockProperties) {
      final pages = mockProperties.map((props) {
        final page = MockPage();
        when(() => page.properties).thenReturn(props);
        return page;
      }).toList();

      final response = Success(
        PaginatedResponse(
          results: pages,
          paginationParams: const CursorPaginationStrategyParams(limit: 100),
          hasMore: true,
        ),
      );

      when(() => mockRepository.query(databaseId)).thenAnswer((_) async => response);
    }

    const databaseId = 'test_database_id';

    test('Query with relation properties, page in cache', () async {
      final mockPage = createMockPage('page_id');
      final mockCachedPage = MockPage();
      final mockProperties = [
        {
          'Related': RelationProperty(
            name: 'Related',
            valueDetails: Value(value: [mockPage]),
          ),
        },
      ];

      setupQueryMock(databaseId, mockProperties);
      when(() => mockCacheManager.get('page_id')).thenReturn(mockCachedPage);
      when(() => mockCachedPage.properties).thenReturn({
        'Title': const TextProperty(
          name: 'Title',
          valueDetails: Value(value: 'Cached Page'),
        )
      });

      final result = await notionUseCase.query(databaseId,
          forceFetchRelationPages: true, cacheRelationPages: true);

      expect(result, isA<Success<PaginatedResponse<Page>, AppException>>());
      verify(() => mockCacheManager.get('page_id')).called(1);
      verifyNever(() => mockPage.resolve(any()));
    });

    test('Query with multiple relation properties, caches all pages', () async {
      final mockPage1 = createMockPage('page_id_1');
      final mockPage2 = createMockPage('page_id_2');
      final mockProperties = [
        {
          'Related1': RelationProperty(
            name: 'Related1',
            valueDetails: Value(value: [mockPage1]),
          ),
          'Related2': RelationProperty(
            name: 'Related2',
            valueDetails: Value(value: [mockPage2]),
          ),
        },
      ];

      setupQueryMock(databaseId, mockProperties);
      when(() => mockCacheManager.get(any())).thenReturn(null);
      when(() => mockPage1.resolve(any())).thenAnswer((_) async {});
      when(() => mockPage2.resolve(any())).thenAnswer((_) async {});
      when(() => mockCacheManager.set(any(), any())).thenReturn(MockKeepAliveLink());

      final result = await notionUseCase.query(
        databaseId,
        forceFetchRelationPages: true,
        cacheRelationPages: true,
      );

      expect(result, isA<Success<PaginatedResponse<Page>, AppException>>());
      verify(() => mockCacheManager.get('page_id_1')).called(1);
      verify(() => mockCacheManager.get('page_id_2')).called(1);
      verify(() => mockPage1.resolve(any())).called(1);
      verify(() => mockPage2.resolve(any())).called(1);
      verify(() => mockCacheManager.set('page_id_1', mockPage1)).called(1);
      verify(() => mockCacheManager.set('page_id_2', mockPage2)).called(1);
    });

    test('Query with relation property, cache expires after query', () async {
      final mockPage = createMockPage('page_id');
      final mockProperties = [
        {
          'Related': RelationProperty(
            name: 'Related',
            valueDetails: Value(value: [mockPage]),
          ),
        },
      ];
      final mockKeepAliveLink = MockKeepAliveLink();

      setupQueryMock(databaseId, mockProperties);
      when(() => mockCacheManager.get('page_id')).thenReturn(null);
      when(() => mockPage.resolve(any())).thenAnswer((_) async {});
      when(() => mockCacheManager.set(any(), any())).thenReturn(mockKeepAliveLink);

      final result = await notionUseCase.query(databaseId,
          forceFetchRelationPages: true, cacheRelationPages: true);

      expect(result, isA<Success<PaginatedResponse<Page>, AppException>>());
      verify(() => mockCacheManager.set('page_id', mockPage)).called(1);
      verify(() => mockKeepAliveLink.expire()).called(1);
    });
  });
}
