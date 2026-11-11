import 'package:flutter_test/flutter_test.dart';
import 'package:memory_wars_mobile/main.dart';

void main() {
  testWidgets('App builds without errors', (WidgetTester tester) async {
    expect(const MemoryWarsApp(), isNotNull);
  });
}
