/// Library containing utility functions for working with ResultDart.
///
/// This library provides helper functions such as `identity`, `id`, `successOf`, and `failureOf`.
library;

import 'result_dart.dart';


/// Returns the given `a`.
///
/// Same as `id`.
///
/// Shortcut function to return the input parameter:
/// ```dart
/// final result = Result<int, String>.success(10);
///
/// /// Without using `identity`, you must write a function to return
/// /// the input parameter `(error) => error`.
/// final noId = result.when((success) => '$success', (error) => error);
///
/// /// Using `identity`/`id`, the function just returns its input parameter.
/// final withIdentity = result.when((success) => '$success', identity);
/// final withId = result.when((success) => '$success', identity);
/// ```
T identity<T>(T a) => a;

/// Returns the given `a`.
///
/// Same as `identity`.
///
/// Shortcut function to return the input parameter:
/// ```dart
/// final result = Result<int, String>.success(10);
///
/// /// Without using `identity`, you must write a function to return
/// /// the input parameter `(error) => error`.
/// final noId = result.when((success) => '$success', (error) => error);
///
/// /// Using `identity`/`id`, the function just returns its input parameter.
/// final withIdentity = result.when((success) => '$success', id);
/// final withId = result.when((success) => '$success', id);
/// ```
T id<T>(T a) => a;

/// Build a [ResultDart] that returns a [Success].
ResultDart<S, F> successOf<S extends Object, F extends Object>(S success) {
  return Success<S, F>(success);
}

/// Build a [ResultDart] that returns a [Failure].
ResultDart<S, F> failureOf<S extends Object, F extends Object>(F failure) {
  return Failure<S, F>(failure);
}
