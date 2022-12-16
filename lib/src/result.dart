import 'package:meta/meta.dart';

import 'async_result.dart';
import 'unit.dart' as type_unit;

/// Base Result class
///
/// Receives two values [F] and [S]
/// as [F] is an error and [S] is a success.
@sealed
abstract class Result<S, F> {
  /// Default constructor.
  const Result();

  /// Build a [Result] that returns a [Failure].
  factory Result.success(S s) => Success(s);

  /// Build a [Result] that returns a [Failure].
  factory Result.failure(F e) => Failure(e);

  /// Returns the value of [S] if any.
  S? getOrNull();

  /// Returns the value of [F] if any.
  F? exceptionOrNull();

  /// Returns true if the current result is an [Failure].
  bool isError();

  /// Returns true if the current result is a [Success].
  bool isSuccess();

  /// Return the result in one of these functions.
  ///
  /// if the result is an error, it will be returned in
  /// [whenFailure],
  /// if it is a success it will be returned in [whenSuccess].
  /// <br><br>
  /// Same of `fold`
  W when<W>(
    W Function(S success) whenSuccess,
    W Function(F failure) whenFailure,
  );

  /// Returns the result of onSuccess for the encapsulated value
  /// if this instance represents `Success` or the result of onError function
  /// for the encapsulated value if it is `Failure`.
  W fold<W>(
    W Function(S success) onSuccess,
    W Function(F failure) onFailure,
  ) {
    return when<W>(onSuccess, onFailure);
  }

  /// Returns a new `Result`, mapping any `Success` value
  /// using the given transformation.
  Result<W, F> map<W>(W Function(S success) fn) {
    return when((success) => Success(fn(success)), Failure.new);
  }

  /// Returns a new `Result`, mapping any `Error` value
  /// using the given transformation.
  Result<S, W> mapError<W>(W Function(F error) fn) {
    return when(Success.new, (error) => Failure(fn(error)));
  }

  /// Returns a new `Result`, mapping any `Success` value
  /// using the given transformation and unwrapping the produced `Result`.
  Result<W, F> flatMap<W>(Result<W, F> Function(S success) fn);

  /// Returns a new `Result`, mapping any `Error` value
  /// using the given transformation and unwrapping the produced `Result`.
  Result<S, W> flatMapError<W>(Result<S, W> Function(F error) fn);

  /// Change the [Success] value.
  Result<W, F> pure<W>(W success) {
    return map((_) => success);
  }

  /// Change the [Failure] value.
  Result<S, W> pureError<W>(W error) {
    return mapError((_) => error);
  }

  /// Return a [AsyncResult].
  AsyncResult<S, F> toAsyncResult() async => this;

  /// Swap the values contained inside the [Success] and [Failure]
  /// of this [Result].
  Result<F, S> swap();
}

/// Success Result.
///
/// return it when the result of a [Result] is
/// the expected value.
@immutable
class Success<S, F> extends Result<S, F> {
  /// Receives the [S] param as
  /// the successful result.
  const Success(
    this._success,
  );

  /// Build a `Success` with `Unit` value.
  /// ```dart
  /// Success.unit() == Success(unit)
  /// ```
  static Success<type_unit.Unit, F> unit<F>() {
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
  W when<W>(
    W Function(S success) whenSuccess,
    W Function(F error) whenFailure,
  ) {
    return whenSuccess(_success);
  }

  @override
  F? exceptionOrNull() => null;

  @override
  S getOrNull() => _success;

  @override
  Result<W, F> flatMap<W>(Result<W, F> Function(S success) fn) {
    return fn(_success);
  }

  @override
  Result<S, W> flatMapError<W>(Result<S, W> Function(F failure) fn) {
    return Success<S, W>(_success);
  }

  @override
  Result<F, S> swap() {
    return Failure(_success);
  }
}

/// Error Result.
///
/// return it when the result of a [Result] is
/// not the expected value.
@immutable
class Failure<S, F> extends Result<S, F> {
  /// Receives the [F] param as
  /// the error result.
  const Failure(this._failure);

  /// Build a `Failure` with `Unit` value.
  /// ```dart
  /// Failure.unit() == Failure(unit)
  /// ```
  static Failure<S, type_unit.Unit> unit<S>() {
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
  W when<W>(
    W Function(S succcess) whenSuccess,
    W Function(F failure) whenFailure,
  ) {
    return whenFailure(_failure);
  }

  @override
  F exceptionOrNull() => _failure;

  @override
  S? getOrNull() => null;

  @override
  Result<W, F> flatMap<W>(Result<W, F> Function(S success) fn) {
    return Failure<W, F>(_failure);
  }

  @override
  Result<S, W> flatMapError<W>(Result<S, W> Function(F failure) fn) {
    return fn(_failure);
  }

  @override
  Result<F, S> swap() {
    return Success(_failure);
  }
}
