import '../result_dart.dart';

/// Adds methods for converting any object
/// into a `Result` type (`Success` or `Error`).
extension ResultObjectExtension<W> on W {
  /// Convert the object to a `Result` type [Error].
  ///
  /// Will throw an error if used on a `Result` or `Future` instance.
  Error<S, W> toError<S>() {
    assert(
      this is! Result,
      'Don`t use the "toError()" method '
      'on instances of the Result.',
    );
    assert(
      this is! Future,
      'Don`t use the "toError()" method '
      'on instances of the Future.',
    );

    return Error<S, W>(this);
  }

  /// Convert the object to a `Result` type [Success].
  ///
  /// Will throw an error if used on a `Result` or `Future` instance.
  Success<W, E> toSuccess<E>() {
    assert(
      this is! Result,
      'Don`t use the "toSuccess()" method '
      'on instances of the Result.',
    );
    assert(
      this is! Future,
      'Don`t use the "toSuccess()" method '
      'on instances of the Future.',
    );
    return Success<W, E>(this);
  }
}
