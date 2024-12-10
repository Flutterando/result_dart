import 'package:meta/meta.dart';

import 'async_result.dart';
import 'unit.dart' as type_unit;

/// Base Result class
///
/// Receives two values [F] and [S]
/// as [F] is an error and [S] is a success.
@sealed
abstract class Result<S extends Object> {
  /// Build a [Result] that returns a [Failure].
  const factory Result.success(S s) = Success;

  /// Build a [Result] that returns a [Failure].
  const factory Result.failure(Object e) = Failure;

  /// Returns the success value as a throwing expression.
  S getOrThrow();

  /// Returns the encapsulated value if this instance represents `Success`
  /// or the result of `onFailure` function for
  /// the encapsulated a `Failure` value.
  S getOrElse(S Function(Object failure) onFailure);

  /// Returns the encapsulated value if this instance represents
  /// `Success` or the `defaultValue` if it is `Failure`.
  S getOrDefault(S defaultValue);

  /// Returns the value of [Success] or null.
  S? getOrNull();

  /// Returns the value of [Failure] or null.
  Object? exceptionOrNull();

  /// Returns true if the current result is an [Failure].
  bool isError();

  /// Returns true if the current result is a [Success].
  bool isSuccess();

  /// Returns the result of onSuccess for the encapsulated value
  /// if this instance represents `Success` or the result of onError function
  /// for the encapsulated value if it is `Failure`.
  W fold<W>(
    W Function(S success) onSuccess,
    W Function(Object failure) onFailure,
  );

  /// Performs the given action on the encapsulated value if this
  /// instance represents success. Returns the original Result unchanged.
  Result<S> onSuccess(
    void Function(S success) onSuccess,
  );

  /// Performs the given action on the encapsulated Throwable
  /// exception if this instance represents failure.
  /// Returns the original Result unchanged.
  Result<S> onFailure(
    void Function(Object failure) onFailure,
  );

  /// Returns a new `Result`, mapping any `Success` value
  /// using the given transformation.
  Result<W> map<W extends Object>(W Function(S success) fn);

  /// Returns a new `Result`, mapping any `Error` value
  /// using the given transformation.
  Result<S> mapError<W extends Object>(W Function(Object error) fn);

  /// Returns a new `Result`, mapping any `Success` value
  /// using the given transformation and unwrapping the produced `Result`.
  Result<W> flatMap<W extends Object>(Result<W> Function(S success) fn);

  /// Returns a new `Result`, mapping any `Error` value
  /// using the given transformation and unwrapping the produced `Result`.
  Result<S> flatMapError<W extends Object>(
    Result<S> Function(Object error) fn,
  );

  /// Change the [Success] value.
  Result<W> pure<W extends Object>(W success);

  /// Change the [Failure] value.
  Result<S> pureError<W extends Object>(W error);

  /// Return a [AsyncResult].
  AsyncResult<S> toAsyncResult();

  /// Returns the encapsulated `Result` of the given transform function
  /// applied to the encapsulated a `Failure` or the original
  /// encapsulated value if it is success.
  Result<S> recover<R extends Object>(
    Result<S> Function(Object failure) onFailure,
  );
}

/// Success Result.
///
/// return it when the result of a [Result] is
/// the expected value.
@immutable
class Success<S extends Object> implements Result<S> {
  /// Receives the [S] param as
  /// the successful result.
  const Success(
    this._success,
  );

  /// Build a `Success` with `Unit` value.
  /// ```dart
  /// Success.unit() == Success(unit)
  /// ```
  static Success<type_unit.Unit> unit() {
    return const Success<type_unit.Unit>(type_unit.unit);
  }

  final S _success;

  @override
  bool isError() => false;

  @override
  bool isSuccess() => true;

  @override
  int get hashCode => _success.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Success && other._success == _success;
  }

  @override
  W fold<W>(
    W Function(S success) onSuccess,
    W Function(Object error) onFailure,
  ) {
    return onSuccess(_success);
  }

  @override
  Object? exceptionOrNull() => null;

  @override
  S getOrNull() => _success;

  @override
  Result<W> flatMap<W extends Object>(Result<W> Function(S success) fn) {
    return fn(_success);
  }

  @override
  Result<S> flatMapError<W extends Object>(
    Result<S> Function(Object failure) fn,
  ) {
    return Success<S>(_success);
  }

  @override
  S getOrThrow() {
    return _success;
  }

  @override
  S getOrElse(S Function(Object failure) onFailure) {
    return _success;
  }

  @override
  S getOrDefault(S defaultValue) => _success;

  @override
  Result<W> map<W extends Object>(W Function(S success) fn) {
    final newSuccess = fn(_success);
    return Success<W>(newSuccess);
  }

  @override
  Result<S> mapError<W extends Object>(W Function(Object error) fn) {
    return Success<S>(_success);
  }

  @override
  Result<W> pure<W extends Object>(W success) {
    return map((_) => success);
  }

  @override
  Result<S> pureError<W extends Object>(W error) {
    return Success<S>(_success);
  }

  @override
  Result<S> recover<R extends Object>(
    Result<S> Function(Object failure) onFailure,
  ) {
    return Success(_success);
  }

  @override
  AsyncResult<S> toAsyncResult() async => this;

  @override
  Result<S> onFailure(void Function(Object failure) onFailure) {
    return this;
  }

  @override
  Result<S> onSuccess(void Function(S success) onSuccess) {
    onSuccess(_success);
    return this;
  }
}

/// Error Result.
///
/// return it when the result of a [Result] is
/// not the expected value.
@immutable
class Failure<S extends Object> implements Result<S> {
  /// Receives the [F] param as
  /// the error result.
  const Failure(this._failure);

  final Object _failure;

  @override
  bool isError() => true;

  @override
  bool isSuccess() => false;

  @override
  int get hashCode => _failure.hashCode;

  @override
  bool operator ==(Object other) => //
      other is Failure && other._failure == _failure;

  @override
  W fold<W>(
    W Function(S succcess) onSuccess,
    W Function(Object failure) onFailure,
  ) {
    return onFailure(_failure);
  }

  @override
  Object exceptionOrNull() => _failure;

  @override
  S? getOrNull() => null;

  @override
  Result<W> flatMap<W extends Object>(Result<W> Function(S success) fn) {
    return Failure<W>(_failure);
  }

  @override
  Result<S> flatMapError<W extends Object>(
    Result<S> Function(Object failure) fn,
  ) {
    return fn(_failure);
  }

  @override
  S getOrThrow() {
    throw _failure;
  }

  @override
  S getOrElse(S Function(Object failure) onFailure) {
    return onFailure(_failure);
  }

  @override
  S getOrDefault(S defaultValue) => defaultValue;

  @override
  Result<W> map<W extends Object>(W Function(S success) fn) {
    return Failure<W>(_failure);
  }

  @override
  Result<S> mapError<W extends Object>(W Function(Object failure) fn) {
    final newFailure = fn(_failure);
    return Failure(newFailure);
  }

  @override
  Result<W> pure<W extends Object>(W success) {
    return Failure<W>(_failure);
  }

  @override
  Result<S> pureError<W extends Object>(W error) {
    return mapError((failure) => error);
  }

  @override
  Result<S> recover<R extends Object>(
    Result<S> Function(Object failure) onFailure,
  ) {
    return onFailure(_failure);
  }

  @override
  AsyncResult<S> toAsyncResult() async => this;

  @override
  Result<S> onFailure(void Function(Object failure) onFailure) {
    onFailure(_failure);
    return this;
  }

  @override
  Result<S> onSuccess(void Function(S success) onSuccess) {
    return this;
  }
}
