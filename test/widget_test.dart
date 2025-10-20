import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:template_app/presentation/widgets/cards/app_card.dart';

void main() {
  testWidgets('AppCard renders its child', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: AppCard(child: Text('Hello Template'))),
      ),
    );

    expect(find.text('Hello Template'), findsOneWidget);
  });
}
