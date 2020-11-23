<p align="center">
<img src="https://image.flaticon.com/icons/png/512/235/235394.png"  width="200" alt="Raccoon
"></a>
</p>
<h1 align="center">Raccoon</h1>

<div align="center">

[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)]()
[![Status](https://img.shields.io/badge/status-active-success.svg)]()

</div>

<p align="center"> 
A complete and powerful flutter framework
<br></p>

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Dependency Injection](#dependency-injection)
- [State management](#state-management)
- [Firebase Integration](#firebase-integration)
- [Logger](#logger)
- [Localization](#localization)
- [Util](#util)
- [Todo](#todo)
- [Authors](#authors)

## Dependency Injection

The design of dependency injection is simply a global map. It is very easy to use.

```dart
class Bloc {
    final value = 0;
}

class AppModule extends Module {
    @override
    Future<void> initial() async {
      bind(Bloc());
    }

    @override
    Widget build(BuildContext context) {
      Bloc bloc = inject();
      return Container();      
    }
}
``` 

#### Module
To bind your dependencies, you just need to create a module subclass. This class would help you to handle the lifecycle of dependencies.

#### inject
To get the dependency, you can simply call inject(). The dependency will be kept until the module class is disposed.

## State management

Although stream is used to manage state, the usage is still as simple as ScopedModel.

```dart
class ColorBloc implements Disposable {
    final Data<Color> c1 = Data(Colors.red);
    final Data<Color> c2 = Data(Colors.blue);

    void changeColor() {
      c1.push(Color(Random().nextInt(0xFFFFFFFF)));
      c2.push(Color(Random().nextInt(0xFFFFFFFF)));
    } 

    @override
    void dispose() {
      c1.dispose();
      c2.dispose();
    }
}
```

#### Data
Data is wrapper of stream. You can update value by push() new value.
Also, it exposes two fields including a cache value and a stream, so you are free to get latest value easily
and listen to stream with your handler as you like. Remember to dispose every data.


## Firebase Integration

Although most services of firebase are very expensive, there are few stuffs including **analysis**, **crashlysis**, **performance** and **remote config**, which are great to use and totally free of charge.
These tools help us to monitor and debug the application conveniently.


All of them are integrated into our framework, please follow the set up in order to enable these features.

#### Android Set Up
android/build.gradle
```gradle
dependencies {
    classpath 'com.google.gms:google-services:4.3.3'
    classpath 'com.google.firebase:firebase-crashlytics-gradle:2.2.0'
    // ...  
```

android/app/build.gradle
```gradle
defaultConfig {
    // ...
    multiDexEnabled true
    // ...        

dependencies {
    // temporary fix for upstream bug from android sdk
    implementation 'com.google.firebase:firebase-analytics:18.0.0'
    implementation 'com.google.android.gms:play-services-basement:17.5.0'
    // ...

apply plugin: 'com.google.gms.google-services'
apply plugin: 'com.google.firebase.crashlytics'
```

## Logger

## Localization

## Util

## Responsiveness

## Todo

## Authors

- [@hokamc](https://github.com/hokamc)
