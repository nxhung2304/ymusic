class FirestoreException implements Exception {
  const FirestoreException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => 'FirestoreException: $message${cause != null ? ' (cause: $cause)' : ''}';
}
