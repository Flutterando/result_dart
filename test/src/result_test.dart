import 'package:meta/meta.dart';
import 'package:result_dart/functions.dart';
import 'package:result_dart/result_dart.dart';
import 'package:test/test.dart';

void main() {
  late MyUseCase useCase;

  setUpAll(() {
    useCase = MyUseCase();
  });

  group('factories', () {
    test('Success.unit', () {
      final result = Success.unit();
      expect(result.getOrNull(), unit);
    });

    test('Success.unit type infer', () {
      Result<Unit> fn() {
        return Success.unit();
      }

      final result = fn();
      expect(result.getOrNull(), unit);
    });

    test('Error.unit type infer', () {
      Result<String> fn() {
        return const Failure(unit);
      }

      final result = fn();
      expect(result.exceptionOrNull(), unit);
    });
  });

  test('Result.success', () {
    const result = Result<int>.success(0);
    expect(result.getOrNull(), 0);
  });

  test('Result.error', () {
    const result = Result.failure(0);
    expect(result.exceptionOrNull(), 0);
  });

  test('''
Given a success result, 
        When getting the result through tryGetSuccess, 
        should return the success value''', () {
    final result = useCase();

    MyResult? successResult;
    if (result.isSuccess()) {
      successResult = result.getOrNull();
    }

    expect(successResult!.value, isA<String>());
    expect(result.isError(), isFalse);
  });

  test('''
 Given an error result, 
          When getting the result through tryGetSuccess, 
          should return null ''', () {
    final result = useCase(returnError: true);

    MyResult? successResult;
    if (result.isSuccess()) {
      successResult = result.getOrNull();
    }

    expect(successResult?.value, null);
  });

  test('''
 Given an error result, 
  When getting the result through the tryGetError, 
  should return the error value
  ''', () {
    final result = useCase(returnError: true);

    Object? exceptionResult;
    if (result.isError()) {
      exceptionResult = result.exceptionOrNull();
    }

    expect(exceptionResult != null, true);
    expect(result.isSuccess(), isFalse);
  });

  test('equatable', () {
    expect(const Success(1) == const Success(1), isTrue);
    expect(const Success(1).hashCode == const Success(1).hashCode, isTrue);

    expect(const Failure(1) == const Failure(1), isTrue);
    expect(const Failure(1).hashCode == const Failure(1).hashCode, isTrue);
  });

  group('Map', () {
    test('Success', () {
      final result = successOf(4);
      final result2 = result.map((success) => '=' * success);

      expect(result2.getOrNull(), '====');
    });

    test('Error', () {
      final result = failureOf<String>(4);
      final result2 = result.map((success) => 'change');

      expect(result2.getOrNull(), isNull);
      expect(result2.exceptionOrNull(), 4);
    });
  });

  group('MapError', () {
    test('Success', () {
      const result = Success<int>(4);
      final result2 = result.mapError((error) => '=' * (error as int));

      expect(result2.getOrNull(), 4);
      expect(result2.exceptionOrNull(), isNull);
    });

    test('Error', () {
      const result = Failure<String>(4);
      final result2 = result.mapError((error) => 'change');

      expect(result2.getOrNull(), isNull);
      expect(result2.exceptionOrNull(), 'change');
    });
  });

  group('flatMap', () {
    test('Success', () {
      const result = Success<int>(4);
      final result2 = result.flatMap((success) => Success('=' * success));

      expect(result2.getOrNull(), '====');
    });

    test('Error', () {
      const result = Failure<String>(4);
      final result2 = result.flatMap(Success.new);

      expect(result2.getOrNull(), isNull);
      expect(result2.exceptionOrNull(), 4);
    });
  });

  group('flatMapError', () {
    test('Error', () {
      const result = Failure<int>(4);
      final result2 = result.flatMapError((error) => Failure('=' * (error as int)));

      expect(result2.exceptionOrNull(), '====');
    });

    test('Success', () {
      const result = Success<int>(4);
      final result2 = result.flatMapError(Failure.new);

      expect(result2.getOrNull(), 4);
      expect(result2.exceptionOrNull(), isNull);
    });
  });

  group('pure', () {
    test('Success', () {
      final result = const Success<int>(4) //
          .pure(6)
          .map((success) => '=' * success);

      expect(result.getOrNull(), '======');
    });

    test('Error', () {
      final result = const Failure<String>(4).pure(6);

      expect(result.getOrNull(), isNull);
      expect(result.exceptionOrNull(), 4);
    });
  });

  group('pureError', () {
    test('Error', () {
      final result = const Failure<int>(4) //
          .pureError(6)
          .mapError((error) => '=' * (error as int));

      expect(result.exceptionOrNull(), '======');
    });

    test('Success', () {
      final result = const Success<int>(4).pureError(6);

      expect(result.exceptionOrNull(), isNull);
      expect(result.getOrNull(), 4);
    });
  });

  test('toAsyncResult', () {
    const result = Success(0);

    expect(result.toAsyncResult(), isA<AsyncResult>());
  });

  group('fold', () {
    test('Success', () {
      const result = Success<int>(0);
      final futureValue = result.fold(id, (e) => -1);
      expect(futureValue, 0);
    });

    test('Error', () {
      const result = Failure<String>(0);
      final futureValue = result.fold((success) => -1, identity);
      expect(futureValue, 0);
    });
  });

  group('getOrThrow', () {
    test('Success', () {
      const result = Success<int>(0);
      expect(result.getOrThrow(), 0);
    });

    test('Error', () {
      const result = Failure<String>(0);
      expect(result.getOrThrow, throwsA(0));
    });
  });

  group('getOrElse', () {
    test('Success', () {
      const result = Success<int>(0);
      final value = result.getOrElse((f) => -1);
      expect(value, 0);
    });

    test('Error', () {
      const result = Failure<int>(0);
      final value = result.getOrElse((f) => 2);
      expect(value, 2);
    });
  });

  group('getOrDefault', () {
    test('Success', () {
      const result = Success<int>(0);
      final value = result.getOrDefault(-1);
      expect(value, 0);
    });

    test('Error', () {
      const result = Failure<int>(0);
      final value = result.getOrDefault(2);
      expect(value, 2);
    });
  });

  group('recover', () {
    test('Success', () {
      final result = const Success<int>(0) //
          .recover((f) => const Success(1));
      expect(result.getOrThrow(), 0);
    });

    test('Error', () {
      final result = const Failure<int>('failure') //
          .recover((f) => const Success(1));
      expect(result.getOrThrow(), 1);
    });
  });
}

Result<Unit> getMockedSuccessResult() {
  return Success.unit();
}

class MyUseCase {
  Result<MyResult> call({bool returnError = false}) {
    if (returnError) {
      return const Failure(MyException('something went wrong'));
    } else {
      return const Success(MyResult('nice'));
    }
  }
}

@immutable
class MyException implements Exception {
  final String message;

  const MyException(this.message);

  @override
  int get hashCode => message.hashCode;

  @override
  bool operator ==(Object other) => //
      other is MyException && other.message == message;
}

@immutable
class MyResult {
  const MyResult(this.value);

  final String value;

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other) => other is MyResult && other.value == value;
}
