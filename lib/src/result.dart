import 'package:meta/meta.dart';

import 'async_result.dart';
import 'unit.dart' as type_unit;

/// Base Result class
///
/// Receives two values [F] and [S]
/// as [F] is an error and [S] is a success.
@sealed
abstract class Result<S extends Object, F extends Object> {
  /// Build a [Result] that returns a [Failure].
  factory Result.success(S s) => Success(s);

  /// Build a [Result] that returns a [Failure].
  factory Result.failure(F e) => Failure(e);

  /// Returns the success value as a throwing expression.
  S getOrThrow();

  /// Returns the encapsulated value if this instance represents `Success`
  /// or the result of `onFailure` function for
  /// the encapsulated a `Failure` value.
  S getOrElse(S Function(F failure) onFailure);

  /// Returns the encapsulated value if this instance represents
  /// `Success` or the `defaultValue` if it is `Failure`.
  S getOrDefault(S defaultValue);

  /// Returns the value of [Success] or null.
  S? getOrNull();

  /// Returns the value of [Failure] or null.
  F? exceptionOrNull();

  /// Returns true if the current result is an [Failure].
  bool isError();

  /// Returns true if the current result is a [Success].
  bool isSuccess();

  /// Returns the result of onSuccess for the encapsulated value
  /// if this instance represents `Success` or the result of onError function
  /// for the encapsulated value if it is `Failure`.
  W fold<W>(
    W Function(S success) onSuccess,
    W Function(F failure) onFailure,
  );

  /// Returns a new `Result`, mapping any `Success` value
  /// using the given transformation.
  Result<W, F> map<W extends Object>(W Function(S success) fn);

  /// Returns a new `Result`, mapping any `Error` value
  /// using the given transformation.
  Result<S, W> mapError<W extends Object>(W Function(F error) fn);

  /// Returns a new `Result`, mapping any `Success` value
  /// using the given transformation and unwrapping the produced `Result`.
  Result<W, F> flatMap<W extends Object>(Result<W, F> Function(S success) fn);

  /// Returns a new `Result`, mapping any `Error` value
  /// using the given transformation and unwrapping the produced `Result`.
  Result<S, W> flatMapError<W extends Object>(
    Result<S, W> Function(F error) fn,
  );

  /// Change the [Success] value.
  Result<W, F> pure<W extends Object>(W success);

  /// Change the [Failure] value.
  Result<S, W> pureError<W extends Object>(W error);

  /// Return a [AsyncResult].
  AsyncResult<S, F> toAsyncResult();

  /// Swap the values contained inside the [Success] and [Failure]
  /// of this [Result].
  Result<F, S> swap();

  /// Returns the encapsulated `Result` of the given transform function
  /// applied to the encapsulated a `Failure` or the original
  /// encapsulated value if it is success.
  Result<S, F> recover(Success<S, F> Function(F failure) onFailure);
}

/// Success Result.
///
/// return it when the result of a [Result] is
/// the expected value.
@immutable
class Success<S extends Object, F extends Object> implements Result<S, F> {
  /// Receives the [S] param as
  /// the successful result.
  const Success(
    this._success,
  );

  /// Build a `Success` with `Unit` value.
  /// ```dart
  /// Success.unit() == Success(unit)
  /// ```
  static Success<type_unit.Unit, F> unit<F extends Object>() {
    return Success<type_unit.Unit, F>(type_unit.unit);
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
    W Function(F error) onFailure,
  ) {
    return onSuccess(_success);
  }

  @override
  F? exceptionOrNull() => null;

  @override
  S getOrNull() => _success;

  @override
  Result<W, F> flatMap<W extends Object>(Result<W, F> Function(S success) fn) {
    return fn(_success);
  }

  @override
  Result<S, W> flatMapError<W extends Object>(
    Result<S, W> Function(F failure) fn,
  ) {
    return Success<S, W>(_success);
  }

  @override
  Result<F, S> swap() {
    return Failure(_success);
  }

  @override
  S getOrThrow() {
    return _success;
  }

  @override
  S getOrElse(S Function(F failure) onFailure) {
    return _success;
  }

  @override
  S getOrDefault(S defaultValue) => _success;

  @override
  Result<W, F> map<W extends Object>(W Function(S success) fn) {
    final newSuccess = fn(_success);
    return Success<W, F>(newSuccess);
  }

  @override
  Result<S, W> mapError<W extends Object>(W Function(F error) fn) {
    return Success<S, W>(_success);
  }

  @override
  Result<W, F> pure<W extends Object>(W success) {
    return map((_) => success);
  }

  @override
  Result<S, W> pureError<W extends Object>(W error) {
    return Success<S, W>(_success);
  }

  @override
  Result<S, F> recover(Success<S, F> Function(F failure) onFailure) {
    return Success<S, F>(_success);
  }

  @override
  AsyncResult<S, F> toAsyncResult() async => this;
}

/// Error Result.
///
/// return it when the result of a [Result] is
/// not the expected value.
@immutable
class Failure<S extends Object, F extends Object> implements Result<S, F> {
  /// Receives the [F] param as
  /// the error result.
  const Failure(this._failure);

  /// Build a `Failure` with `Unit` value.
  /// ```dart
  /// Failure.unit() == Failure(unit)
  /// ```
  static Failure<S, type_unit.Unit> unit<S extends Object>() {
    return Failure<S, type_unit.Unit>(type_unit.unit);
  }

  final F _failure;

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
    W Function(F failure) onFailure,
  ) {
    return onFailure(_failure);
  }

  @override
  F exceptionOrNull() => _failure;

  @override
  S? getOrNull() => null;

  @override
  Result<W, F> flatMap<W extends Object>(Result<W, F> Function(S success) fn) {
    return Failure<W, F>(_failure);
  }

  @override
  Result<S, W> flatMapError<W extends Object>(
    Result<S, W> Function(F failure) fn,
  ) {
    return fn(_failure);
  }

  @override
  Result<F, S> swap() {
    return Success(_failure);
  }

  @override
  S getOrThrow() {
    throw _failure;
  }

  @override
  S getOrElse(S Function(F failure) onFailure) {
    return onFailure(_failure);
  }

  @override
  S getOrDefault(S defaultValue) => defaultValue;

  @override
  Result<W, F> map<W extends Object>(W Function(S success) fn) {
    return Failure<W, F>(_failure);
  }

  @override
  Result<S, W> mapError<W extends Object>(W Function(F failure) fn) {
    final newFailure = fn(_failure);
    return Failure(newFailure);
  }

  @override
  Result<W, F> pure<W extends Object>(W success) {
    return Failure<W, F>(_failure);
  }

  @override
  Result<S, W> pureError<W extends Object>(W error) {
    return mapError((failure) => error);
  }

  @override
  Result<S, F> recover(Success<S, F> Function(F failure) onFailure) {
    return onFailure(_failure);
  }

  @override
  AsyncResult<S, F> toAsyncResult() async => this;
}
