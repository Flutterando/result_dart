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
  });

  test('Result.success', () {
    const result = Result<int>.success(0);
    expect(result.getOrNull(), 0);
  });

  test('Result.error', () {
    const result = Result.failure(MyException('error'));
    expect(result.exceptionOrNull(), isA<MyException>());
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

    const exception = MyException('error');

    expect(const Failure(exception) == const Failure(exception), isTrue);
    expect(const Failure(exception).hashCode == const Failure(exception).hashCode, isTrue);
  });

  group('Map', () {
    test('Success', () {
      final result = successOf(4);
      final result2 = result.map((success) => '=' * success);

      expect(result2.getOrNull(), '====');
    });

    test('Error', () {
      final result = failureOf<String>(const MyException('error'));
      final result2 = result.map((success) => 'change');

      expect(result2.getOrNull(), isNull);
      expect(result2.exceptionOrNull(), isA<MyException>());
    });
  });

  group('MapError', () {
    test('Success', () {
      const result = Success<int>(4);
      final result2 = result.mapError((error) => const MyException('mapped'));

      expect(result2.getOrNull(), 4);
      expect(result2.exceptionOrNull(), isNull);
    });

    test('Error', () {
      const result = Failure<String>(MyException('error'));
      final result2 = result.mapError((error) => const MyException('mapped'));

      expect(result2.getOrNull(), isNull);
      expect(result2.exceptionOrNull(), const MyException('mapped'));
    });
  });

  group('flatMap', () {
    test('Success', () {
      const result = Success<int>(4);
      final result2 = result.flatMap((success) => Success('=' * success));

      expect(result2.getOrNull(), '====');
    });

    test('Error', () {
      const result = Failure<String>(MyException('mapped'));
      final result2 = result.flatMap(Success.new);

      expect(result2.getOrNull(), isNull);
      expect(result2.exceptionOrNull(), const MyException('mapped'));
    });
  });

  group('flatMapError', () {
    test('Error', () {
      const result = Failure<int>(MyException('error'));
      final result2 = result.flatMapError((error) => const Failure(MyException('mapped')));

      expect(result2.exceptionOrNull(), const MyException('mapped'));
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
      final result = const Failure<String>(MyException('mapped')).pure(6);

      expect(result.getOrNull(), isNull);
      expect(result.exceptionOrNull(), const MyException('mapped'));
    });
  });

  group('pureError', () {
    test('Error', () {
      final result = const Failure<int>(MyException('error')) //
          .pureError(const MyException('pure'));

      expect(result.exceptionOrNull(), const MyException('pure'));
    });

    test('Success', () {
      final result = const Success<int>(4).pureError(const MyException('mapped'));

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
      const result = Failure<String>(MyException('mapped'));
      final futureValue = result.fold((success) => -1, identity);
      expect(futureValue, const MyException('mapped'));
    });
  });

  group('getOrThrow', () {
    test('Success', () {
      const result = Success<int>(0);
      expect(result.getOrThrow(), 0);
    });

    test('Error', () {
      const result = Failure<String>(MyException('mapped'));
      expect(result.getOrThrow, throwsA(const MyException('mapped')));
    });
  });

  group('getOrElse', () {
    test('Success', () {
      const result = Success<int>(0);
      final value = result.getOrElse((f) => -1);
      expect(value, 0);
    });

    test('Error', () {
      const result = Failure<int>(MyException('mapped'));
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
      const result = Failure<int>(MyException('mapped'));
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
      final result = const Failure<int>(MyException('mapped')) //
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
