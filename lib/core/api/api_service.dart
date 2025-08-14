import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';
import 'api_response.dart';

class ApiService {
  static const String _baseUrl = ApiConstants.baseUrl;
  String? _authToken;

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Public instance getter for backward compatibility
  static ApiService get instance => _instance;

  // Set authentication token
  void setAuthToken(String token) {
    _authToken = token;
  }

  // Clear authentication token
  void clearAuthToken() {
    _authToken = null;
  }

  // Get headers with authentication
  Map<String, String> _getHeaders({bool includeAuth = true}) {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
    };

    if (includeAuth && _authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
      print('🔐 ApiService: Auth token included in headers');
    } else if (includeAuth && _authToken == null) {
      print('⚠️ ApiService: Auth required but no token available');
    }

    // Debug logging to track headers
    print(
      '🔑 API Headers - includeAuth: $includeAuth, hasToken: ${_authToken != null}',
    );
    if (_authToken != null) {
      print(
        '🔑 Auth token (first 20 chars): ${_authToken!.substring(0, _authToken!.length > 20 ? 20 : _authToken!.length)}...',
      );
    }
    print('🔑 API Headers: $headers');

    print(
      '📡 ApiService: Headers prepared - Auth: $includeAuth, Token exists: ${_authToken != null}',
    );
    return headers;
  }

  // Generic GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? queryParams,
    bool requireAuth = true,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl$endpoint',
      ).replace(queryParameters: queryParams);

      print('🌐 ApiService: Making GET request to: $uri');
      print('🔒 ApiService: Auth required: $requireAuth');

      final response = await http.get(
        uri,
        headers: _getHeaders(includeAuth: requireAuth),
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      print('❌ ApiService: Network error: $e');
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  // Generic POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requireAuth = true,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$endpoint'),
        headers: _getHeaders(includeAuth: requireAuth),
        body: body != null ? json.encode(body) : null,
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  // Generic PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requireAuth = true,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl$endpoint'),
        headers: _getHeaders(includeAuth: requireAuth),
        body: body != null ? json.encode(body) : null,
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  // Generic DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    bool requireAuth = true,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl$endpoint'),
        headers: _getHeaders(includeAuth: requireAuth),
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  // Handle HTTP response
  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(dynamic)? fromJson,
  ) {
    try {
      print('📥 ApiService: Response status: ${response.statusCode}');
      print('📥 ApiService: Response body: ${response.body}');

      // Handle redirect responses (3xx status codes)
      if (response.statusCode >= 300 && response.statusCode < 400) {
        return ApiResponse.error(
          'Server redirect detected. Please check API endpoint configuration.',
        );
      }

      // Check if response body is HTML (redirect page)
      if (response.body.trim().startsWith('<!DOCTYPE html>') ||
          response.body.trim().startsWith('<html>')) {
        return ApiResponse.error(
          'Server returned HTML instead of JSON. Please check API endpoint.',
        );
      }

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (fromJson != null && responseData['data'] != null) {
          return ApiResponse.success(fromJson(responseData['data']));
        } else {
          return ApiResponse.success(responseData as T);
        }
      } else {
        // Extract field-level validation messages if present (e.g., { data: { email: ["The email has already been taken."] } })
        final extracted = _extractFirstErrorMessage(responseData);
        final errorMessage = extracted.isNotEmpty
            ? extracted
            : (responseData['message'] ?? 'Unknown error occurred');

        return ApiResponse.error(errorMessage);
      }
    } catch (e) {
      return ApiResponse.error('Failed to parse response: ${e.toString()}');
    }
  }

  // Pull the first meaningful error message from common backend error shapes
  String _extractFirstErrorMessage(dynamic responseData) {
    try {
      final dynamic errorContainer = responseData is Map<String, dynamic>
          ? (responseData['errors'] ?? responseData['data'])
          : null;

      if (errorContainer is Map) {
        for (final entry in errorContainer.entries) {
          final value = entry.value;
          if (value is List && value.isNotEmpty) {
            final first = value.first;
            if (first is String && first.trim().isNotEmpty) {
              return first;
            }
          } else if (value is String && value.trim().isNotEmpty) {
            return value;
          }
        }
      }

      if (responseData is Map && responseData['error'] is String) {
        return (responseData['error'] as String).trim();
      }
    } catch (_) {
      // Ignore parsing errors and fall back to the generic message
    }

    return '';
  }
}
