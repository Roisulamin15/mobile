import 'package:capstonemobile/halaman_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('HalamanLoginScreen has a login button and text fields', (WidgetTester tester) async {
    // Build the HalamanLoginScreen widget
    await tester.pumpWidget(
      MaterialApp(
        home: HalamanLoginScreen(),
      ),
    );

    // Verify if the login button exists
    expect(find.text('Login'), findsOneWidget);

    // Verify if the username and password text fields exist
    expect(find.byType(TextField), findsNWidgets(2)); // Expecting two TextField widgets
  });
}
