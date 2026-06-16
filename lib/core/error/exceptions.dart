class ServerException implements Exception {
  const ServerException([this.message = 'Server error occurred']);

  final String message;
}

class CacheException implements Exception {
  const CacheException([this.message = 'Cache error occurred']);

  final String message;
}

class NetworkException implements Exception {
  const NetworkException([this.message = 'No internet connection']);

  final String message;
}

class AuthException implements Exception {
  const AuthException([this.message = 'Authentication failed']);

  final String message;
}

class ValidationException implements Exception {
  const ValidationException([this.message = 'Validation failed']);

  final String message;
}

class SyncException implements Exception {
  const SyncException([this.message = 'Sync failed']);

  final String message;
}
