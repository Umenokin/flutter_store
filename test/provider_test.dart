import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_store/flutter_store.dart';

class CounterStore extends Store {
  int value = 0;

  increment() => setState(() {
    value += 1;
  });
}

class TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counter = Provider.of<CounterStore>(context);
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(counter.value.toString()),
        ),
      ),
    );
  }
}

class CachingStore extends Store with Cache {
  int value = 0;
  int callCount = 0;

  String get stringValue => cache(_stringValue);
  String _stringValue() {
    callCount += 1;
    return value.toString();
  }

  increment() => setState(() {
    value += 1;
  });
}

class CachingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counter = Provider.of<CachingStore>(context);
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(counter.stringValue),
        ),
      ),
    );
  }
}

void main() {
  group('Provider', () {
    testWidgets('widget should be updated once dependency store has changed', (tester) async {
      final counter = CounterStore();

      await tester.pumpWidget(Provider<CounterStore>(store: counter, child: TestWidget()));
      expect(find.text('0'), findsOneWidget);

      counter.increment();
      await tester.pump();
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('rerendered component should use cached value if store has not been changed', (tester) async {
      final counter = CachingStore();

      await tester.pumpWidget(Provider<CachingStore>(store: counter, child: CachingWidget()));
      expect(find.text('0'), findsOneWidget);
      expect(counter.value, equals(0));
      expect(counter.callCount, equals(1));
      await tester.pump();
      // Cached function should not been called after re-rendering
      expect(counter.callCount, equals(1));

      counter.increment();
      await tester.pump();
      expect(find.text('1'), findsOneWidget);
      expect(counter.value, equals(1));
      expect(counter.callCount, equals(2));
      await tester.pump();
      expect(counter.callCount, equals(2));
    });

    testWidgets('The Provider should throw the exception, if no store was provided', (tester) async {
      await tester.pumpWidget(TestWidget());
      expect(tester.takeException(), isInstanceOf<ProviderNotFoundError>());
    });
  });
}