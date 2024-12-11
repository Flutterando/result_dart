import 'dart:io';

import 'package:result_dart/result_dart.dart';

void main(List<String> args) {
  final result = getTerminalInput() //
      .map(removeSpecialCharacteres)
      .flatMap(parseNumbers)
      .map(validateCPF);

  print('CPF Validator: ${result.isSuccess()}');
}

Result<String> getTerminalInput() {
  final text = stdin.readLineSync();
  if (text == null || text.isEmpty) {
    return const Failure(ValidatorException('Incorrect input'));
  }

  return Success(text);
}

String removeSpecialCharacteres(String input) {
  final reg = RegExp(r'(\D)');
  return input.replaceAll(reg, '');
}

Result<List<int>> parseNumbers(String input) {
  if (input.isEmpty) {
    return const Failure(ValidatorException('Input is Empty'));
  }

  try {
    final list = input.split('').map(int.parse).toList();
    return Success(list);
  } catch (e) {
    return const Failure(ValidatorException('Parse error'));
  }
}

bool validateCPF(List<int> numberDigits) {
  final secondRef = numberDigits.removeLast();
  final secondDigit = calculateDigit(numberDigits);
  if (secondRef != secondDigit) {
    return false;
  }

  final firstRef = numberDigits.removeLast();
  final firstDigit = calculateDigit(numberDigits);
  return firstRef == firstDigit;
}

int calculateDigit(List<int> digits) {
  final digitSum = sumDigits(digits.reversed.toList());
  final rest = digitSum % 11;
  if (rest < 2) {
    return 0;
  } else {
    return 11 - rest;
  }
}

int sumDigits(List<int> digits) {
  var multiplier = 2;
  var sum = 0;
  for (var d = 0; d < digits.length; d++, multiplier++) {
    sum += digits[d] * multiplier;
  }
  return sum;
}

class ValidatorException implements Exception {
  final String message;
  const ValidatorException(this.message);
}
