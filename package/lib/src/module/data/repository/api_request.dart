import 'package:network_y/network_y.dart';

import '../../../core/network/api_constants.dart';

class FetchPropertiesRequest extends BaseNotionRequest implements PostRequest {
  FetchPropertiesRequest({
    required this.databaseId,
  }) : super(
          endpoint: '/databases/$databaseId/query',
        );

  final String databaseId;

  @override
  Payload get body => {};
}
