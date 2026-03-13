// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authDatasourceHash() => r'4d3fb5a3ec3b4ccf5c3ee8e15c5421d51db9615b';

/// Provides a singleton instance of [AuthDatasource]
///
/// Copied from [authDatasource].
@ProviderFor(authDatasource)
final authDatasourceProvider = AutoDisposeProvider<AuthDatasource>.internal(
  authDatasource,
  name: r'authDatasourceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$authDatasourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthDatasourceRef = AutoDisposeProviderRef<AuthDatasource>;
String _$authStateHash() => r'c453418ae685467cc406f5e92142f623e14d854c';

/// Provides a stream of auth state changes
/// Emits [User?] whenever authentication state changes (login/logout)
///
/// Copied from [authState].
@ProviderFor(authState)
final authStateProvider = AutoDisposeStreamProvider<User?>.internal(
  authState,
  name: r'authStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthStateRef = AutoDisposeStreamProviderRef<User?>;
String _$currentUserHash() => r'ab87a355dd423d79a81ba656f9396a458ad8ed84';

/// Provides the current authenticated user
/// Returns null if user is not logged in, otherwise returns the [User] object
///
/// Copied from [currentUser].
@ProviderFor(currentUser)
final currentUserProvider = AutoDisposeProvider<User?>.internal(
  currentUser,
  name: r'currentUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserRef = AutoDisposeProviderRef<User?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
