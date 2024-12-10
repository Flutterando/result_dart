import 'package:result_dart/functions.dart';
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
          .flatMapError((error) async => Failure((error as int) * 2));
      expect(result.exceptionOrNull(), 2);
    });

    test('sink', () async {
      final result = await const Failure(1) //
          .toAsyncResult()
          .flatMapError((error) => Failure((error as int) * 2));
      expect(result.exceptionOrNull(), 2);
    });
  });

  test('map', () async {
    final result = await const Success(1) //
        .toAsyncResult()
        .map((success) => success * 2);

    expect(result.getOrNull(), 2);
    expect(const Failure(2).toAsyncResult().map(identity), completes);
  });

  test('mapError', () async {
    final result = await const Failure(1) //
        .toAsyncResult()
        .mapError((error) => (error as int) * 2);
    expect(result.exceptionOrNull(), 2);
    expect(const Success(2).toAsyncResult().mapError(identity), completes);
  });

  test('pure', () async {
    final result = await const Success(1).toAsyncResult().pure(10);

    expect(result.getOrNull(), 10);
  });
  test('pureError', () async {
    final result = await const Failure(1).toAsyncResult().pureError(10);

    expect(result.exceptionOrNull(), 10);
  });

  group('fold', () {
    test('Success', () async {
      final result = const Success<int>(0).toAsyncResult();
      final futureValue = result.fold(id, (e) => -1);
      expect(futureValue, completion(0));
    });

    test('Error', () async {
      final result = const Failure<String>(0).toAsyncResult();
      final futureValue = result.fold(identity, (e) => e);
      expect(futureValue, completion(0));
    });
  });

  group('tryGetSuccess and tryGetError', () {
    test('Success', () async {
      final result = const Success<int>(0).toAsyncResult();

      expect(result.isSuccess(), completion(true));
      expect(result.getOrNull(), completion(0));
    });

    test('Error', () async {
      final result = const Failure<String>(0).toAsyncResult();

      expect(result.isError(), completion(true));
      expect(result.exceptionOrNull(), completion(0));
    });
  });

  group('getOrThrow', () {
    test('Success', () {
      final result = const Success<int>(0).toAsyncResult();
      expect(result.getOrThrow(), completion(0));
    });

    test('Error', () {
      final result = const Failure<String>(0).toAsyncResult();
      expect(result.getOrThrow(), throwsA(0));
    });
  });

  group('getOrElse', () {
    test('Success', () {
      final result = const Success<int>(0).toAsyncResult();
      final value = result.getOrElse((f) => -1);
      expect(value, completion(0));
    });

    test('Error', () {
      final result = const Failure<int>(0).toAsyncResult();
      final value = result.getOrElse((f) => 2);
      expect(value, completion(2));
    });
  });

  group('getOrDefault', () {
    test('Success', () {
      final result = const Success<int>(0).toAsyncResult();
      final value = result.getOrDefault(-1);
      expect(value, completion(0));
    });

    test('Error', () {
      final result = const Failure<int>(0).toAsyncResult();
      final value = result.getOrDefault(2);
      expect(value, completion(2));
    });
  });

  group('recover', () {
    test('Success', () {
      final result = const Success<int>(0) //
          .toAsyncResult()
          .recover((f) => const Success(1));
      expect(result.getOrThrow(), completion(0));
    });

    test('Error', () {
      final result = const Failure<int>('failure') //
          .toAsyncResult()
          .recover((f) => const Success(1));
      expect(result.getOrThrow(), completion(1));
    });
  });

  group('onSuccess', () {
    test('Success', () {
      const Success<int>(0) //
          .toAsyncResult()
          .onFailure((failure) {})
          .onSuccess(
        expectAsync1(
          (value) {
            expect(value, 0);
          },
        ),
      );
    });

    test('Error', () {
      const Failure<int>('failure') //
          .toAsyncResult()
          .onSuccess((success) {})
          .onFailure(
        expectAsync1(
          (value) {
            expect(value, 'failure');
          },
        ),
      );
    });
  });
}
