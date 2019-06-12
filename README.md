`flutter_store` is a simple way for state management outside of Rendering Tree inspired by Flutter it self.

# Introduction
Why yet another state management? There are `Redux`, `MobX`, `BLoC` and other solution to manage state outside of the widgets tree. All those packages are great but for many scenarios quite opinionated:
- `Redux` uses a single store with actions and reducers etc.
- `MobX` while very clean and simple with react introduce quite a bit of boilerplate or require code generation.
- `BLoc` rely on streams and generally is quite opinionated about how we should design the business logic of the app.

If we think about it, Flutter already providing the state management features like `StatefulWidget` to store the states and `InheritedWIdget` to deliver our data to target widgets. But using those to also require quite a bit of the boilerplate.

The `flutter_store` works just like a `StatefulWidget` but existing outside of the widgets tree. It uses the same `setState` method (to be consistent with Flutter itself) to notify widgets that its state changed and `Provider` to pass our store throw the widgets tree. For example:

```dart
class _Counter extends Store {
  int value = 0;

  void increment() => setState(() {
    value += 1;
  });
}
```

For those who develop the app with Flutter, this code snippet should look very familiar. It works exactly like `StatefulWidget` and all widgets which rely on it, will be notified and updated.

# Usage
1. To create the our one store, we just need to extend the `Store` provided by `flutter_store` package.

```dart
class _Counter extends Store {
  int _value = 0;
  get value => _value;

  void increment() => setState(() {
    _value += 1;
  });
}
```
We do not want to update the value outside of the `setState` so we will make it private and access it via getter.

2. Now we will gonna pass our store down the widgets tree with the `Provider` widget. That way we will be able to access our store anywhere in the tree.

```dart
final _counter = _Counter();

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      store: _counter,
      child: MyChildWIdget()
    );
  }
}
```

3. Now, we can access our store anywhere in the widgets tree since the `Provider` is widget is just a wrapper around the `InheritedWidget`.

```dart
class MyChildWIdget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counter = Provider.of<_Counter>(context);
    return Text('${counter.value}');
  }
}
```

The `flutter_store` is not opinionated, so you can store any value inside the store. For example, you can turn your value to the stream and use store and provider to pass that stream to the target component (BLoc).


# Experimental
`flutter_store` also has `Cache` mixin inspired by MobX's `computed` decorator, but it does not rely on code generation.

```dart
class _Counter extends Store with Cache {
  int _value = 0;
  get value => _value;

  get valueStr => _valueStr(_valueStr);
  String _valueStr() => value.toString();

  void increment() => setState(() {
    _value += 1;
  });
}
```

The reason why this mixin is an `experimental` is:
1. The `Cache` mixing, using is using `LinkedHashMap` to store cached results, thus it does not make much sense to use the cache for simple methods like the one above from performance perspective.
2. The cache is using the method address as the cache key, thus, you cannot use the `anonymous functions` as the cache parameter, because in that case, the new function will be created on every cache call, which will lead to memory leaks. (should we also have named cached?..)
