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
      expect(result.tryGetSuccess(), unit);
    });

    test('Success.unit type infer', () {
      Result<Unit, Exception> fn() {
        return Success.unit();
      }

      final result = fn();
      expect(result.tryGetSuccess(), unit);
    });

    test('Error.unit', () {
      final result = Error.unit();
      expect(result.tryGetError(), unit);
    });

    test('Error.unit type infer', () {
      Result<String, Unit> fn() {
        return Error.unit();
      }

      final result = fn();
      expect(result.tryGetError(), unit);
    });
  });

  test('Result.success', () {
    final result = Result.success(0);
    expect(result.tryGetSuccess(), 0);
  });

  test('Result.error', () {
    final result = Result.error(0);
    expect(result.tryGetError(), 0);
  });

  test(
      'Given an error result'
      'When getting the value through when'
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
      'When getting the result though when'
      'should return the value of the success function', () {
    final result = useCase();

    final value = result.when(
      (success) => 2,
      (error) => 1,
    );

    expect(value, 2);
  });

  test('''Given a success result, 
        When getting the result through tryGetSuccess, 
        should return the success value''', () {
    final result = useCase();

    MyResult? successResult;
    if (result.isSuccess()) {
      successResult = result.tryGetSuccess();
    }

    expect(successResult!.value, isA<String>());
    expect(result.isError(), isFalse);
  });

  test(''' Given an error result, 
          When getting the result through tryGetSuccess, 
          should return null ''', () {
    final result = useCase(returnError: true);

    MyResult? successResult;
    if (result.isSuccess()) {
      successResult = result.tryGetSuccess();
    }

    expect(successResult?.value, null);
  });

  test(''' Given an error result, 
  When getting the result through the tryGetError, 
  should return the error value
  ''', () {
    final result = useCase(returnError: true);

    MyException? exceptionResult;
    if (result.isError()) {
      exceptionResult = result.tryGetError();
    }

    expect(exceptionResult != null, true);
    expect(result.isSuccess(), isFalse);
  });

  group(
    "onSuccess and onError",
    () {
      test('''
       Given a result of SuccessResult type, 
       when executing onSuccess, 
       should return the result of onSuccess,
      ''', () {
        final result = getMockedSuccessResult();
        int? onSuccessValue;
        result.onSuccess((success) {
          onSuccessValue = 10;
        });
        expect(onSuccessValue, 10);
      });

      test('''
         Given a result of Error type, 
         when executing onSuccess, 
         should return null,
        ''', () {
        final result = useCase.call(returnError: true);
        int? onSuccessValue;
        result.onSuccess((success) {
          onSuccessValue = 10;
        });
        expect(onSuccessValue, null);
      });

      test('''
       Given a result of SuccessResult type, 
       when executing onError, 
       should return null,
      ''', () {
        final result = getMockedSuccessResult();
        int? onErrorValue;
        result.onError((success) {
          onErrorValue = 10;
        });
        expect(onErrorValue, null);
      });

      test('''
         Given a result of an Error type, 
         when executing onError, 
         should return the result of onError,
        ''', () {
        final result = useCase.call(returnError: true);
        int? onErrorValue;
        result.onError((success) {
          onErrorValue = 10;
        });
        expect(onErrorValue, 10);
      });
    },
  );

  test('equatable', () {
    expect(Success(1) == Success(1), isTrue);
    expect(Success(1).hashCode == Success(1).hashCode, isTrue);

    expect(Error(1) == Error(1), isTrue);
    expect(Error(1).hashCode == Error(1).hashCode, isTrue);
  });

  group('Map', () {
    test('Success', () {
      final result = Success(4);
      final result2 = result.map((success) => '=' * success);

      expect(result2.tryGetSuccess(), '====');
    });

    test('Error', () {
      final result = Error<String, int>(4);
      final result2 = result.map((success) => 'change');

      expect(result2.tryGetSuccess(), isNull);
      expect(result2.tryGetError(), 4);
    });
  });

  group('MapError', () {
    test('Success', () {
      final result = Success<int, int>(4);
      final result2 = result.mapError((error) => '=' * error);

      expect(result2.tryGetSuccess(), 4);
      expect(result2.tryGetError(), isNull);
    });

    test('Error', () {
      final result = Error<String, int>(4);
      final result2 = result.mapError((error) => 'change');

      expect(result2.tryGetSuccess(), isNull);
      expect(result2.tryGetError(), 'change');
    });
  });

  group('flatMap', () {
    test('Success', () {
      final result = Success<int, int>(4);
      final result2 = result.flatMap((success) => Success('=' * success));

      expect(result2.tryGetSuccess(), '====');
    });

    test('Error', () {
      final result = Error<String, int>(4);
      final result2 = result.flatMap(Success.new);

      expect(result2.tryGetSuccess(), isNull);
      expect(result2.tryGetError(), 4);
    });
  });

  group('flatMapError', () {
    test('Error', () {
      final result = Error<int, int>(4);
      final result2 = result.flatMapError((error) => Error('=' * error));

      expect(result2.tryGetError(), '====');
    });

    test('Success', () {
      final result = Success<int, String>(4);
      final result2 = result.flatMapError(Error.new);

      expect(result2.tryGetError(), isNull);
      expect(result2.tryGetSuccess(), 4);
    });
  });

  group('pure', () {
    test('Success', () {
      final result = Success<int, int>(4) //
          .pure(6)
          .map((success) => '=' * success);

      expect(result.tryGetSuccess(), '======');
    });

    test('Error', () {
      final result = Error<String, int>(4).pure(6);

      expect(result.tryGetSuccess(), isNull);
      expect(result.tryGetError(), 4);
    });
  });

  group('pureError', () {
    test('Error', () {
      final result = Error<int, int>(4) //
          .pureError(6)
          .mapError((error) => '=' * error);

      expect(result.tryGetError(), '======');
    });

    test('Success', () {
      final result = Success<int, String>(4).pureError(6);

      expect(result.tryGetError(), isNull);
      expect(result.tryGetSuccess(), 4);
    });
  });

  test('toAsyncResult', () {
    final result = Success(0);

    expect(result.toAsyncResult(), isA<AsyncResult>());
  });

  group('swap', () {
    test('Success to Error', () {
      final result = Success<int, String>(0);
      final swap = result.swap();

      expect(swap.tryGetError(), 0);
    });

    test('Error to Success', () {
      final result = Error<String, int>(0);
      final swap = result.swap();

      expect(swap.tryGetSuccess(), 0);
    });
  });

  group('fold', () {
    test('Success', () {
      final result = Success<int, String>(0);
      final futureValue = result.fold(id, (e) => -1);
      expect(futureValue, 0);
    });

    test('Error', () {
      final result = Error<String, int>(0);
      final futureValue = result.fold(((success) => -1), identity);
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
      return Error(MyException('something went wrong'));
    } else {
      return Success(MyResult('nice'));
    }
  }
}

@immutable
class MyException implements Exception {
  final String message;

  MyException(this.message);

  @override
  int get hashCode => message.hashCode;

  @override
  bool operator ==(Object other) => other is MyException && other.message == message;
}

@immutable
class MyResult {
  MyResult(this.value);

  final String value;

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other) => other is MyResult && other.value == value;
}
