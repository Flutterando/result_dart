## [2.1.1] - 2025-06-14

- Fix linter problems.

## [2.1.0] - 2025-04-10

- Added `pureFold` and `mapFold` operators.

## [2.0.0] - 2024-12-11

- This version aims to reduce the `Result` boilerplate by making the `Failure` type Exception by default. This will free the Result from having to type `Failure`, making the declaration smaller.

If there is a need to type `Failure`, use `ResultDart`.

### Added
- Introduced `typedef` for `Result<S>` and `AsyncResult<S>` to simplify usage:
  - `Result<S>` is a simplified alias for `ResultDart<S, Exception>`.
  - `AsyncResult<S>` is a simplified alias for `AsyncResultDart<S, Exception>`.

### Changed
- Replaced `Result` class with `ResultDart` as the base class for all results.
  - Default failure type for `ResultDart` is now `Exception`.
  - This change reduces boilerplate and improves usability by eliminating the need to specify the failure type explicitly in most cases.

### Removed

- Remove factories `Result.success` and `Result.failure`.


### Migration Guide
- In version >=2.0.0, the Failure typing is by default an `Exception`, but if there is a need to type it, use `ResultDart<Success, Failure>`.

only `Success` type:
```dart
// Old
Result<int, Exception> myResult = Success(42);

// NEW
Result<int> myResult = Success(42);

```

with `Success` and `Failure` types:
```dart
// Old
Result<int, String> myResult = Success(42);

// NEW
ResultDart<int, String> myResult = Success(42);

```


## [1.1.1] - 2023-07-05

* pump Dart version to 3.0.0
* fix: factory const

## [1.1.0] - 2023-07-05

* feat: Added onSuccess and onFailure callbacks

## [1.0.6] - 2023-05-11

* feat: Dart 3.0.0 support

## [1.0.5] - 2023-01-26

* feat: Added FutureOr in AsyncResult.MapError

## [1.0.4] - 2023-01-26

* feat: Added FutureOr in AsyncResult.Map

## [1.0.3] - 2022-12-22

* fix: AsyncResult recover

## [1.0.2] - 2022-12-18

* fix: separed functions.dart import

## [1.0.1] - 2022-12-17

* fix: recover operator return a `Result` instead a `Failure`.

## [1.0.0+2] - 2022-12-16

* Initial release

