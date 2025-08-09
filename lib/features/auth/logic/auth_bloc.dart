import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/repositories/auth_repository.dart';
import '../../../core/models/auth_model.dart';
import '../../../core/di/service_locator.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  const AuthRegisterRequested({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  @override
  List<Object> get props => [name, email, password, passwordConfirmation];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthCheckRequested extends AuthEvent {}

class AuthGetUserRequested extends AuthEvent {}

class AuthUpdateProfileRequested extends AuthEvent {
  final String? name;
  final String? email;
  final String? phone;
  final String? address;

  const AuthUpdateProfileRequested({this.name, this.email, this.phone, this.address});

  @override
  List<Object?> get props => [name, email, phone, address];
}

class AuthChangePasswordRequested extends AuthEvent {
  final String currentPassword;
  final String newPassword;
  final String passwordConfirmation;

  const AuthChangePasswordRequested({
    required this.currentPassword,
    required this.newPassword,
    required this.passwordConfirmation,
  });

  @override
  List<Object> get props => [
    currentPassword,
    newPassword,
    passwordConfirmation,
  ];
}

class AuthForgotPasswordRequested extends AuthEvent {
  final String email;

  const AuthForgotPasswordRequested({required this.email});

  @override
  List<Object> get props => [email];
}

class AuthResetPasswordRequested extends AuthEvent {
  final String email;
  final String token;
  final String password;
  final String passwordConfirmation;

  const AuthResetPasswordRequested({
    required this.email,
    required this.token,
    required this.password,
    required this.passwordConfirmation,
  });

  @override
  List<Object> get props => [email, token, password, passwordConfirmation];
}

class AuthVerifyOtpRequested extends AuthEvent {
  final String otp;

  const AuthVerifyOtpRequested({required this.otp});

  @override
  List<Object> get props => [otp];
}

class AuthResendOtpRequested extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object> get props => [message];
}

class AuthSuccess extends AuthState {
  final String message;

  const AuthSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository = sl<AuthRepository>();

  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthGetUserRequested>(_onGetUserRequested);
    on<AuthUpdateProfileRequested>(_onUpdateProfileRequested);
    on<AuthChangePasswordRequested>(_onChangePasswordRequested);
    on<AuthForgotPasswordRequested>(_onForgotPasswordRequested);
    on<AuthResetPasswordRequested>(_onResetPasswordRequested);
    on<AuthVerifyOtpRequested>(_onVerifyOtpRequested);
    on<AuthResendOtpRequested>(_onResendOtpRequested);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final loginRequest = LoginRequest(
        email: event.email,
        password: event.password,
      );

      final response = await _authRepository.login(loginRequest);

