import '../result_dart.dart';

/// Adds methods for converting any object
/// into a `Result` type (`Success` or `Failure`).
extension ResultObjectExtension<W extends Object> on W {
  /// Convert the object to a `Result` type [Failure].
  ///
  /// Will throw an error if used on a `Result` or `Future` instance.
  Failure<S> toFailure<S extends Object>() {
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

    return Failure<S>(this);
  }

  /// Convert the object to a `Result` type [Success].
  ///
  /// Will throw an error if used on a `Result` or `Future` instance.
  Success<W> toSuccess<F extends Object>() {
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
    return Success<W>(this);
  }
}
