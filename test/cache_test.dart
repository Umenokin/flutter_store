import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_store/flutter_store.dart';


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
  group('Cache', () {
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
