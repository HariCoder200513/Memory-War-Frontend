class RegisterRequest {
  final String email;
  final String password;

  RegisterRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final UserProfile user;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      user: UserProfile.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

class UserProfile {
  final String id;
  final String email;
  final String? username;
  final String avatar;
  final bool emailVerified;

  UserProfile({
    required this.id,
    required this.email,
    this.username,
    this.avatar = 'orbit',
    required this.emailVerified,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String?,
      avatar: json['avatar'] as String? ?? 'orbit',
      emailVerified: json['email_verified'] as bool? ?? false,
    );
  }

  UserProfile copyWith({String? username, String? avatar, bool? emailVerified}) {
    return UserProfile(
      id: id,
      email: email,
      username: username ?? this.username,
      avatar: avatar ?? this.avatar,
      emailVerified: emailVerified ?? this.emailVerified,
    );
  }
}

class ForgotPasswordRequest {
  final String email;

  ForgotPasswordRequest({required this.email});

  Map<String, dynamic> toJson() => {'email': email};
}

class ResetPasswordRequest {
  final String token;
  final String password;

  ResetPasswordRequest({required this.token, required this.password});

  Map<String, dynamic> toJson() => {'token': token, 'password': password};
}

class GoogleAuthRequest {
  final String idToken;

  GoogleAuthRequest({required this.idToken});

  Map<String, dynamic> toJson() => {'id_token': idToken};
}

class VerifyEmailResponse {
  final bool verified;

  VerifyEmailResponse({required this.verified});

  factory VerifyEmailResponse.fromJson(Map<String, dynamic> json) {
    return VerifyEmailResponse(verified: json['verified'] as bool? ?? false);
  }
}
