# multiple_result

Result package for dart inspired by the work of [dartz](https://pub.dev/packages/dartz)'s Either and Kotlin's sealed classes.

This package is perfect to those of you who just want the Multiple results
functionality from dartz. 👌

##### Old version:

If you're looking for a non null-safety version, you can find it in [here](https://github.com/higorlapa/result/tree/no-null-safety)


## Use **Result** type:

In the return of a function, set it to return a Result type;
```dart
Result getSomethingPretty();
```
then add the Success and the Error types.

```dart

Result<String, Exception> getSomethingPretty() {

}

```

in return of the function, you just need to return
```dart
// Normal instance
return Success('Something Pretty');

// Result factory
return Result.success('Something Pretty');

// Using extensions
return 'Something Pretty'.toSuccess();
```

or

```dart
// Normal instance
return Error(Exception('something ugly happened...'));

// Result factory
return Result.error('something ugly happened...');

// Using extensions
return 'something ugly happened...'.toError();
```

The function should look something like this:

```dart

Result<String, Exception> getSomethingPretty() {
    if(isOk) {
        return Success('OK!');
    } else {
        return Error(Exception('Not Ok!'));
    }
}

```
or this (using extensions):

```dart

Result<String, Exception> getSomethingPretty() {
    if(isOk) {
        return 'OK!'.toSuccess();
    } else {
        return Exception('Not Ok!').toError();
    }
}

```

> NOTE: The `toSuccess()` and `toError()` methods cannot be used on a `Result` object or a `Future`. If you try, will be throw a Assertion Error.

<br>

#### Handling the Result with `when` or `fold`:

```dart
void main() {
    final result = getSomethingPretty();
     final String message = result.when(
        (success) {
          // handle the success here
          return "success";
        },
         (error) {
          // handle the error here
          return "error";
        },
    );

}
```
** OBS: As we are going through a transition process, the `when` and `fold` syntax are identical. 
Use whichever one you feel most comfortable with and help us figure out which one should remain in the pack.


#### Handling the Result with `onSuccess` or `onError`

```dart 
    final result = getSomethingPretty();
    // notice the [onSuccess] or [onError] will only be executed if
    // the result is a Success or an Error respectivaly. 
    final output = result.onSuccess((name) {
        // handle here the success
        return "";
    });
    
    final result = getSomethingPretty();
    
    // [result] is NOT an Error, this [output] will be null.
    final output = result.onError((exception) {
        // handle here the error
        return "";
    });
```

#### Handling the Result with `tryGetSuccess`

```dart
void main() {
    final result = getSomethingPretty();

    String? mySuccessResult;
    if (result.isSuccess()) {
      mySuccessResult = result.tryGetSuccess();
    }
}

```


#### Handling the Result with `tryGetError`

```dart
void main() {
    final result = getSomethingPretty();

    Exception? myException;
    if (result.isError()) {
      myException = result.tryGetError();
    }
}
```

## Transforming a Result

#### Mapping success value with `map`

```dart
void main() {
    final result = getResult()
        .map((e) => MyObject.fromMap(e));

    result.tryGetSuccess(); //Instance of 'MyObject' 
}
```

#### Mapping error value with `mapError`

```dart
void main() {
    final result = getResult()
        .mapError((e) => MyException(e));

    result.tryGetError(); //Instance of 'MyException'

}
```

#### Chain others [Result] by any `Success` value with `flatMap`

```dart

Result<String, MyException> checkIsEven(String input){
    if(input % 2 == 0){
        return Success(input);
    } else {
        return Error(MyException('isn`t even!'));
    }
}

void main() {
    final result = getNumberResult()
        .flatMap((s) => checkIsEven(s));
}
```
#### Chain others [Result] by `Error` value with `flatMapError`

```dart

void main() {
    final result = getNumberResult()
        .flatMapError((e) => checkError(e));
}
```

#### Add a pure `Success` value with `pure`

```dart
void main() {
    final result = getSomethingPretty().pure(10);

    String? mySuccessResult;
    if (result.isSuccess()) {
      mySuccessResult = result.tryGetSuccess(); // 10
    }
}
```

#### Add a pure `Error` value with `pureError`

```dart
void main() {
    final result = getSomethingPretty().pureError(10);
    if (result.isError()) {
       result.tryGetError(); // 10
    }
}
```
#### Swap a `Result` with `swap`

```dart
void main() {
    Result<String, int> result =...;
    Result<int, String> newResult = result.swap();
}
```

## Unit Type

Some results do not need a specific return. Use the Unit type to signal an empty return.

```dart
    Result<Unit, Exception>
```

## Help with functions that return their parameter:

Sometimes it is necessary to return the parameter of the function as in this example:
```dart
final result = Success<int, String>(0);

String value = result.when((s) => '$s', (e) => e);
print(string) // "0";
```
Now we can use the `identity` function or its acronym `id` to facilitate the declaration of this type of function that returns its own parameter and does nothing else:
```dart
final result = Success<int, String>(0);

// changed `(e) => e` by `id`
String value = result.when((s) => '$s', id);
print(string) // "0";
```

## Use **AsyncResult** type:

`AsyncResult<S, E>` represents an asynchronous computation.
Use this component when working with asynchronous **Result**.

**AsyncResult** has some of the operators of the **Result** object to perform data transformations (**Success** or **Error**) before executing the Future.

All **Result** operators is available in **AsyncResult**

`AsyncResult<S, E>` is a **typedef** of `Future<Result<S, E>>`.

```dart

AsyncResult<String, Exception> fetchProducts() async {
    try {
      final response = await dio.get('/products');
      final products = ProductModel.fromList(response.data);
      return Success(products);
    } on DioError catch (e) {
      return Error(ProductException(e.message));
    }
}

...

final state = await fetch()
    .map((products) => LoadedState(products))
    .mapLeft((error) => ErrorState(error))

```