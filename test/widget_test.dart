import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cv_generator_app/views/cv_form_screen.dart';

void main() {
  testWidgets('CV Form Screen load test', (WidgetTester tester) async {
    // App ko build karein
    await tester.pumpWidget(MaterialApp(home: CVFormScreen()));

    // Ye check karega ke screen par 'Full Name' wala field mojood hai ya nahi
    expect(find.text('Full Name'), findsOneWidget);

    // Ye check karega ke Generate button nazar aa raha hai
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
