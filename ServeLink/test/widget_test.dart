import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:serve_link/main.dart';

void main() {
  testWidgets('ServeLink app loads successfully', (WidgetTester tester) async {
    // Build the ServeLink application.
    await tester.pumpWidget(const ServeLinkApp());

    // Allow the initial widget frame and splash animation to render.
    await tester.pump();

    // Verify that the ServeLink application is running.
    expect(find.byType(ServeLinkApp), findsOneWidget);

    // Verify that the splash screen is displayed.
    expect(find.text('ServeLink'), findsOneWidget);
    expect(find.text('Connect. Request. Serve.'), findsOneWidget);

    // Remove the widget tree before the 3-second splash delay completes.
    // This prevents the test from reaching FirebaseAuth.instance.
    await tester.pumpWidget(const SizedBox());
  });
}