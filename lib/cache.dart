import 'store.dart';

typedef CacheableFunc<T> = T Function();

class _CacheHolder<T> {
  bool dirty = true;
  T value;

  reset() {
    dirty = true;
    value = null;
  }
}

/// Mixin for the [Store] adding caching features
mixin Cache on Store {
  final _cacheHolders = Map<Function, _CacheHolder>();

  @override
  storeDidUpdate() {
    super.storeDidUpdate();
    _invalidateCaches();
  }

  /// Will cache calculation result of the passed [func].
  ///
  /// Example:
  /// ```dart
  /// class CachedCounterStore extends Store with Cache {
  ///   String _firstName = '';
  ///   String _lastName = '';
  ///
  ///   String get fullName => cache(_fullName);
  ///   String get _fullName = `$_firstName $_lastName`
  ///
  ///   set firstName(String name) => setState(() {
  ///     _firstName += 1;
  ///   });
  ///
  ///   set lastName(String name) => setState(() {
  ///     _lastName += 1;
  ///   });
  /// }
  ///```
  /// The moment use will call the [fullName] getter, the private [_fullName] getter will be called and the result
  /// will be cached. And on the next [fullName] getter call, the value will be taken from cache.
  /// This is useful for heavy methods. For example we get the list of users from our API and want to be able to access
  /// each user by ID. One way how we can do this is to store to sets of data
  /// where one is the list and another is the map:
  /// ```dart
  /// List<User> get usersList => _usersList;
  /// Map<String, User> get usersById => _usersById;
  /// ```
  /// But in that case, we will have to calculate the Map every time we getting users from our API and every time
  /// we update the _usersList. Instead, we can run calculate the [Map] only when we want to use it
  /// it and will be automatically recalculated again, once we change the state of them _usersList.
  T cache<T>(CacheableFunc<T> func) {
    _CacheHolder<T> holder = _cacheHolders[func];
    if (holder == null) {
      holder = _CacheHolder<T>();
      _cacheHolders[func] = holder;
    }

    // Use dirty in case of nullable value because users might want to cache the NULL.
    if (holder.dirty) {
      holder.value = func();
      holder.dirty = false;
    }

    return holder.value;
  }

  _invalidateCaches() {
    _cacheHolders.values.forEach((holder) => holder.reset());
  }
}
