import 'package:result_dart/src/result_dart_base.dart';
import 'package:result_dart/src/result_extension.dart';
import 'package:test/test.dart';

void main() {
  group('toError', () {
    test('without result type', () {
      final result = 'error'.toFailure();

      expect(result, isA<ResultDart<dynamic, String>>());
      expect(result.exceptionOrNull(), isA<String>());
      expect(result.exceptionOrNull(), 'error');
    });

    test('with result type', () {
      final ResultDart<int, String> result = 'error'.toFailure();

      expect(result, isA<ResultDart<int, String>>());
      expect(result.exceptionOrNull(), isA<String>());
      expect(result.exceptionOrNull(), 'error');
    });

    test('throw AssertException if is a Result object', () {
      final ResultDart<int, String> result = 'error'.toFailure();
      expect(result.toFailure, throwsA(isA<AssertionError>()));
    });

    test('throw AssertException if is a Future object', () {
      expect(Future.value().toFailure, throwsA(isA<AssertionError>()));
    });
  });

  group('toSuccess', () {
    test('without result type', () {
      final result = 'success'.toSuccess();

      expect(result, isA<ResultDart<String, dynamic>>());
      expect(result.getOrNull(), 'success');
    });

    test('with result type', () {
      final ResultDart<String, int> result = 'success'.toSuccess();

      expect(result, isA<ResultDart<String, int>>());
      expect(result.getOrNull(), 'success');
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
