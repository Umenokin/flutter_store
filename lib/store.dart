class Store {
  final _listeners = Set<Function>();

  storeDidUpdate() {
    _notifyListeners();
  }

  setState(Function callback) {
    callback();
    storeDidUpdate();
  }

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