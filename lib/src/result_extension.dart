import '../result_dart.dart';

/// Adds methods for converting any object
/// into a `Result` type (`Success` or `Failure`).
extension ResultObjectExtension<W> on W {
  /// Convert the object to a `Result` type [Failure].
  ///
  /// Will throw an error if used on a `Result` or `Future` instance.
  Failure<S, W> toFailure<S>() {
    assert(
      this is! ResultDart,
      'Don`t use the "toError()" method '
      'on instances of the Result.',
    );
    assert(
      this is! Future,
      'Don`t use the "toError()" method '
      'on instances of the Future.',
    );

    return Failure<S, W>(this);
  }

  /// Convert the object to a `Result` type [Success].
  ///
  /// Will throw an error if used on a `Result` or `Future` instance.
  Success<W, F> toSuccess<F>() {
    assert(
      this is! ResultDart,
      'Don`t use the "toSuccess()" method '
      'on instances of the Result.',
    );
    assert(
      this is! Future,
      'Don`t use the "toSuccess()" method '
      'on instances of the Future.',
    );
    return Success<W, F>(this);
  }
}
