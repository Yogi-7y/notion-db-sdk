// import 'package:core_y/core_y.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:network_y/network_y.dart';
// import 'package:notion_db_sdk/src/module/data/repository/notion_repository.dart';
// import 'package:notion_db_sdk/src/module/domain/entity/property.dart';
// import 'package:notion_db_sdk/src/module/domain/entity/property_variants/date.dart';
// import 'package:notion_db_sdk/src/module/domain/entity/property_variants/number.dart';
// import 'package:notion_db_sdk/src/module/domain/entity/property_variants/text.dart';
// import 'package:notion_db_sdk/src/module/domain/entity/value.dart';
// import 'package:notion_db_sdk/src/module/domain/repository/notion_repository.dart';
// import 'package:test/test.dart';

// import 'package:mocktail/mocktail.dart';
import 'package:network_y/network_y.dart';
import 'package:test/test.dart';

const _payload = <String, Object?>{
  'results': [
    {
      'properties': {
        'Description': {
          'id': 'a%7BUf',
          'type': 'rich_text',
          'rich_text': [
            {
              'type': 'text',
              'text': {'content': 'A dark sky', 'link': null},
              'annotations': {
                'bold': false,
                'italic': false,
                'strikethrough': false,
                'underline': false,
                'code': false,
                'color': 'default'
              },
              'plain_text': 'A dark sky',
              'href': null
            }
          ]
        },
        'Number': {'id': 'uCG%3A', 'type': 'number', 'number': 42},
      }
    },
    {
      'properties': {
        'Number': {'id': 'uCG%3A', 'type': 'number', 'number': 42},
        'Date': {
          'id': '%5E%7Cny',
          'type': 'date',
          'date': {'start': '2023-02-23', 'end': null, 'time_zone': null}
        },
      }
    }
  ],
};

// class MockApiClient extends Mock implements ApiClient {}

// class FakePostRequest extends Fake implements PostRequest {}

// void main() {
//   late MockApiClient mockApiClient;
//   late NotionRepository repository;

//   setUpAll(
//     () {
//       print('setupAll');
//       registerFallbackValue(FakePostRequest());
//     },
//   );

//   setUp(
//     () {
//       print('setup');
//       mockApiClient = MockApiClient();
//       repository = NotionRepository(mockApiClient);
//     },
//   );

//   group(
//     'NotionRepository',
//     () {
//       test(
//         'hi',
//         () {},
//       );
//       test(
//         'return the map of properties when response is successful',
//         () async {
//           const _success = Success<Map<String, Object?>, ApiException>(_payload);

//           when(
//             () async => mockApiClient.call<Map<String, Object?>>(any()),
//           ).thenAnswer(
//             (_) => Future.value(_success),
//           );

//           final _expectedResult = <Map<String, Property<Object?>>>[
//             <String, Property<Object?>>{
//               'Description': const Text(
//                 name: 'Description',
//                 type: 'rich_text',
//                 id: 'a%7BUf',
//                 valueDetails: Value(value: 'A dark sky'),
//               ),
//               'Number': const Number(
//                 name: 'Number',
//                 type: 'number',
//                 id: 'uCG%3A',
//                 valueDetails: Value(value: 42),
//               ),
//             },
//             {
//               'Number': const Number(
//                 name: 'Number',
//                 type: 'number',
//                 id: 'uCG%3A',
//                 valueDetails: Value(value: 42),
//               ),
//               'Date': Date(
//                 name: 'Date',
//                 type: 'date',
//                 id: '%5E%7Cny',
//                 valueDetails: Value(
//                   value: DateTime(2023, 2, 23),
//                 ),
//               ),
//             },
//           ];

//           final _result = await repository.getPageProperties('');

//           expect(_result, isA<Success<Properties, ApiException>>());
//           expect(_result, _expectedResult);
//         },
//       );
//     },
//   );
// }

void main() {
  group(
    'NotionRepository',
    () {
      test(
        'hi',
        () {},
      );
    },
  );
}
