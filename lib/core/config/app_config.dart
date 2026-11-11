enum Environment { development, staging, production }

class AppConfig {
  AppConfig._();

  static Environment _environment = Environment.development;

  static Environment get environment => _environment;

  static void setEnvironment(Environment env) {
    _environment = env;
  }

  static String get apiBaseUrl {
    switch (_environment) {
      case Environment.development:
        return 'http://10.0.2.2:8080/api/v1';
      case Environment.staging:
        return 'https://staging-api.memorywars.com/api/v1';
      case Environment.production:
        return 'https://api.memorywars.com/api/v1';
    }
  }

  static String get apiBaseUrlIos {
    switch (_environment) {
      case Environment.development:
        return 'http://localhost:8080/api/v1';
      default:
        return apiBaseUrl;
    }
  }

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
