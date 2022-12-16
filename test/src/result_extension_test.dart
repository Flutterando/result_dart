import 'package:multiple_result/src/result.dart';
import 'package:multiple_result/src/result_extension.dart';
import 'package:test/test.dart';

void main() {
  group('toError', () {
    test('without result type', () {
      final result = 'error'.toError();

      expect(result, isA<Result<dynamic, String>>());
      expect(result.tryGetError(), isA<String>());
      expect(result.tryGetError(), 'error');
    });

    test('with result type', () {
      Result<int, String> result = 'error'.toError();

      expect(result, isA<Result<int, String>>());
      expect(result.tryGetError(), isA<String>());
      expect(result.tryGetError(), 'error');
    });

    test('throw AssertException if is a Result object', () {
      Result<int, String> result = 'error'.toError();
      expect(result.toError, throwsA(isA<AssertionError>()));
    });

    test('throw AssertException if is a Future object', () {
      expect(Future.value().toError, throwsA(isA<AssertionError>()));
    });
  });

  group('toSuccess', () {
    test('without result type', () {
      final result = 'success'.toSuccess();

      expect(result, isA<Result<String, dynamic>>());
      expect(result.tryGetSuccess(), 'success');
    });

    test('with result type', () {
      Result<String, int> result = 'success'.toSuccess();

      expect(result, isA<Result<String, int>>());
      expect(result.tryGetSuccess(), 'success');
    });

    test('throw AssertException if is a Result object', () {
      final result = 'success'.toSuccess();
      expect(result.toSuccess, throwsA(isA<AssertionError>()));
    });

    test('throw AssertException if is a Future object', () {
      expect(Future.value().toSuccess, throwsA(isA<AssertionError>()));
    });
  });
}
