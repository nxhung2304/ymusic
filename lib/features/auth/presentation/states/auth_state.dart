import 'package:ymusic/features/auth/domain/entities/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ymusic/core/error/failures.dart';

part 'auth_state.freezed.dart';

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;

  const factory AuthState.loading() = _Loading;

  const factory AuthState.success(User user) = _Success;

  const factory AuthState.error(Failure failure) = _Error;
}
