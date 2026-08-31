abstract class AppException implements Exception {
  final String message;
  AppException(this.message);
}

class NetworkException extends AppException {
  NetworkException()
    : super('No internet connection. Please check your connection.');
}

class ApiException extends AppException {
  ApiException()
    : super('Something went wrong while connecting to the server.');
}

class InvalidResponseException extends AppException {
  InvalidResponseException() : super('The server returned invalid data.');
}

class EmptyMoviesException extends AppException {
  EmptyMoviesException() : super('No movies found.');
}

class AuthException extends AppException {
  AuthException(super.message);
}

class InvalidCredentialsException extends AppException {
  InvalidCredentialsException() : super('Invalid email or password.');
}

class DatabaseException extends AppException {
  DatabaseException()
    : super('Something went wrong while accessing the database.');
}
