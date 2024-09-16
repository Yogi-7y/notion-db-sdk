import 'package:network_y/src/pagination/pagination_params.dart';

abstract class Pageable {
  CursorPaginationStrategyParams? get paginationParams;
}
