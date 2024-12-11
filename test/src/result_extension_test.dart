import 'package:result_dart/src/result.dart';
import 'package:result_dart/src/result_extension.dart';
import 'package:test/test.dart';

import 'result_test.dart';

void main() {
  group('toError', () {
    test('without result type', () {
      final result = const MyException('mapped').toFailure();

      expect(result, isA<Result<dynamic>>());
      expect(result.exceptionOrNull(), isA<MyException>());
    });

    test('with result type', () {
      final Result<int> result = const MyException('mapped').toFailure();

      expect(result, isA<Result<int>>());
      expect(result.exceptionOrNull(), isA<MyException>());
    });
  });

  group('toSuccess', () {
    test('without result type', () {
      final result = 'success'.toSuccess();

      expect(result, isA<Result<String>>());
      expect(result.getOrNull(), 'success');
    });

    test('with result type', () {
      final Result<String> result = 'success'.toSuccess();

      expect(result, isA<Result<String>>());
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
