import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cocuk_oyun/main.dart';

void main() {
  testWidgets('shows the initial app shell without counter demo', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CocukOyunApp());

    expect(find.text('Cocuk Oyun'), findsOneWidget);
    expect(find.text('Boyama'), findsOneWidget);
    expect(find.text('Sayfa 1'), findsOneWidget);
    expect(find.text('0'), findsNothing);
    expect(find.byIcon(Icons.add), findsNothing);
  });
}
