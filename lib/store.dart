import 'package:meta/meta.dart';

class Store {
  final _listeners = Set<Function>();

  /// Called when the the [Store] state has chaned.
  /// You can use this method to react to [Store]'s state changes.
  /// You should not call [setState] inside of [storeDidUpdate], but rather apply side some effects.
  /// For example, [Cache] mixin use this method to notify that store changed and cached results should be cleaned.
  @protected
  @mustCallSuper
  storeDidUpdate() {
    _notifyListeners();
  }

  /// Wraps the [func] which changing one or more store states and notify all listeners once [func] has been completed.
  ///
  /// ```dart
  /// class _Counter extends Store {
  ///   int _value = 0;
  ///   get value => _value;
  ///
  ///   void increment() => setState(() {
  ///     _value += 1;
  ///   });
  /// }
  /// ```
  setState(Function func) {
    func();
    storeDidUpdate();
  }

  /// Adds a [listener] to the store which will be notified once the store has changed
  addListener(Function listener) {
    _listeners.add(listener);
  }

  removeListener(Function listener) {
    _listeners.remove(listener);
  }

  _notifyListeners() {
    _listeners.forEach((listener) => listener());
  }
}
