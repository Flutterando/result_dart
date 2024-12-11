import 'dart:async';

import '../result_dart.dart';

/// `AsyncResult<S, E>` represents an asynchronous computation.
typedef AsyncResult<S extends Object> = Future<Result<S>>;

/// `AsyncResult<S, E>` represents an asynchronous computation.
extension AsyncResultExtension<S extends Object> //
    on AsyncResult<S> {
  /// Returns a new `Result`, mapping any `Success` value
  /// using the given transformation and unwrapping the produced `Result`.
  AsyncResult<W> flatMap<W extends Object>(
    FutureOr<Result<W>> Function(S success) fn,
  ) {
    return then((result) => result.fold(fn, Failure.new));
  }

  /// Returns a new `Result`, mapping any `Error` value
  /// using the given transformation and unwrapping the produced `Result`.
  AsyncResult<S> flatMapError<W extends Object>(
    FutureOr<Result<S>> Function(dynamic error) fn,
  ) {
    return then((result) => result.fold(Success.new, fn));
  }

  /// Returns a new `AsyncResult`, mapping any `Success` value
  /// using the given transformation.
  AsyncResult<W> map<W extends Object>(
    FutureOr<W> Function(S success) fn,
  ) {
    return then(
      (result) => result.map(fn).fold(
        (success) async {
          return Success(await success);
        },
        (failure) {
          return Failure(failure);
        },
      ),
    );
  }

  /// Returns a new `Result`, mapping any `Error` value
  /// using the given transformation.
  AsyncResult<S> mapError<W extends Object>(
    FutureOr<W> Function(dynamic error) fn,
  ) {
    return then(
      (result) => result.mapError(fn).fold(
        (success) {
          return Success(success);
        },
        (failure) async {
          if (failure is Future) {
            return Failure(await failure);
          }
          return Failure(failure);
        },
      ),
    );
  }

  /// Change a [Success] value.
  AsyncResult<W> pure<W extends Object>(W success) {
    return then((result) => result.pure(success));
  }

  /// Change the [Failure] value.
  AsyncResult<S> pureError<W extends Object>(W error) {
    return mapError((_) => error);
  }

  /// Returns the Future result of onSuccess for the encapsulated value
  /// if this instance represents `Success` or the result of onError function
  /// for the encapsulated value if it is `Error`.
  Future<W> fold<W>(
    W Function(S success) onSuccess,
    W Function(dynamic error) onError,
  ) {
    return then<W>((result) => result.fold(onSuccess, onError));
  }

  /// Returns the future value of [S] if any.
  Future<S?> getOrNull() {
    return then((result) => result.getOrNull());
  }

  /// Returns the future value if any.
  Future<dynamic> exceptionOrNull() {
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

  /// Returns the success value as a throwing expression.
  Future<S> getOrThrow() {
    return then((result) => result.getOrThrow());
  }

  /// Returns the encapsulated value if this instance represents `Success`
  /// or the result of `onFailure` function for
  /// the encapsulated a `Failure` value.
  Future<S> getOrElse(S Function(dynamic failure) onFailure) {
    return then((result) => result.getOrElse(onFailure));
  }

  /// Returns the encapsulated value if this instance represents
  /// `Success` or the `defaultValue` if it is `Failure`.
  Future<S> getOrDefault(S defaultValue) {
    return then((result) => result.getOrDefault(defaultValue));
  }

  /// Returns the encapsulated `Result` of the given transform function
  /// applied to the encapsulated a `Failure` or the original
  /// encapsulated value if it is success.
  AsyncResult<S> recover<R extends dynamic>(
    FutureOr<Result<S>> Function(dynamic failure) onFailure,
  ) {
    return then((result) => result.fold(Success.new, onFailure));
  }

  /// Performs the given action on the encapsulated Throwable
  /// exception if this instance represents failure.
  /// Returns the original Result unchanged.
  AsyncResult<S> onFailure(void Function(dynamic failure) onFailure) {
    return then((result) => result.onFailure(onFailure));
  }

  /// Performs the given action on the encapsulated value if this
  /// instance represents success. Returns the original Result unchanged.
  AsyncResult<S> onSuccess(void Function(S success) onSuccess) {
    return then((result) => result.onSuccess(onSuccess));
  }
}
