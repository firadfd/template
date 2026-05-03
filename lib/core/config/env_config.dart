enum Environment { dev, staging, prod }

class EnvConfig {
  static Environment environment = Environment.dev;

  static String get baseUrl {
    switch (environment) {
      case Environment.dev:
        return 'https://jsonplaceholder.typicode.com';
      case Environment.staging:
        return 'https://staging.api.com';
      case Environment.prod:
        return 'https://api.production.com';
    }
  }

  static bool get isDev => environment == Environment.dev;
  static bool get isProd => environment == Environment.prod;
}
