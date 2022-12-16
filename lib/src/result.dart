import 'package:meta/meta.dart';

import 'async_result.dart';
import 'unit.dart' as type_unit;

/// Base Result class
///
/// Receives two values [E] and [S]
/// as [E] is an error and [S] is a success.
@sealed
abstract class Result<S, E> {
  /// Default constructor.
  const Result();

  /// Build a [Result] that returns a [Error].
  factory Result.success(S s) => Success(s);

  /// Build a [Result] that returns a [Error].
  factory Result.error(E e) => Error(e);

  /// Returns the value of [S] if any.
  S? tryGetSuccess();

  /// Returns the value of [E] if any.
  E? tryGetError();

  /// Returns true if the current result is an [Error].
  bool isError();

  /// Returns true if the current result is a [Success].
  bool isSuccess();

  /// Return the result in one of these functions.
  ///
  /// if the result is an error, it will be returned in
  /// [whenError],
  /// if it is a success it will be returned in [whenSuccess].
  /// <br><br>
  /// Same of `fold`
  W when<W>(
    W Function(S success) whenSuccess,
    W Function(E error) whenError,
  );

  /// Returns the result of onSuccess for the encapsulated value
  /// if this instance represents `Success` or the result of onError function
  /// for the encapsulated value if it is `Error`.
  /// <br><br>
  /// Same of `when`
  W fold<W>(
    W Function(S success) onSuccess,
    W Function(E error) onError,
  ) {
    return when<W>(onSuccess, onError);
  }

  /// Execute [whenSuccess] if the [Result] is a success.
  W? onSuccess<W>(
    W Function(S success) whenSuccess,
  );

  /// Execute [whenError] if the [Result] is an error.
  W? onError<W>(
    W Function(E error) whenError,
  );

  /// Returns a new `Result`, mapping any `Success` value
  /// using the given transformation.
  Result<W, E> map<W>(W Function(S success) fn) {
    return when((success) => Success(fn(success)), Error.new);
  }

  /// Returns a new `Result`, mapping any `Error` value
  /// using the given transformation.
  Result<S, W> mapError<W>(W Function(E error) fn) {
    return when(Success.new, (error) => Error(fn(error)));
  }

  /// Returns a new `Result`, mapping any `Success` value
  /// using the given transformation and unwrapping the produced `Result`.
  Result<W, E> flatMap<W>(Result<W, E> Function(S success) fn);

  /// Returns a new `Result`, mapping any `Error` value
  /// using the given transformation and unwrapping the produced `Result`.
  Result<S, W> flatMapError<W>(Result<S, W> Function(E error) fn);

  /// Change the [Success] value.
  Result<W, E> pure<W>(W success) {
    return map((_) => success);
  }

  /// Change the [Error] value.
  Result<S, W> pureError<W>(W error) {
    return mapError((_) => error);
  }

  /// Return a [AsyncResult].
  AsyncResult<S, E> toAsyncResult() async => this;

  /// Swap the values contained inside the [Success] and [Error]
  /// of this [Result].
  Result<E, S> swap();
}

/// Success Result.
///
/// return it when the result of a [Result] is
/// the expected value.
@immutable
class Success<S, E> extends Result<S, E> {
  /// Receives the [S] param as
  /// the successful result.
  const Success(
    this._success,
  );

  /// Build a `Success` with `Unit` value.
  /// ```dart
  /// Success.unit() == Success(unit)
  /// ```
  static Success<type_unit.Unit, E> unit<E>() {
    return Success<type_unit.Unit, E>(type_unit.unit);
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
  W when<W>(
    W Function(S success) whenSuccess,
    W Function(E error) whenError,
  ) {
    return whenSuccess(_success);
  }

  @override
  E? tryGetError() => null;

  @override
  S tryGetSuccess() => _success;

  @override
  R? onError<R>(R Function(E error) whenError) => null;

  @override
  R onSuccess<R>(R Function(S success) whenSuccess) {
    return whenSuccess(_success);
  }

  @override
  Result<W, E> flatMap<W>(Result<W, E> Function(S success) fn) {
    return fn(_success);
  }

  @override
  Result<S, W> flatMapError<W>(Result<S, W> Function(E error) fn) {
    return Success<S, W>(_success);
  }

  @override
  Result<E, S> swap() {
    return Error(_success);
  }
}

/// Error Result.
///
/// return it when the result of a [Result] is
/// not the expected value.
@immutable
class Error<S, E> extends Result<S, E> {
  /// Receives the [E] param as
  /// the error result.
  const Error(this._error);

  /// Build a `Error` with `Unit` value.
  /// ```dart
  /// Error.unit() == Error(unit)
  /// ```
  static Error<S, type_unit.Unit> unit<S>() {
    return Error<S, type_unit.Unit>(type_unit.unit);
  }

  final E _error;

  @override
  bool isError() => true;

  @override
  bool isSuccess() => false;

  @override
  int get hashCode => _error.hashCode;

  @override
  bool operator ==(Object other) => other is Error && other._error == _error;

  @override
  W when<W>(
    W Function(S succcess) whenSuccess,
    W Function(E error) whenError,
  ) {
    return whenError(_error);
  }

  @override
  E tryGetError() => _error;

  @override
  S? tryGetSuccess() => null;

  @override
  R onError<R>(R Function(E error) whenError) => whenError(_error);

  @override
  R? onSuccess<R>(R Function(S success) whenSuccess) => null;

  @override
  Result<W, E> flatMap<W>(Result<W, E> Function(S success) fn) {
    return Error<W, E>(_error);
  }

  @override
  Result<S, W> flatMapError<W>(Result<S, W> Function(E error) fn) {
    return fn(_error);
  }

  @override
  Result<E, S> swap() {
    return Success(_error);
  }
}
