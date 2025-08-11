import 'dart:convert';
import '../api/api_service.dart';
import '../api/api_constants.dart';
import '../api/api_response.dart';
import '../models/auth_model.dart';
import '../helpers/storage_helper.dart';

class AuthRepository {
  final ApiService _apiService = ApiService.instance;
  final StorageHelper _storageHelper = StorageHelper.instance;

  // Login user
  Future<ApiResponse<AuthResponse>> login(LoginRequest request) async {
    try {
      final response = await _apiService.post(
        ApiConstants.login,
        body: request.toJson(),
      );

      if (response.isSuccess && response.data != null) {
        final authResponse = AuthResponse.fromJson(response.data!);

        // Store token and user data
        await _storageHelper.setString('auth_token', authResponse.token);
        await _storageHelper.setString(
          'user_data',
          jsonEncode(authResponse.user.toJson()),
        );

        // Set token in API service
        _apiService.setAuthToken(authResponse.token);

        return ApiResponse.success(authResponse);
      }

      return ApiResponse.error(response.message ?? 'Login failed');
    } catch (e) {
      return ApiResponse.error('Login failed: ${e.toString()}');
    }
  }

  // Register user
  Future<ApiResponse<AuthResponse>> register(RegisterRequest request) async {
    try {
      final response = await _apiService.post(
        ApiConstants.register,
        body: request.toJson(),
        requireAuth: false,
      );

      if (response.isSuccess && response.data != null) {
        final authResponse = AuthResponse.fromJson(response.data!);

        // Store token and user data
        await _storageHelper.setString('auth_token', authResponse.token);
        await _storageHelper.setString(
          'user_data',
          jsonEncode(authResponse.user.toJson()),
        );

        // Set token in API service
        _apiService.setAuthToken(authResponse.token);

        return ApiResponse.success(authResponse);
      }

      return ApiResponse.error(response.message ?? 'Registration failed');
    } catch (e) {
      return ApiResponse.error('Registration failed: ${e.toString()}');
    }
  }

  // Logout user
  Future<ApiResponse<void>> logout() async {
    try {
      final response = await _apiService.post(ApiConstants.logout);

      // Check if logout API call was successful
      if (response.isSuccess) {
      } else {
        // Continue with local cleanup even if API fails
      }

      // Always clear stored data regardless of API response
      await _storageHelper.remove('auth_token');
      await _storageHelper.remove('user_data');

      // Clear token from API service
      _apiService.clearAuthToken();

      return ApiResponse.success(null);
    } catch (e) {
      // Even if API call fails, clear local data
      await _storageHelper.remove('auth_token');
      await _storageHelper.remove('user_data');
      _apiService.clearAuthToken();

      return ApiResponse.success(null);
    }
  }

  // Get current user using /api/user endpoint
  Future<ApiResponse<User>> getUser() async {
    try {
      final response = await _apiService.get(ApiConstants.profile);

      if (response.isSuccess && response.data != null) {
        final user = User.fromJson(response.data!);

        // Update stored user data
        await _storageHelper.setString('user_data', jsonEncode(user.toJson()));

        return ApiResponse.success(user);
      }

      return ApiResponse.error(
        response.message ?? 'Failed to get user profile',
      );
    } catch (e) {
      return ApiResponse.error('Failed to get user profile: ${e.toString()}');
    }
  }

  // Get current user using /api/profile endpoint (existing method)
  Future<ApiResponse<User>> getCurrentUser() async {
    try {
      final response = await _apiService.get(ApiConstants.profile);

      if (response.isSuccess && response.data != null) {
        final user = User.fromJson(response.data!);

        // Update stored user data
        await _storageHelper.setString('user_data', jsonEncode(user.toJson()));

        return ApiResponse.success(user);
      }

      return ApiResponse.error(
        response.message ?? 'Failed to get user profile',
      );
    } catch (e) {
      return ApiResponse.error('Failed to get user: ${e.toString()}');
    }
  }

  // Update user profile
  Future<ApiResponse<User>> updateProfile(UpdateProfileRequest request) async {
    try {
      final response = await _apiService.put(
        ApiConstants.updateProfile,
        body: request.toJson(),
      );

      if (response.isSuccess && response.data != null) {
        final user = User.fromJson(response.data!);

        // Update stored user data
        await _storageHelper.setString('user_data', jsonEncode(user.toJson()));

        return ApiResponse.success(user);
      }

      return ApiResponse.error(response.message ?? 'Password reset failed');
    } catch (e) {
      return ApiResponse.error('Profile update failed: ${e.toString()}');
    }
  }

