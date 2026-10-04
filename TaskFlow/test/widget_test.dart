import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:taskflow/app.dart';
import 'package:taskflow/providers/app_provider.dart';

void main() {
  testWidgets('TaskFlow app loads successfully',
          (WidgetTester tester) async {
        // Build TaskFlow using the same provider setup as main.dart.
        await tester.pumpWidget(
          ChangeNotifierProvider(
            create: (_) => AppProvider(),
            child: const TaskFlowApp(),
          ),
        );

        // Allow the first frame to render.
        // This also allows the post-frame callback in SplashScreen
        // to start AppProvider initialization.
        await tester.pump();

        // Give initialization time to complete.
        //
        // We deliberately DO NOT use pumpAndSettle() here because
        // the splash screen contains a continuously repeating
        // pulse animation.
        await tester.pump(
          const Duration(seconds: 1),
        );

        // Move through the remaining splash-screen time.
        await tester.pump(
          const Duration(seconds: 3),
        );

        // Process the navigation from SplashScreen to HomeScreen.
        await tester.pump();

        // Verify that TaskFlow is running.
        expect(find.text('TaskFlow'), findsOneWidget);
      });

  testWidgets(
    'TaskFlow displays the main interface',
        (WidgetTester tester) async {
      // Build TaskFlow using the same provider setup as main.dart.
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => AppProvider(),
          child: const TaskFlowApp(),
        ),
      );

      // Allow the first frame to render.
      await tester.pump();

      // Allow initialization and the splash screen to progress.
      //
      // Do not use pumpAndSettle() because the logo pulse
      // animation intentionally repeats forever.
      await tester.pump(
        const Duration(seconds: 1),
      );

      // Complete the 3-second splash delay.
      await tester.pump(
        const Duration(seconds: 3),
      );

      // Process the route replacement to HomeScreen.
      await tester.pump();

      // Verify that the main TaskFlow interface is displayed.
      expect(find.text('TaskFlow'), findsOneWidget);
    },
  );
}