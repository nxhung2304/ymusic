sealed class AppFailure {
  final String message;

  const AppFailure(this.message);
}

class NetworkFailure extends AppFailure {
  const NetworkFailure(super.message);
}

class ServerFailure extends AppFailure {
  const ServerFailure(super.message);
}

class UnauthorizedFailure extends AppFailure {
  const UnauthorizedFailure(super.message);
}

class NotFoundFailure extends AppFailure {
  const NotFoundFailure(super.message);
}

class FirebaseFailure extends AppFailure {
  const FirebaseFailure(super.message);
}

class SessionExpiredFailure extends AppFailure {
  const SessionExpiredFailure(super.message);
}
