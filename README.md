# flutter_store

`flutter_store` is a simple way for state management outside of Rendering Tree inspired by Flutter it self.

## Introduction
Why yet another state management? There are `Redux`, `MobX`, `BLoC` and other solution to manage state outside of the widgets tree. All those packages are great but for many scenarios quite opinionated:
- `Redux` uses a single store with actions and reducers etc.
- `MobX` while very clean and simple with react introduce quite a bit of boilerplate or require code generation.
- `BLoc` rely on streams and generally is quite opinionated about how we should design the business logic of the app.

If we think about, Flutter already providing state management features like `StatefulWidget` to store the states and `InheritedWIdget` to deliver our data to target widgets. But using those to also require quite a bit of the boilerplate.

The `flutter_store` is just like a `StatefulWidget` but existing outside of the widgets tree. It uses the same `setState` method to notify widgets that its state changed and `Provider` to pass our store throw the widgets tree. For example:



```dart
class _Counter extends Store {
  int value = 0;

  void increment() => setState(() {
    value += 1;
  });
}
```

For those who develop the app with Flutter, this code snippet should look very familiar. It works exactly like `StatefulWidget` and all widgets which rely on it be notified and updated.
