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

  group('when', () {
    test('Success', () async {
      final result = const Success<int, String>(0).toAsyncResult();
      final futureValue = result.when((success) => success, (e) => -1);
      expect(futureValue, completion(0));
    });

    test('Error', () async {
      final result = const Failure<String, int>(0).toAsyncResult();
      final futureValue = result.when((success) => -1, (e) => e);
      expect(futureValue, completion(0));
    });
  });

  group('fold', () {
    test('Success', () async {
      final result = const Success<int, String>(0).toAsyncResult();
      final futureValue = result.fold((success) => success, (e) => -1);
      expect(futureValue, completion(0));
    });

    test('Error', () async {
      final result = const Failure<String, int>(0).toAsyncResult();
      final futureValue = result.fold((success) => -1, (e) => e);
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

  group('get', () {
    test('Success', () {
      final result = const Success<int, String>(0).toAsyncResult();
      expect(result.get(), completion(0));
    });

    test('Error', () {
      final result = const Failure<String, int>(0).toAsyncResult();
      expect(result.get(), throwsA(0));
    });
  });
}
