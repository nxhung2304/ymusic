// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authStateStreamHash() => r'77b4eb55065298ab247af6598ba2711aa266641d';

/// Watch auth state changes
///
/// Copied from [authStateStream].
@ProviderFor(authStateStream)
final authStateStreamProvider = AutoDisposeStreamProvider<User?>.internal(
  authStateStream,
  name: r'authStateStreamProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$authStateStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthStateStreamRef = AutoDisposeStreamProviderRef<User?>;
String _$checkSessionHash() => r'80d6d40ffc0ecda48f5366e56845ae502b1e511d';

/// Check session on app startup (one-time check)
///
/// Copied from [checkSession].
@ProviderFor(checkSession)
final checkSessionProvider = AutoDisposeFutureProvider<User?>.internal(
  checkSession,
  name: r'checkSessionProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$checkSessionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CheckSessionRef = AutoDisposeFutureProviderRef<User?>;
String _$currentUserHash() => r'443290a896aa75a31606fdcf2b38489340d61272';

/// Current authenticated user
///
/// Copied from [currentUser].
@ProviderFor(currentUser)
final currentUserProvider = AutoDisposeStreamProvider<User?>.internal(
  currentUser,
  name: r'currentUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserRef = AutoDisposeStreamProviderRef<User?>;
String _$signInNotifierHash() => r'533f9348813b96cc134f76d04960e379cf5d1b88';

/// Sign in with Google
///
/// Copied from [SignInNotifier].
@ProviderFor(SignInNotifier)
final signInNotifierProvider =
    AutoDisposeNotifierProvider<SignInNotifier, AsyncValue<User?>>.internal(
      SignInNotifier.new,
      name: r'signInNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$signInNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SignInNotifier = AutoDisposeNotifier<AsyncValue<User?>>;
String _$signOutNotifierHash() => r'cb369e6f7c198319e76bb72d68740b1c12a546db';

/// Sign out
///
/// Copied from [SignOutNotifier].
@ProviderFor(SignOutNotifier)
final signOutNotifierProvider =
    AutoDisposeNotifierProvider<SignOutNotifier, AsyncValue<void>>.internal(
      SignOutNotifier.new,
      name: r'signOutNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$signOutNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SignOutNotifier = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
