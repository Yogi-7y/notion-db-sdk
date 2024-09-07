abstract class Pageable {
  PaginationParams? get paginationParams;
}

class PaginationParams {
  PaginationParams({this.startCursor, this.pageSize});

  final String? startCursor;
  final int? pageSize;

  Map<String, dynamic> toMap() => {
        if (startCursor != null) 'start_cursor': startCursor,
        if (pageSize != null) 'page_size': pageSize,
      };
}

class PaginatedResponse<T> {
  PaginatedResponse({
    required this.results,
    required this.hasMore,
    this.nextCursor,
  });

  final T results;
  final bool hasMore;
  final String? nextCursor;
}
