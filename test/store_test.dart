import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_store/flutter_store.dart';

class CounterStore extends Store {
  int value = 0;

  increment() => setState(() {
    value += 1;
  });
}

class CachedCounterStore extends Store with Cache {
  int callCounter = 0;
  int value = 0;

  String get stringValue => cache(_stringValue);
  String _stringValue() {
    callCounter += 1;
    return 'value-$value';
  }

  increment() => setState(() {
    value += 1;
  });
}

void main() {
  group('Store', () {
    test('store should notify listeners on every state change', () {
      final counter = CounterStore();
      int callsCount = 0;
      counter.addListener(() => callsCount += 1);

      counter.increment();
      counter.increment();

      expect(callsCount, equals(2));
    });

    test('store should notify all listeners', () {
      final counter = CounterStore();
      int callsCount = 0;
      counter.addListener(() => callsCount += 1);
      counter.addListener(() => callsCount += 1);

      counter.increment();

      expect(callsCount, equals(2));
    });
  });

  group('Cache tests', () {
    test('until store state has been changed, the cached property should always get values from cache', () {
      final counter = CachedCounterStore();
      expect(counter.callCounter, equals(0));
      expect(counter.stringValue, equals('value-0'));
      expect(counter.callCounter, equals(1));
      expect(counter.stringValue, equals('value-0'));
      expect(counter.callCounter, equals(1));
      expect(counter.stringValue, equals('value-0'));

      counter.increment();
      expect(counter.callCounter, equals(1));
      expect(counter.stringValue, equals('value-1'));
      expect(counter.callCounter, equals(2));
      expect(counter.stringValue, equals('value-1'));
      expect(counter.callCounter, equals(2));
      expect(counter.stringValue, equals('value-1'));
    });
  });
}
