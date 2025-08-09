class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final String? error;

  ApiResponse._(this.success, this.data, this.message, this.error);

  // Success response
  factory ApiResponse.success(T data, [String? message]) {
    return ApiResponse._(true, data, message, null);
  }

  // Error response
  factory ApiResponse.error(String error) {
    return ApiResponse._(false, null, null, error);
  }

  // Check if response is successful
  bool get isSuccess => success;

  // Check if response has error
  bool get hasError => !success;

  // Get error message or default
  String getErrorMessage([String defaultMessage = 'An error occurred']) {
    return error ?? defaultMessage;
  }

  // Transform data if successful
  ApiResponse<R> map<R>(R Function(T data) transform) {
    if (isSuccess && data != null) {
      try {
        return ApiResponse.success(transform(data as T), message);
      } catch (e) {
        return ApiResponse.error('Data transformation failed: ${e.toString()}');
      }
    }
    return ApiResponse.error(error ?? 'No data to transform');
  }

  // Handle response with callbacks
  R when<R>({
    required R Function(T data) success,
    required R Function(String error) error,
  }) {
    if (isSuccess && data != null) {
      return success(data as T);
    } else {
      return error(this.error ?? 'Unknown error');
    }
  }

  @override
  String toString() {
    if (isSuccess) {
      return 'ApiResponse.success(data: $data, message: $message)';
    } else {
      return 'ApiResponse.error(error: $error)';
    }
  }
}

// Paginated response wrapper
class PaginatedResponse<T> {
  final List<T> data;
  final int currentPage;
  final int lastPage;
  final int total;
  final int perPage;
  final String? nextPageUrl;
  final String? prevPageUrl;

  PaginatedResponse({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.perPage,
    this.nextPageUrl,
    this.prevPageUrl,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final dataList = (json['data'] as List)
        .map((item) => fromJsonT(item as Map<String, dynamic>))
        .toList();

    return PaginatedResponse(
      data: dataList,
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      total: json['total'] ?? 0,
      perPage: json['per_page'] ?? 20,
      nextPageUrl: json['next_page_url'],
      prevPageUrl: json['prev_page_url'],
    );
  }

  bool get hasNextPage => nextPageUrl != null;
  bool get hasPrevPage => prevPageUrl != null;
  bool get isFirstPage => currentPage == 1;
  bool get isLastPage => currentPage == lastPage;
}
