import 'package:core_y/core_y.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_y/network_y.dart';
import 'package:notion_db_sdk/notion_db_sdk.dart';
import 'package:notion_db_sdk/src/module/data/repository/notion_repository.dart';
import 'package:notion_db_sdk/src/module/domain/entity/property.dart';
import 'package:notion_db_sdk/src/module/domain/entity/property_variants/variants.dart';
import 'package:notion_db_sdk/src/module/domain/entity/value.dart';
import 'package:notion_db_sdk/src/module/domain/repository/notion_repository.dart';
import 'package:test/test.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockPostRequest extends Mock implements PostRequest {}

void main() {
  late NotionRepository repository;
  late MockApiClient mockApiClient;

  setUpAll(() {
    registerFallbackValue(MockPostRequest());
  });

  setUp(() {
    mockApiClient = MockApiClient();
    repository = NotionRepository(mockApiClient);
  });

  group('NotionRepository', () {
    group('query', () {
      test('returns Properties on successful API call', () async {
        const databaseId = 'test_database_id';
        final mockResponse = {
          'results': [
            {
              'id': 'test_page_id',
              'properties': {
                'Name': {
                  'id': 'title',
                  'type': 'title',
                  'title': [
                    {
                      'text': {'content': 'Test Task'}
                    }
                  ]
                },
                'Status': {
                  'id': 'status',
                  'type': 'status',
                  'status': {'name': 'In Progress'}
                }
              }
            }
          ]
        };

        when(() => mockApiClient.call<Map<String, Object?>>(any()))
            .thenAnswer((_) async => Success(mockResponse));

        final result = await repository.query(databaseId);

        expect(result, isA<Success<PaginatedResponse<Pages>, ApiException>>());
        final pages = result.valueOrNull?.results ?? [];
        final properties = pages[0].properties;
        expect(pages.length, 1);
        expect(properties['Name'], isA<TextProperty>());
        expect(properties['Name']!.value, 'Test Task');
        expect(properties['Status'], isA<Status>());
        expect(properties['Status']!.value, 'In Progress');

        verify(() => mockApiClient.call<Map<String, Object?>>(any())).called(1);
      });

      test('returns Failure on API error', () async {
        const databaseId = 'test_database_id';
        final mockException = ApiException(
          exception: Exception('API Error'),
          stackTrace: StackTrace.empty,
          request: MockPostRequest(),
        );

        when(() => mockApiClient.call<Map<String, Object?>>(any()))
            .thenAnswer((_) async => Failure(mockException));

        final result = await repository.query(databaseId);

        expect(result, isA<Failure<PaginatedResponse<Pages>, ApiException>>());
        verify(() => mockApiClient.call<Map<String, Object?>>(any())).called(1);
      });
    });

    group('fetchPageProperties', () {
      test('returns Map<String, Property> on successful API call', () async {
        const pageId = 'test_page_id';
        final mockResponse = {
          'properties': {
            'Title': {
              'id': 'title',
              'type': 'title',
              'title': [
                {
                  'text': {'content': 'Test Page'}
                }
              ]
            },
            'Date': {
              'id': 'date',
              'type': 'date',
              'date': {'start': '2024-08-30'}
            }
          }
        };

        when(() => mockApiClient.call<Map<String, Object?>>(any()))
            .thenAnswer((_) async => Success(mockResponse));

        final result = await repository.fetchPageProperties(pageId);

        expect(result, isA<Success<Map<String, Property>, ApiException>>());
        final properties = result.valueOrNull!;
        expect(properties['Title'], isA<TextProperty>());
        expect(properties['Title']!.value, 'Test Page');
        expect(properties['Date'], isA<Date>());
        expect(properties['Date']!.value, DateTime(2024, 8, 30));

        verify(() => mockApiClient.call<Map<String, Object?>>(any())).called(1);
      });

      test('returns Failure on API error', () async {
        const pageId = 'test_page_id';

        final mockException = ApiException(
          exception: Exception('API Error'),
          stackTrace: StackTrace.empty,
          request: MockPostRequest(),
        );

        when(() => mockApiClient.call<Map<String, Object?>>(any()))
            .thenAnswer((_) async => Failure(mockException));

        final result = await repository.fetchPageProperties(pageId);

        expect(result, isA<Failure<Map<String, Property>, ApiException>>());

        verify(() => mockApiClient.call<Map<String, Object?>>(any())).called(1);
      });
    });

    group('createPage', () {
      test('returns Success on successful API call', () async {
        const databaseId = 'test_database_id';
        const properties = [
          TextProperty(
            name: 'Name',
            valueDetails: Value(value: 'New Task'),
            isTitle: true,
          ),
          Status(
            name: 'Status',
            valueDetails: Value(value: 'To Do'),
          ),
        ];

        when(() => mockApiClient.call<void>(any())).thenAnswer((_) async => const Success(null));

        final result = await repository.createPage(databaseId, properties);

        expect(result, isA<Success<void, AppException>>());

        verify(() => mockApiClient.call<void>(any())).called(1);
      });

      test('returns Failure on API error', () async {
        const databaseId = 'test_database_id';
        const properties = [
          TextProperty(
            name: 'Name',
            valueDetails: Value(value: 'New Task'),
            isTitle: true,
          ),
        ];

        final mockException = ApiException(
          exception: Exception('API Error'),
          stackTrace: StackTrace.empty,
          request: MockPostRequest(),
        );
        when(() => mockApiClient.call<void>(any())).thenAnswer((_) async => Failure(mockException));

        final result = await repository.createPage(databaseId, properties);

        expect(result, isA<Failure<void, AppException>>());

        verify(() => mockApiClient.call<void>(any())).called(1);
      });
    });
  });
}
