import 'package:result_dart/result_dart.dart';
import 'package:test/test.dart';

void main() {
  group('flatMap', () {
    test('async ', () async {
      final result = await const Success(1) //
          .toAsyncResult()
          .flatMap((success) async => Success(success * 2));
      expect(result.getOrNull(), 2);
    });

    test('sink', () async {
      final result = await const Success(1) //
          .toAsyncResult()
          .flatMap((success) => Success(success * 2));
      expect(result.getOrNull(), 2);
    });
  });

  group('flatMapError', () {
    test('async ', () async {
      final result = await const Failure(1) //
          .toAsyncResult()
          .flatMapError((error) async => Failure(error * 2));
      expect(result.exceptionOrNull(), 2);
    });

    test('sink', () async {
      final result = await const Failure(1) //
          .toAsyncResult()
          .flatMapError((error) => Failure(error * 2));
      expect(result.exceptionOrNull(), 2);
    });
  });

  test('map', () async {
    final result = await const Success(1) //
        .toAsyncResult()
        .map((success) => success * 2);

    expect(result.getOrNull(), 2);
  });

  test('mapError', () async {
    final result = await const Failure(1) //
        .toAsyncResult()
        .mapError((error) => error * 2);
    expect(result.exceptionOrNull(), 2);
  });

  test('pure', () async {
    final result = await const Success(1).toAsyncResult().pure(10);

    expect(result.getOrNull(), 10);
  });
  test('pureError', () async {
    final result = await const Failure(1).toAsyncResult().pureError(10);

    expect(result.exceptionOrNull(), 10);
  });

  group('swap', () {
    test('Success to Error', () async {
      final result = const Success<int, String>(0).toAsyncResult();
      final swap = await result.swap();

      expect(swap.exceptionOrNull(), 0);
    });

    test('Error to Success', () async {
      final result = const Failure<String, int>(0).toAsyncResult();
      final swap = await result.swap();

      expect(swap.getOrNull(), 0);
    });
  });

  group('fold', () {
    test('Success', () async {
      final result = const Success<int, String>(0).toAsyncResult();
      final futureValue = result.fold(id, (e) => -1);
      expect(futureValue, completion(0));
    });

    test('Error', () async {
      final result = const Failure<String, int>(0).toAsyncResult();
      final futureValue = result.fold(identity, (e) => e);
      expect(futureValue, completion(0));
    });
  });

  group('tryGetSuccess and tryGetError', () {
    test('Success', () async {
      final result = const Success<int, String>(0).toAsyncResult();

      expect(result.isSuccess(), completion(true));
      expect(result.getOrNull(), completion(0));
    });

    test('Error', () async {
      final result = const Failure<String, int>(0).toAsyncResult();

      expect(result.isError(), completion(true));
      expect(result.exceptionOrNull(), completion(0));
    });
  });

  group('getOrThrow', () {
    test('Success', () {
      final result = const Success<int, String>(0).toAsyncResult();
      expect(result.getOrThrow(), completion(0));
    });

    test('Error', () {
      final result = const Failure<String, int>(0).toAsyncResult();
      expect(result.getOrThrow(), throwsA(0));
    });
  });

  group('getOrElse', () {
    test('Success', () {
      final result = const Success<int, String>(0).toAsyncResult();
      final value = result.getOrElse((f) => -1);
      expect(value, completion(0));
    });

    test('Error', () {
      final result = const Failure<int, int>(0).toAsyncResult();
      final value = result.getOrElse((f) => 2);
      expect(value, completion(2));
    });
  });

  group('getOrDefault', () {
    test('Success', () {
      final result = const Success<int, String>(0).toAsyncResult();
      final value = result.getOrDefault(-1);
      expect(value, completion(0));
    });

    test('Error', () {
      final result = const Failure<int, int>(0).toAsyncResult();
      final value = result.getOrDefault(2);
      expect(value, completion(2));
    });
  });

  group('recover', () {
    test('Success', () {
      final result = const Success<int, String>(0) //
          .toAsyncResult()
          .recover((f) => const Success(1));
      expect(result.getOrThrow(), completion(0));
    });

    test('Error', () {
      final result = const Failure<int, String>('failure') //
          .toAsyncResult()
          .recover((f) => const Success(1));
      expect(result.getOrThrow(), completion(1));
    });
  });
}
