// import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

import './store.dart';

/// Returns the type [T].
Type _typeOf<T>() => T;

/// The Provider widget which will pass our Store down the Widget tree.
class Provider<T extends Store> extends StatefulWidget {
  /// The reference to our store class.
  final T store;

  /// Child widget which will be able to inherit our store. It could the whole application tree or small set of widgets
  final Widget child;

  Provider({
    Key key,
    @required this.store,
    @required this.child,
  })  : assert(store != null),
        assert(child != null),
        super(key: key);

  @override
  _ProviderState<T> createState() => _ProviderState<T>();

  /// Give access to our store anywhere in the widget tree
  ///
  ///```dart
  /// class _Counter extends Store {
  ///   int _value = 0;
  ///   get value => _value;
  ///
  ///  void increment() => setState(() {
  ///    _value += 1;
  ///   });
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   final counter = Provider.of<_Counter>(context);
  ///   return Text('${counter.value}');
  /// }
  ///```
  static T of<T extends Store>(BuildContext context) {
    final type = _typeOf<_InheritedProvider<T>>();
    final _InheritedProvider<T> provider =
        context.inheritFromWidgetOfExactType(type);

    if (provider == null) {
      throw ProviderNotFoundError(T, context.widget.runtimeType);
    }

    return provider.store;
  }
}

/// Provider's state. This class is responsible for listening the store's changes and calling its own [setState]
class _ProviderState<T extends Store> extends State<Provider> {
  @override
  void initState() {
    super.initState();
    widget.store.addListener(_listener);
  }

  @override
  void dispose() {
    widget.store.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedProvider<T>(
      store: widget.store,
      child: widget.child,
    );
  }

  _listener() {
    this.setState(() {});
  }
}

/// Inherited widget which would be used to pass the store to the target component.
class _InheritedProvider<T extends Store> extends InheritedWidget {
  final T store;

  _InheritedProvider({
    Key key,
    @required this.store,
    @required Widget child,
  })  : assert(child != null),
        assert(store != null),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedProvider<T> oldWidget) {
    return true;
  }
}

class ProviderNotFoundError extends Error {
  /// The type of the value being retrieved
  final Type valueType;

  /// The type of the Widget requesting the value
  final Type widgetType;

  /// Create a ProviderNotFound error with the type represented as a String.
  ProviderNotFoundError(
    this.valueType,
    this.widgetType,
  );

  @override
  String toString() {
    return 'Error: Could not find the correct Provider<$valueType> above this $widgetType Widget';
  }
}
