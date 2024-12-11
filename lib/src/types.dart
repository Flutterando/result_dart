import 'package:result_dart/result_dart.dart';

/// A typedef for a `Result` that simplifies the usage of `ResultDart`
/// with `Exception` as the default failure type.
///
/// This is used to represent operations that can succeed with a
/// value of type `S`
/// or fail with an `Exception`.
typedef Result<S extends Object> = ResultDart<S, Exception>;

/// A typedef for an asynchronous `Result`, simplifying the usage
/// of `AsyncResultDart`
/// with `Exception` as the default failure type.
///
/// This is used to represent asynchronous operations that can succeed
/// with a value of type `S`
/// or fail with an `Exception`.
typedef AsyncResult<S extends Object> = AsyncResultDart<S, Exception>;