      if (response.isSuccess && response.data != null) {
        emit(AuthAuthenticated(user: response.data!.user));
      } else {
        emit(AuthError(message: response.message ?? 'Login failed'));
      }
    } catch (e) {
      emit(AuthError(message: 'Login failed: ${e.toString()}'));
    }
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final registerRequest = RegisterRequest(
        name: event.name,
        email: event.email,
        password: event.password,
        passwordConfirmation: event.passwordConfirmation,
      );

      final response = await _authRepository.register(registerRequest);

      if (response.isSuccess && response.data != null) {
        emit(AuthAuthenticated(user: response.data!.user));
      } else {
        emit(AuthError(message: response.message ?? 'Registration failed'));
      }
    } catch (e) {
      emit(AuthError(message: 'Registration failed: ${e.toString()}'));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await _authRepository.logout();
      emit(AuthUnauthenticated());
    } catch (e) {
      // Even if logout fails, consider user as logged out
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final isLoggedIn = await _authRepository.isLoggedIn();

      if (isLoggedIn) {
        // First try to get stored user data to avoid unnecessary API calls
        final storedUser = await _authRepository.getStoredUser();

        if (storedUser != null) {
          emit(AuthAuthenticated(user: storedUser));
        } else {
          // If no stored user data, fetch from API
          final response = await _authRepository.getCurrentUser();

          if (response.isSuccess && response.data != null) {
            emit(AuthAuthenticated(user: response.data!));
          } else {
            emit(AuthUnauthenticated());
          }
        }
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onGetUserRequested(
    AuthGetUserRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      // Load user data from local storage instead of API
      final user = await _authRepository.getStoredUser();

      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthError(message: 'No user data found. Please login again.'));
      }
    } catch (e) {
      emit(AuthError(message: 'Failed to load user data: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateProfileRequested(
    AuthUpdateProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state is! AuthAuthenticated) return;

    emit(AuthLoading());

    try {
      final updateRequest = UpdateProfileRequest(
        name: event.name?.isNotEmpty == true ? event.name : null,
        phone: event.phone?.isNotEmpty == true ? event.phone : null,
        // Only include address if it's not empty to avoid server validation issues
        address: (event.address?.isNotEmpty == true) ? event.address : null,
      );

      final response = await _authRepository.updateProfile(updateRequest);

      if (response.isSuccess && response.data != null) {
        emit(AuthAuthenticated(user: response.data!));
        emit(AuthSuccess(message: 'Profile updated successfully'));
      } else {
        emit(AuthError(message: response.message ?? 'Profile update failed'));
      }
    } catch (e) {
      emit(AuthError(message: 'Profile update failed: ${e.toString()}'));
    }
  }

  Future<void> _onChangePasswordRequested(
    AuthChangePasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state is! AuthAuthenticated) return;

    final currentUser = (state as AuthAuthenticated).user;
    emit(AuthLoading());

    try {
      final changePasswordRequest = ChangePasswordRequest(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
        newPasswordConfirmation: event.passwordConfirmation,
      );

      final response = await _authRepository.changePassword(
        changePasswordRequest,
      );

      if (response.isSuccess) {
        emit(AuthAuthenticated(user: currentUser));
        emit(AuthSuccess(message: 'Password changed successfully'));
      } else {
        emit(AuthError(message: response.message ?? 'Password change failed'));
      }
    } catch (e) {
      emit(AuthError(message: 'Password change failed: ${e.toString()}'));
    }
  }

  Future<void> _onForgotPasswordRequested(
    AuthForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final forgotPasswordRequest = ForgotPasswordRequest(email: event.email);

      final response = await _authRepository.forgotPassword(
        forgotPasswordRequest,
      );

      if (response.isSuccess) {
        emit(AuthSuccess(message: 'Password reset email sent successfully'));
      } else {
        emit(AuthError(message: response.message ?? 'Forgot password failed'));
      }
    } catch (e) {
      emit(AuthError(message: 'Forgot password failed: ${e.toString()}'));
    }
  }

  Future<void> _onResetPasswordRequested(
    AuthResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final resetPasswordRequest = ResetPasswordRequest(
        email: event.email,
        token: event.token,
        password: event.password,
        passwordConfirmation: event.passwordConfirmation,
      );

      final response = await _authRepository.resetPassword(
        resetPasswordRequest,
      );

      if (response.isSuccess) {
        emit(AuthSuccess(message: 'Password reset successfully'));
      } else {
        emit(AuthError(message: response.message ?? 'Password reset failed'));
      }
    } catch (e) {
      emit(AuthError(message: 'Password reset failed: ${e.toString()}'));
    }
  }

  Future<void> _onVerifyOtpRequested(
    AuthVerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final response = await _authRepository.verifyEmailWithOtp(event.otp);

      if (response.isSuccess) {
        emit(AuthSuccess(message: 'Email verified successfully'));
      } else {
        emit(AuthError(message: response.message ?? 'OTP verification failed'));
      }
    } catch (e) {
      emit(AuthError(message: 'OTP verification failed: ${e.toString()}'));
    }
  }

  Future<void> _onResendOtpRequested(
    AuthResendOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final response = await _authRepository.resendOtp();

      if (response.isSuccess) {
        emit(AuthSuccess(message: 'OTP sent successfully'));
      } else {
        emit(AuthError(message: response.message ?? 'Failed to resend OTP'));
      }
    } catch (e) {
      emit(AuthError(message: 'Failed to resend OTP: ${e.toString()}'));
    }
  }
}
