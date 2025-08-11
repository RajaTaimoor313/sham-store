class User {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? zipCode;
  final String? dateOfBirth;
  final String? gender;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final String role;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
    this.address,
    this.city,
    this.state,
    this.country,
    this.zipCode,
    this.dateOfBirth,
    this.gender,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.role,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      avatar: json['avatar'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      zipCode: json['zip_code'],
      dateOfBirth: json['date_of_birth'],
      gender: json['gender'],
      isEmailVerified:
          json['email_verified_at'] != null ||
          json['is_email_verified'] == true,
      isPhoneVerified:
          json['phone_verified_at'] != null ||
          json['is_phone_verified'] == true,
      role: json['role'] ?? 'customer',
      status: json['status'] ?? 'active',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'zip_code': zipCode,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'is_email_verified': isEmailVerified,
      'is_phone_verified': isPhoneVerified,
      'role': role,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Helper getters
  String get displayName => name.isNotEmpty ? name : email.split('@').first;
  String get initials {
    if (name.isEmpty) return email.substring(0, 1).toUpperCase();
    final names = name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }

  String get fullAddress {
    final parts = [
      address,
      city,
      state,
      country,
      zipCode,
    ].where((part) => part != null && part.isNotEmpty).toList();
    return parts.join(', ');
  }

  bool get isActive => status.toLowerCase() == 'active';
  bool get isCustomer => role.toLowerCase() == 'customer';
  bool get isSeller => role.toLowerCase() == 'seller';
  bool get isAdmin => role.toLowerCase() == 'admin';

  // Copy with method
  User copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? avatar,
    String? address,
    String? city,
    String? state,
    String? country,
    String? zipCode,
    String? dateOfBirth,
    String? gender,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    String? role,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      zipCode: zipCode ?? this.zipCode,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      role: role ?? this.role,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// Authentication Response Model
class AuthResponse {
  final User user;
  final String accessToken;
  final String? refreshToken;
  final String tokenType;
  final int? expiresIn;

  AuthResponse({
    required this.user,
    required this.accessToken,
    this.refreshToken,
    required this.tokenType,
    this.expiresIn,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    // Handle nested response structure: {success: true, data: {token: "...", user: {...}}}
    final data = json['data'] ?? json;
    
    return AuthResponse(
      user: User.fromJson(data['user'] ?? {}),
      accessToken: data['access_token'] ?? data['token'] ?? '',
      refreshToken: data['refresh_token'],
      tokenType: data['token_type'] ?? 'Bearer',
      expiresIn: data['expires_in'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'token_type': tokenType,
      'expires_in': expiresIn,
    };
  }

  String get authorizationHeader => '$tokenType $accessToken';
  String get token => accessToken;
}

// Login Request Model
class LoginRequest {
  final String email;
  final String password;
  final bool rememberMe;

  LoginRequest({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password, 'remember_me': rememberMe};
  }
}

// Register Request Model
class RegisterRequest {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;
  final String? phone;
  final String? dateOfBirth;
  final String? gender;
  final bool agreeToTerms;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    this.phone,
    this.dateOfBirth,
    this.gender,
    this.agreeToTerms = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'phone': phone,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'agree_to_terms': agreeToTerms,
    };
  }
}

// Change Password Request Model
class ChangePasswordRequest {
  final String currentPassword;
  final String newPassword;
  final String newPasswordConfirmation;

  ChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
    required this.newPasswordConfirmation,
  });

  Map<String, dynamic> toJson() {
    return {
      'current_password': currentPassword,
      'new_password': newPassword,
      'new_password_confirmation': newPasswordConfirmation,
    };
  }
}

// Forgot Password Request Model
class ForgotPasswordRequest {
  final String email;
  final String? phone;

  ForgotPasswordRequest({required this.email, this.phone});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phone': phone ?? '',
    };
  }
}

// Reset Password Request Model
class ResetPasswordRequest {
  final String email;
  final String pin;
  final String password;
  final String passwordConfirmation;

  ResetPasswordRequest({
    required this.email,
    required this.pin,
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'pin': pin,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
  }
}

// Update Profile Request Model
class UpdateProfileRequest {
  final String? name;
  final String? phone;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? zipCode;
  final String? dateOfBirth;
  final String? gender;

  UpdateProfileRequest({
    this.name,
    this.phone,
    this.address,
    this.city,
    this.state,
    this.country,
    this.zipCode,
    this.dateOfBirth,
    this.gender,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (name != null) data['name'] = name;
    if (phone != null) data['phone'] = phone;
    if (address != null) data['address'] = address;
    if (city != null) data['city'] = city;
    if (state != null) data['state'] = state;
    if (country != null) data['country'] = country;
    if (zipCode != null) data['zip_code'] = zipCode;
    if (dateOfBirth != null) data['date_of_birth'] = dateOfBirth;
    if (gender != null) data['gender'] = gender;
    return data;
  }
}
