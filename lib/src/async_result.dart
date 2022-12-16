import 'dart:async';

import '../result_dart.dart';

/// `AsyncResult<S, E>` represents an asynchronous computation.
typedef AsyncResult<S extends Object, F extends Object> = Future<Result<S, F>>;

/// `AsyncResult<S, E>` represents an asynchronous computation.
extension AsyncResultExtension<S extends Object, F extends Object>
    on AsyncResult<S, F> {
  /// Returns a new `Result`, mapping any `Success` value
  /// using the given transformation and unwrapping the produced `Result`.
  AsyncResult<W, F> flatMap<W extends Object>(
      FutureOr<Result<W, F>> Function(S success) fn) {
    return then((result) => result.when(fn, Failure.new));
  }

  /// Returns a new `Result`, mapping any `Error` value
  /// using the given transformation and unwrapping the produced `Result`.
  AsyncResult<S, W> flatMapError<W extends Object>(
    FutureOr<Result<S, W>> Function(F error) fn,
  ) {
    return then((result) => result.when(Success.new, fn));
  }

  /// Returns a new `AsyncResult`, mapping any `Success` value
  /// using the given transformation.
  AsyncResult<W, F> map<W extends Object>(W Function(S success) fn) {
    return then((result) => result.map(fn));
  }

  /// Returns a new `Result`, mapping any `Error` value
  /// using the given transformation.
  AsyncResult<S, W> mapError<W extends Object>(W Function(F error) fn) {
    return then((result) => result.mapError(fn));
  }

  /// Change a [Success] value.
  AsyncResult<W, F> pure<W extends Object>(W success) {
    return then((result) => result.pure(success));
  }

  /// Change the [Failure] value.
  AsyncResult<S, W> pureError<W extends Object>(W error) {
    return mapError((_) => error);
  }

  /// Swap the values contained inside the [Success] and [Failure]
  /// of this [AsyncResult].
  AsyncResult<F, S> swap() {
    return then((result) => result.swap());
  }

  /// Return the Future result in one of these functions.
  ///
  /// if the result is an error, it will be returned in
  /// [whenError],
  /// if it is a success it will be returned in [whenSuccess].
  /// <br><br>
  /// Same of `fold`
  Future<W> when<W>(
    W Function(S success) whenSuccess,
    W Function(F error) whenError,
  ) {
    return then((result) => result.when(whenSuccess, whenError));
  }

  /// Returns the Future result of onSuccess for the encapsulated value
  /// if this instance represents `Success` or the result of onError function
  /// for the encapsulated value if it is `Error`.
  /// <br><br>
  /// Same of `when`
  Future<W> fold<W>(
    W Function(S success) onSuccess,
    W Function(F error) onError,
  ) {
    return when<W>(onSuccess, onError);
  }

  /// Returns the future value of [S] if any.
  Future<S?> getOrNull() {
    return then((result) => result.getOrNull());
  }

  /// Returns the future value of [F] if any.
  Future<F?> exceptionOrNull() {
    return then((result) => result.exceptionOrNull());
  }

  /// Returns true if the current result is an [Failure].
  Future<bool> isError() {
    return then((result) => result.isError());
  }

  /// Returns true if the current result is a [Success].
  Future<bool> isSuccess() {
    return then((result) => result.isSuccess());
  }
}
