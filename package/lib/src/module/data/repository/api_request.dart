import 'package:meta/meta.dart';
import 'package:network_y/network.dart';

@immutable
class GetPagesRequest extends GetRequest {
  const GetPagesRequest({
    required super.host,
    required super.endpoint,
  });
}
