import 'package:result_dart/result_dart.dart';

/// A typedef for a `Result` that simplifies the usage of `ResultDart`
/// with `Object` as the default failure type.
///
/// This is used to represent operations that can succeed with a
/// value of type `S`
/// or fail with an `Object`.
typedef Result<S> = ResultDart<S, Object>;

/// A typedef for an asynchronous `Result`, simplifying the usage
/// of `AsyncResultDart`
/// with `Object` as the default failure type.
///
/// This is used to represent asynchronous operations that can succeed
/// with a value of type `S`
/// or fail with an `Object`.
typedef AsyncResult<S> = AsyncResultDart<S, Object>;
