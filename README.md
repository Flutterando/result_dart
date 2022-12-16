<a name="readme-top"></a>


<h1 align="center">RESULT_DART</h1>

<!-- PROJECT LOGO -->
<br />
<!-- <div align="center">
  <a href="https://github.com/Flutterando/README-Template/">
    <img src="https://raw.githubusercontent.com/Flutterando/README-Template/master/readme_assets/logo.png" alt="Logo" width="180">
  </a> -->

  <p align="center">
    This package aims to create an implemetation of <b>Kotlin's and Swift's Result function</b>.
    Inspired by Higor Lapa's <a href='https://pub.dev/packages/multiple_result'>multiple_result</a> package, the DartZ package and the FpDart package.  
    <br />
    <!-- Put the link for the documentation here -->
    <a href="https://pub.dev/publishers/flutterando.com.br/packages"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <!-- Disable unused links with with comments -->
    <a href="https://github.com/Flutterando/result_dart/issues">Report Bug</a>
    ·
    <a href="https://github.com/Flutterando/result_dart/pulls">Request Feature</a>
  </p>

<br>

<div align='center'>

[![Version](https://img.shields.io/github/v/release/flutterando/result_dart?style=plastic)](https://pub.dev/packages/result_dart)
[![Pub Points](https://img.shields.io/pub/points/result_dart?label=pub%20points&style=plastic)](https://pub.dev/packages/result_dart/score)
[![Flutterando Analysis](https://img.shields.io/badge/style-flutterando__analysis-blueviolet?style=plastic)](https://pub.dev/packages/flutterando_analysis/)

[![Pub Publisher](https://img.shields.io/pub/publisher/result_dart?style=plastic)](https://pub.dev/publishers/flutterando.com.br/packages)


</div>

<br>

---
<!-- TABLE OF CONTENTS -->
<!-- Linked to every ## title below -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li><a href="#about-the-project">About The Project</a></li>
    <li><a href="#sponsors">Sponsors</a></li>
    <li><a href="#getting-started">Getting Started</a></li>
    <li><a href="#how-to-use">How to Use</a></li>
    <li><a href="#features">Features</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgements">Acknowledgements</a></li>
  </ol>
</details>

---

<br>

<!-- ABOUT THE PROJECT -->
## About The Project


<!-- PROJECT EXAMPLE (IMAGE) -->

<br>
<!-- <Center>
<img src="https://raw.githubusercontent.com/Flutterando/README-Template/master/readme_assets/project-image.png" alt="Project Screenshot" width="400">
</Center> -->

<br>

<!-- PROJECT DESCRIPTION -->

TODO: DESCRIÇÃO MAIS LONGA DO FUNCIONAMENTO DO PACKAGE

<i>This project is distributed under the MIT License. See `LICENSE` for more information.
</i>

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- SPONSORS -->
<!-- For now FTeam is the only sponsor for Flutterando packages. The community is open to more support for it's open source endeavors, so check it out and make contact with us through the links provided at the end -->
## Sponsors

<a href="https://fteam.dev">
    <img src="https://raw.githubusercontent.com/Flutterando/README-Template/master/readme_assets/sponsor-logo.png" alt="Logo" width="120">
  </a>

<p align="right">(<a href="#readme-top">back to top</a>)</p>
<br>


<!-- GETTING STARTED -->
## Getting Started

<!---- The description provided below was aimed to show how to install a pub.dev package, change it as you see fit for your project ---->
To get your_package in your project follow either of the instructions below:

a) Add your_package as a dependency in your Pubspec.yaml:
 ```yaml
   dependencies:
     result_dart: ^1.0.0
``` 

b) Use Dart Pub:
```
  dart pub add result_dart
```

<br>


## How to Use


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

### Transforming a Result

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

### Unit Type

Some results do not need a specific return. Use the Unit type to signal an empty return.

```dart
    Result<Unit, Exception>
```

### Help with functions that return their parameter:

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

### Use **AsyncResult** type:

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
<br>

<!-- _For more examples, please refer to the_ [Documentation]()  -->

<!---- You can use the emoji 🚧 to indicate Work In Progress sections ---->

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- FEATURES -->

<!---- Marcar com ✅ o que foi feito
e 🚧 para o que está sendo trabalhado ---->
## Features

- ✅ Main Feature
- ✅ Side Feature
- ✅ Other Feature
- 🚧 Documentation
- 🚧 Other Features 

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the appropriate tag. 
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

Remember to include a tag, and to follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) and [Semantic Versioning](https://semver.org/) when uploading your commit and/or creating the issue. 

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTACT -->

<!---- Those are the current Flutterando contacts as of 25 August 2022 --->
## Contact

Flutterando Community
- [Discord](https://discord.gg/qNBDHNARja)
- [Telegram](https://t.me/flutterando)
- [Website](https://www.flutterando.com.br)
- [Youtube Channel](https://www.youtube.com.br/flutterando)
- [Other useful links](https://linktr.ee/flutterando)


<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements 


Thank you to all the people who contributed to this project, whithout you this project would not be here today.

<br>

<!---- Change the link below to the contributors page of your project and change the repo= in the img src to properly point to your repository -->

<a href="https://github.com/flutterando/result_dart/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=flutterando/result_dart" />
</a>


<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MANTAINED BY -->
## Maintaned by

<br>
<p align="center">
  <a href="https://www.flutterando.com.br">
    <img width="110px" src="https://raw.githubusercontent.com/Flutterando/README-Template/master/readme_assets/logo-flutterando.png">
  </a>
  <p align="center">
    Built and maintained by <a href="https://www.flutterando.com.br">Flutterando</a>.
  </p>
</p>