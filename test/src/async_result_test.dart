import 'package:multiple_result/multiple_result.dart';
import 'package:test/test.dart';

void main() {
  group('flatMap', () {
    test('async ', () async {
      final result = await Success(1) //
          .toAsyncResult()
          .flatMap((success) async => Success(success * 2));
      expect(result.tryGetSuccess(), 2);
    });

    test('sink', () async {
      final result = await Success(1) //
          .toAsyncResult()
          .flatMap((success) => Success(success * 2));
      expect(result.tryGetSuccess(), 2);
    });
  });

  group('flatMapError', () {
    test('async ', () async {
      final result = await Error(1) //
          .toAsyncResult()
          .flatMapError((error) async => Error(error * 2));
      expect(result.tryGetError(), 2);
    });

    test('sink', () async {
      final result = await Error(1) //
          .toAsyncResult()
          .flatMapError((error) => Error(error * 2));
      expect(result.tryGetError(), 2);
    });
  });

  test('map', () async {
    final result = await Success(1) //
        .toAsyncResult()
        .map((success) => success * 2);

    expect(result.tryGetSuccess(), 2);
  });

  test('mapError', () async {
    final result = await Error(1) //
        .toAsyncResult()
        .mapError((error) => error * 2);
    expect(result.tryGetError(), 2);
  });

  test('pure', () async {
    final result = await Success(1).toAsyncResult().pure(10);

    expect(result.tryGetSuccess(), 10);
  });
  test('pureError', () async {
    final result = await Error(1).toAsyncResult().pureError(10);

    expect(result.tryGetError(), 10);
  });

  group('swap', () {
    test('Success to Error', () async {
      final result = Success<int, String>(0).toAsyncResult();
      final swap = await result.swap();

      expect(swap.tryGetError(), 0);
    });

    test('Error to Success', () async {
      final result = Error<String, int>(0).toAsyncResult();
      final swap = await result.swap();

      expect(swap.tryGetSuccess(), 0);
    });
  });

  group('when', () {
    test('Success', () async {
      final result = Success<int, String>(0).toAsyncResult();
      final futureValue = result.when(((success) => success), (e) => -1);
      expect(futureValue, completion(0));
    });

    test('Error', () async {
      final result = Error<String, int>(0).toAsyncResult();
      final futureValue = result.when(((success) => -1), (e) => e);
      expect(futureValue, completion(0));
    });
  });

  group('fold', () {
    test('Success', () async {
      final result = Success<int, String>(0).toAsyncResult();
      final futureValue = result.fold(((success) => success), (e) => -1);
      expect(futureValue, completion(0));
    });

    test('Error', () async {
      final result = Error<String, int>(0).toAsyncResult();
      final futureValue = result.fold(((success) => -1), (e) => e);
      expect(futureValue, completion(0));
    });
  });

  group('tryGetSuccess and tryGetError', () {
    test('Success', () async {
      final result = Success<int, String>(0).toAsyncResult();

      expect(result.isSuccess(), completion(true));
      expect(result.tryGetSuccess(), completion(0));
    });

    test('Error', () async {
      final result = Error<String, int>(0).toAsyncResult();

      expect(result.isError(), completion(true));
      expect(result.tryGetError(), completion(0));
    });
  });

  group('onSuccess', () {
    test('Success', () async {
      final result = Success<int, String>(0).toAsyncResult();
      expect(result.onSuccess((success) => success), completion(0));
    });

    test('Error', () async {
      final result = Error<String, int>(0).toAsyncResult();
      expect(result.onSuccess((success) => success), completion(isNull));
    });
  });

  group('onError', () {
    test('Success', () async {
      final result = Success<int, String>(0).toAsyncResult();
      expect(result.onError((error) => error), completion(isNull));
    });

    test('Error', () async {
      final result = Error<String, int>(0).toAsyncResult();
      expect(result.onError((error) => error), completion(0));
    });
  });
}
