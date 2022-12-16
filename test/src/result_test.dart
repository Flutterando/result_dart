import 'package:meta/meta.dart';
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
      Result<Unit, Exception> fn() {
        return Success.unit();
      }

      final result = fn();
      expect(result.getOrNull(), unit);
    });

    test('Error.unit', () {
      final result = Failure.unit();
      expect(result.exceptionOrNull(), unit);
    });

    test('Error.unit type infer', () {
      Result<String, Unit> fn() {
        return Failure.unit();
      }

      final result = fn();
      expect(result.exceptionOrNull(), unit);
    });
  });

  test('Result.success', () {
    final result = Result.success(0);
    expect(result.getOrNull(), 0);
  });

  test('Result.error', () {
    final result = Result.failure(0);
    expect(result.exceptionOrNull(), 0);
  });

  test(
      'Given an error result '
      'When getting the value through when '
      'should return the value of the error function', () {
    final result = useCase(returnError: true);

    final value = result.when(
      (success) => 2,
      (error) => 1,
    );

    expect(value, 1);
  });

  test(
      'Given a success result, '
      'When getting the result though when '
      'should return the value of the success function', () {
    final result = useCase();

    final value = result.when(
      (success) => 2,
      (error) => 1,
    );

    expect(value, 2);
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

    MyException? exceptionResult;
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
      const result = Success(4);
      final result2 = result.map((success) => '=' * success);

      expect(result2.getOrNull(), '====');
    });

    test('Error', () {
      const result = Failure<String, int>(4);
      final result2 = result.map((success) => 'change');

      expect(result2.getOrNull(), isNull);
      expect(result2.exceptionOrNull(), 4);
    });
  });

  group('MapError', () {
    test('Success', () {
      const result = Success<int, int>(4);
      final result2 = result.mapError((error) => '=' * error);

      expect(result2.getOrNull(), 4);
      expect(result2.exceptionOrNull(), isNull);
    });

    test('Error', () {
      const result = Failure<String, int>(4);
      final result2 = result.mapError((error) => 'change');

      expect(result2.getOrNull(), isNull);
      expect(result2.exceptionOrNull(), 'change');
    });
  });

  group('flatMap', () {
    test('Success', () {
      const result = Success<int, int>(4);
      final result2 = result.flatMap((success) => Success('=' * success));

      expect(result2.getOrNull(), '====');
    });

    test('Error', () {
      const result = Failure<String, int>(4);
      final result2 = result.flatMap(Success.new);

      expect(result2.getOrNull(), isNull);
      expect(result2.exceptionOrNull(), 4);
    });
  });

  group('flatMapError', () {
    test('Error', () {
      const result = Failure<int, int>(4);
      final result2 = result.flatMapError((error) => Failure('=' * error));

      expect(result2.exceptionOrNull(), '====');
    });

    test('Success', () {
      const result = Success<int, String>(4);
      final result2 = result.flatMapError(Failure.new);

      expect(result2.getOrNull(), 4);
      expect(result2.exceptionOrNull(), isNull);
    });
  });

  group('pure', () {
    test('Success', () {
      final result = const Success<int, int>(4) //
          .pure(6)
          .map((success) => '=' * success);

      expect(result.getOrNull(), '======');
    });

    test('Error', () {
      final result = const Failure<String, int>(4).pure(6);

      expect(result.getOrNull(), isNull);
      expect(result.exceptionOrNull(), 4);
    });
  });

  group('pureError', () {
    test('Error', () {
      final result = const Failure<int, int>(4) //
          .pureError(6)
          .mapError((error) => '=' * error);

      expect(result.exceptionOrNull(), '======');
    });

    test('Success', () {
      final result = const Success<int, String>(4).pureError(6);

      expect(result.exceptionOrNull(), isNull);
      expect(result.getOrNull(), 4);
    });
  });

  test('toAsyncResult', () {
    const result = Success(0);

    expect(result.toAsyncResult(), isA<AsyncResult>());
  });

  group('swap', () {
    test('Success to Error', () {
      const result = Success<int, String>(0);
      final swap = result.swap();

      expect(swap.exceptionOrNull(), 0);
    });

    test('Error to Success', () {
      const result = Failure<String, int>(0);
      final swap = result.swap();

      expect(swap.getOrNull(), 0);
    });
  });

  group('fold', () {
    test('Success', () {
      const result = Success<int, String>(0);
      final futureValue = result.fold(id, (e) => -1);
      expect(futureValue, 0);
    });

    test('Error', () {
      const result = Failure<String, int>(0);
      final futureValue = result.fold((success) => -1, identity);
      expect(futureValue, 0);
    });
  });
}

Result<Unit, MyException> getMockedSuccessResult() {
  return Success.unit();
}

class MyUseCase {
  Result<MyResult, MyException> call({bool returnError = false}) {
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
