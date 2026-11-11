import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Environment { development, staging, production }

class AppConfig {
  AppConfig._();

  static Environment get environment {
    final env = dotenv.env['ENVIRONMENT'] ?? 'development';
    switch (env) {
      case 'staging':
        return Environment.staging;
      case 'production':
        return Environment.production;
      default:
        return Environment.development;
    }
  }

  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://10.0.2.2:8080/api/v1';

  static String get apiBaseUrlIos =>
      dotenv.env['API_BASE_URL_IOS'] ?? 'http://localhost:8080/api/v1';

  static String get googleClientId =>
      dotenv.env['GOOGLE_CLIENT_ID'] ?? '';

  static Duration get connectionTimeout => Duration(
        seconds: int.tryParse(dotenv.env['CONNECTION_TIMEOUT'] ?? '30') ?? 30,
      );

  static Duration get receiveTimeout => Duration(
        seconds: int.tryParse(dotenv.env['RECEIVE_TIMEOUT'] ?? '30') ?? 30,
      );
}
