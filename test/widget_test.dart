// Basic smoke test: the home screen boots and shows the counter card and
// the "iltifat ekle" FAB without throwing.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:iltifat_sayar/app.dart';

void main() {
  testWidgets('İltifatSayar home screen boots', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const IltifatSayarApp());
    await tester.pumpAndSettle();

    expect(find.text('İltifatSayar'), findsOneWidget);
    expect(find.text('bu ay biriktirdiklerin'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
