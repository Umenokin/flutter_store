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

mixin Cache on Store {
  final Map<Function, _CacheHolder> _cacheHolders = Map<Function, _CacheHolder>();

  storeDidUpdate() {
    super.storeDidUpdate();
    _invalidateCaches();
  }

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