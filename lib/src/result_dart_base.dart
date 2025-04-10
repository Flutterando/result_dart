import 'package:meta/meta.dart';
import 'package:result_dart/result_dart.dart';

import 'unit.dart' as type_unit;

/// Base Result class
///
/// Receives two values [F] and [S]
/// as [F] is an error and [S] is a success.
sealed class ResultDart<S extends Object, F extends Object> {
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

  /// Performs the given action on the encapsulated value if this
  /// instance represents success. Returns the original Result unchanged.
  ResultDart<S, F> onSuccess(
    void Function(S success) onSuccess,
  );

  /// Performs the given action on the encapsulated Throwable
  /// exception if this instance represents failure.
  /// Returns the original Result unchanged.
  ResultDart<S, F> onFailure(
    void Function(F failure) onFailure,
  );

  /// Returns a new `Result`, mapping any `Success` value
  /// using the given transformation.
  ResultDart<W, F> map<W extends Object>(W Function(S success) fn);

  /// Returns a new `Result`, mapping any `Error` value
  /// using the given transformation.
  ResultDart<S, W> mapError<W extends Object>(W Function(F error) fn);

  /// Returns a new `Result`, mapping any `Success` value
  /// using the given transformation and unwrapping the produced `Result`.
  ResultDart<W, F> flatMap<W extends Object>(
    ResultDart<W, F> Function(S success) fn,
  );

  /// Returns a new `Result`, mapping any `Error` value
  /// using the given transformation and unwrapping the produced `Result`.
  ResultDart<S, W> flatMapError<W extends Object>(
    ResultDart<S, W> Function(F error) fn,
  );

  /// Change the [Success] value.
  ResultDart<W, F> pure<W extends Object>(W success);

  /// Change the [Failure] value.
  ResultDart<S, W> pureError<W extends Object>(W error);

  /// Return a [AsyncResult].
  AsyncResultDart<S, F> toAsyncResult();

  /// Swap the values contained inside the [Success] and [Failure]
  /// of this [Result].
  ResultDart<F, S> swap();

  /// Returns the encapsulated `Result` of the given transform function
  /// applied to the encapsulated a `Failure` or the original
  /// encapsulated value if it is success.
  ResultDart<S, R> recover<R extends Object>(
    ResultDart<S, R> Function(F failure) onFailure,
  );

  /// Returns a new `Result`, mapping any `Success` value
  /// using the given transformation and unwrapping the produced `Result`.
  /// Returns a new `Result`, mapping any `Error` value
  /// using the given transformation and unwrapping the produced `Result`.
  ResultDart<G, W> pureFold<G extends Object, W extends Object>(
    G success,
    W failure,
  );

  /// Returns a new `Result`, mapping any `Success` value
  /// using the given transformation and unwrapping the produced `Result`.
  /// Returns a new `Result`, mapping any `Error` value
  /// using the given transformation and unwrapping the produced `Result`.
  ResultDart<G, W> mapFold<G extends Object, W extends Object>(
    G Function(S success) onSuccess,
    W Function(F failure) onFailure,
  );
}

/// Success Result.
///
/// return it when the result of a [Result] is
/// the expected value.
@immutable
final class Success<S extends Object, F extends Object> //
    implements
        ResultDart<S, F> {
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
  ResultDart<W, F> flatMap<W extends Object>(
    ResultDart<W, F> Function(S success) fn,
  ) {
    return fn(_success);
  }

  @override
  ResultDart<S, W> flatMapError<W extends Object>(
    ResultDart<S, W> Function(F failure) fn,
  ) {
    return Success<S, W>(_success);
  }

  @override
  ResultDart<F, S> swap() {
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
  ResultDart<W, F> map<W extends Object>(W Function(S success) fn) {
    final newSuccess = fn(_success);
    return Success<W, F>(newSuccess);
  }

  @override
  ResultDart<S, W> mapError<W extends Object>(W Function(F error) fn) {
    return Success<S, W>(_success);
  }

  @override
  ResultDart<W, F> pure<W extends Object>(W success) {
    return map((_) => success);
  }

  @override
  ResultDart<S, W> pureError<W extends Object>(W error) {
    return Success<S, W>(_success);
  }

  @override
  ResultDart<S, R> recover<R extends Object>(
    ResultDart<S, R> Function(F failure) onFailure,
  ) {
    return Success(_success);
  }

  @override
  AsyncResultDart<S, F> toAsyncResult() async => this;

  @override
  ResultDart<S, F> onFailure(void Function(F failure) onFailure) {
    return this;
  }

  @override
  ResultDart<S, F> onSuccess(void Function(S success) onSuccess) {
    onSuccess(_success);
    return this;
  }

  @override
  ResultDart<G, W> mapFold<G extends Object, W extends Object>(
    G Function(S success) onSuccess,
    W Function(F failure) onFailure,
  ) {
    return fold(
      (s) => Success(onSuccess(s)),
      (f) => Failure(onFailure(f)),
    );
  }

  @override
  ResultDart<G, W> pureFold<G extends Object, W extends Object>(
    G success,
    W failure,
  ) {
    return fold(
      (s) => Success(success),
      (f) => Failure(failure),
    );
  }
}

/// Error Result.
///
/// return it when the result of a [ResultDart] is
/// not the expected value.
@immutable
final class Failure<S extends Object, F extends Object> //
    implements
        ResultDart<S, F> {
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
  ResultDart<W, F> flatMap<W extends Object>(
    ResultDart<W, F> Function(S success) fn,
  ) {
    return Failure<W, F>(_failure);
  }

  @override
  ResultDart<S, W> flatMapError<W extends Object>(
    ResultDart<S, W> Function(F failure) fn,
  ) {
    return fn(_failure);
  }

  @override
  ResultDart<F, S> swap() {
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
  ResultDart<W, F> map<W extends Object>(W Function(S success) fn) {
    return Failure<W, F>(_failure);
  }

  @override
  ResultDart<S, W> mapError<W extends Object>(W Function(F failure) fn) {
    final newFailure = fn(_failure);
    return Failure(newFailure);
  }

  @override
  ResultDart<W, F> pure<W extends Object>(W success) {
    return Failure<W, F>(_failure);
  }

  @override
  ResultDart<S, W> pureError<W extends Object>(W error) {
    return mapError((failure) => error);
  }

  @override
  ResultDart<S, R> recover<R extends Object>(
    ResultDart<S, R> Function(F failure) onFailure,
  ) {
    return onFailure(_failure);
  }

  @override
  AsyncResultDart<S, F> toAsyncResult() async => this;

  @override
  ResultDart<S, F> onFailure(void Function(F failure) onFailure) {
    onFailure(_failure);
    return this;
  }

  @override
  ResultDart<S, F> onSuccess(void Function(S success) onSuccess) {
    return this;
  }

  @override
  ResultDart<G, W> mapFold<G extends Object, W extends Object>(
    G Function(S success) onSuccess,
    W Function(F failure) onFailure,
  ) {
    return fold(
      (s) => Success(onSuccess(s)),
      (f) => Failure(onFailure(f)),
    );
  }

  @override
  ResultDart<G, W> pureFold<G extends Object, W extends Object>(
    G success,
    W failure,
  ) {
    return fold(
      (s) => Success(success),
      (f) => Failure(failure),
    );
  }
}
