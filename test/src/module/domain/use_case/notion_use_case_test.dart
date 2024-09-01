import 'package:core_y/core_y.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notion_db_sdk/src/module/domain/entity/page.dart';
import 'package:notion_db_sdk/src/module/domain/entity/property.dart';
import 'package:notion_db_sdk/src/module/domain/entity/property_variants/variants.dart';
import 'package:notion_db_sdk/src/module/domain/entity/value.dart';
import 'package:notion_db_sdk/src/module/domain/repository/notion_repository.dart';
import 'package:notion_db_sdk/src/module/domain/use_case/notion_use_case.dart';
import 'package:test/test.dart';

class MockRepository extends Mock implements Repository {}

class MockPage extends Mock implements Page {}

class FakePageResolver extends Fake implements PageResolver {}

void main() {
  late NotionUseCase notionUseCase;
  late MockRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakePageResolver());
  });

  setUp(() {
    mockRepository = MockRepository();
    notionUseCase = NotionUseCase(
      options: const NotionOptions(secret: 'test_secret', version: 'test_version'),
      repository: mockRepository,
    );
  });

  group('NotionUseCase', () {
    test('query returns properties on success', () async {
      const databaseId = 'test_database_id';
      final mockProperties = [
        {
          'Name': const TextProperty(
            name: 'Name',
            valueDetails: Value(value: 'Test Task'),
          ),
          'Status': const Status(
            name: 'Status',
            valueDetails: Value(value: 'In Progress'),
          ),
        }
      ];

      when(() => mockRepository.query(databaseId)).thenAnswer((_) async => Success(mockProperties));

      final result = await notionUseCase.query(databaseId);

      expect(result, isA<Success<Properties, AppException>>());
      expect(result.valueOrNull, equals(mockProperties));
      verify(() => mockRepository.query(databaseId)).called(1);
    });

    test('query handles failure', () async {
      const databaseId = 'test_database_id';
      const mockException = AppException(exception: 'Test error', stackTrace: StackTrace.empty);

      when(() => mockRepository.query(databaseId))
          .thenAnswer((_) async => const Failure(mockException));

      final result = await notionUseCase.query(databaseId);

      expect(result, isA<Failure<Properties, AppException>>());
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
    test('resolves relation properties when forceFetchRelationPages is true', () async {
      const databaseId = 'test_database_id';
      final mockPage1 = MockPage();
      final mockPage2 = MockPage();
      final mockProperties = <Map<String, Property>>[
        {
          'Name': const TextProperty(
            name: 'Name',
            valueDetails: Value(value: 'Test Task'),
          ),
          'Related': RelationProperty(
            name: 'Related',
            valueDetails: Value(value: [mockPage1, mockPage2]),
          ),
        }
      ];

      when(() => mockRepository.query(databaseId)).thenAnswer((_) async => Success(mockProperties));

      when(() => mockPage1.resolve(any())).thenAnswer((_) async {});
      when(() => mockPage2.resolve(any())).thenAnswer((_) async {});

      final result = await notionUseCase.query(databaseId, forceFetchRelationPages: true);

      expect(result, isA<Success<Properties, AppException>>());
      expect(result.valueOrNull, equals(mockProperties));
      verify(() => mockRepository.query(databaseId)).called(1);
      verify(() => mockPage1.resolve(any())).called(1);
      verify(() => mockPage2.resolve(any())).called(1);
    });

    test('does not resolve relation properties when lazyLoadRelations is false', () async {
      const databaseId = 'test_database_id';
      final mockPage = MockPage();
      final mockProperties = <Map<String, Property>>[
        {
          'Name': const TextProperty(
            name: 'Name',
            valueDetails: Value(value: 'Test Task'),
          ),
          'Related': RelationProperty(
            name: 'Related',
            valueDetails: Value(value: [mockPage]),
          ),
        }
      ];

      when(() => mockRepository.query(databaseId)).thenAnswer((_) async => Success(mockProperties));

      final result = await notionUseCase.query(databaseId);

      expect(result, isA<Success<Properties, AppException>>());
      expect(result.valueOrNull, equals(mockProperties));
      verify(() => mockRepository.query(databaseId)).called(1);
      verifyNever(() => mockPage.resolve(any()));
    });
  });
}
