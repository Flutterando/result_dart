import 'package:result_dart/result_dart.dart';
import 'package:test/test.dart';

void main() {
  test('result dart base ...', () {
    final result = const Success(0).pureFold(1, 's');

    expect(result, isA<Success<int, String>>());
    expect(result.getOrThrow(), 1);
  });
}
