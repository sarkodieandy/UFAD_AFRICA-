/// App environments: dev, staging, production
enum AppEnvironment { dev, staging, production }

class ApiConfig {
  static const AppEnvironment env = AppEnvironment.production;

  static String get baseUrl {
    switch (env) {
      case AppEnvironment.dev:
        return 'https://dev.ufadafrica.com/api/index.php';
      case AppEnvironment.staging:
        return 'https://staging.ufadafrica.com/api/index.php';
      case AppEnvironment.production:
      return 'https://ufad.ufadafrica.com/api/index.php';
    }
  }

  static const String basicAuth = 'Basic YWRtaW46MTIzNDU2Nzg=';

  static const Map<String, String> defaultHeaders = {
    'Authorization': basicAuth,
    'Content-Type': 'application/json',
  };
}

class ApiEndpoints {
  // Auth
  static const String signup = '/signup';
  static const String login = '/login';

  // Dashboard
  static const String dashboard = '/dashboard';

  // Resources
  static const String sales = '/sales';
  static const String transactions = '/transactions';
  static const String suppliers = '/suppliers';
  static const String products = '/products';
  static const String categories = '/categories';
}
