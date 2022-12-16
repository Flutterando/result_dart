import 'dart:async';

import '../result_dart.dart';

/// `AsyncResult<S, E>` represents an asynchronous computation.
typedef AsyncResult<S, E> = Future<Result<S, E>>;

/// `AsyncResult<S, E>` represents an asynchronous computation.
extension AsyncResultExtension<S, E> on AsyncResult<S, E> {
  /// Returns a new `Result`, mapping any `Success` value
  /// using the given transformation and unwrapping the produced `Result`.
  AsyncResult<W, E> flatMap<W>(FutureOr<Result<W, E>> Function(S success) fn) {
    return then((result) => result.when(fn, Error.new));
  }

  /// Returns a new `Result`, mapping any `Error` value
  /// using the given transformation and unwrapping the produced `Result`.
  AsyncResult<S, W> flatMapError<W>(
    FutureOr<Result<S, W>> Function(E error) fn,
  ) {
    return then((result) => result.when(Success.new, fn));
  }

  /// Returns a new `AsyncResult`, mapping any `Success` value
  /// using the given transformation.
  AsyncResult<W, E> map<W>(W Function(S success) fn) {
    return then((result) => result.map(fn));
  }

  /// Returns a new `Result`, mapping any `Error` value
  /// using the given transformation.
  AsyncResult<S, W> mapError<W>(W Function(E error) fn) {
    return then((result) => result.mapError(fn));
  }

  /// Change a [Success] value.
  AsyncResult<W, E> pure<W>(W success) {
    return then((result) => result.pure(success));
  }

  /// Change the [Error] value.
  AsyncResult<S, W> pureError<W>(W error) {
    return mapError((_) => error);
  }

  /// Swap the values contained inside the [Success] and [Error]
  /// of this [AsyncResult].
  AsyncResult<E, S> swap() {
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
    W Function(E error) whenError,
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
    W Function(E error) onError,
  ) {
    return when<W>(onSuccess, onError);
  }

  /// Returns the future value of [S] if any.
  Future<S?> tryGetSuccess() {
    return then((result) => result.tryGetSuccess());
  }

  /// Returns the future value of [E] if any.
  Future<E?> tryGetError() {
    return then((result) => result.tryGetError());
  }

  /// Returns true if the current result is an [Error].
  Future<bool> isError() {
    return then((result) => result.isError());
  }

  /// Returns true if the current result is a [Success].
  Future<bool> isSuccess() {
    return then((result) => result.isSuccess());
  }

  /// Execute [whenSuccess] if the [Result] is a success.
  Future<W?> onSuccess<W>(
    W Function(S success) whenSuccess,
  ) {
    return then((result) => result.onSuccess(whenSuccess));
  }

  /// Execute [whenError] if the [Result] is an error.
  Future<W?> onError<W>(
    W Function(E error) whenError,
  ) {
    return then((result) => result.onError(whenError));
  }
}