  // Change password
  Future<ApiResponse<void>> changePassword(
    ChangePasswordRequest request,
  ) async {
    try {
      final response = await _apiService.put(
        ApiConstants.changePassword,
        body: request.toJson(),
      );

      if (response.isSuccess) {
        return ApiResponse.success(null);
      }

      return ApiResponse.error(response.message ?? 'Email verification failed');
    } catch (e) {
      return ApiResponse.error('Password change failed: ${e.toString()}');
    }
  }

  // Send reset password pin
  Future<ApiResponse<void>> sendResetPasswordPin(
    ForgotPasswordRequest request,
  ) async {
    try {
      final response = await _apiService.post(
        ApiConstants.sendResetPasswordPin,
        body: request.toJson(),
        requireAuth: false,
      );

      if (response.isSuccess) {
        return ApiResponse.success(null);
      }

      return ApiResponse.error(response.message ?? 'Failed to send reset pin');
    } catch (e) {
      return ApiResponse.error('Failed to send reset pin: ${e.toString()}');
    }
  }

  // Forgot password (legacy method - kept for compatibility)
  Future<ApiResponse<void>> forgotPassword(
    ForgotPasswordRequest request,
  ) async {
    // Use the new send reset password pin method
    return sendResetPasswordPin(request);
  }

  // Reset password
  Future<ApiResponse<void>> resetPassword(ResetPasswordRequest request) async {
    try {
      final response = await _apiService.post(
        ApiConstants.resetPassword,
        body: request.toJson(),
      );

      if (response.isSuccess) {
        return ApiResponse.success(null);
      }

      return ApiResponse.error(response.message ?? 'Password reset failed');
    } catch (e) {
      return ApiResponse.error('Password reset failed: ${e.toString()}');
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _storageHelper.getString('auth_token');
    return token != null && token.isNotEmpty;
  }

  // Get stored user data
  Future<User?> getStoredUser() async {
    try {
      final userData = await _storageHelper.getString('user_data');
      if (userData != null && userData.isNotEmpty) {
        final Map<String, dynamic> userMap = jsonDecode(userData);
        return User.fromJson(userMap);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Send email verification notification
  Future<ApiResponse<void>> sendEmailVerification() async {
    try {
      final response = await _apiService.post(
        ApiConstants.resendVerification,
        requireAuth: true,
      );

      if (response.isSuccess) {
        return ApiResponse.success(null);
      }

      return ApiResponse.error(
        response.message ?? 'Failed to send verification email',
      );
    } catch (e) {
      return ApiResponse.error(
        'Failed to send verification email: ${e.toString()}',
      );
    }
  }

  // Verify email with id and hash
  Future<ApiResponse<void>> verifyEmail(String id, String hash) async {
    try {
      final response = await _apiService.get(
        '${ApiConstants.verifyEmail}/$id/$hash',
      );

      if (response.isSuccess) {
        return ApiResponse.success(null);
      }

      return ApiResponse.error(response.message ?? 'Email verification failed');
    } catch (e) {
      return ApiResponse.error('Email verification failed: ${e.toString()}');
    }
  }

  // Verify email with OTP
  Future<ApiResponse<void>> verifyEmailWithOtp(String otp) async {
    try {
      final response = await _apiService.post(
        ApiConstants.verifyEmailOtp,
        body: {'otp': otp},
        requireAuth: true,
      );

      if (response.isSuccess) {
        return ApiResponse.success(null);
      }

      return ApiResponse.error(response.message ?? 'OTP verification failed');
    } catch (e) {
      return ApiResponse.error('OTP verification failed: ${e.toString()}');
    }
  }

  // Resend OTP
  Future<ApiResponse<void>> resendOtp() async {
    try {
      final response = await _apiService.get(
        ApiConstants.resendOtp,
        requireAuth: true,
      );

      if (response.isSuccess) {
        return ApiResponse.success(null);
      }

      return ApiResponse.error(response.message ?? 'Failed to resend OTP');
    } catch (e) {
      return ApiResponse.error('Failed to resend OTP: ${e.toString()}');
    }
  }

  // Initialize auth state (call on app start)
  Future<void> initializeAuth() async {
    final token = await _storageHelper.getString('auth_token');
    if (token != null && token.isNotEmpty) {
      _apiService.setAuthToken(token);
    }
  }
}
