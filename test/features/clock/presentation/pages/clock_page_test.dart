import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_clock/core/strings/widgets_keys.dart';
import 'package:game_clock/features/clock/presentation/pages/clock_page.dart';

void main() {

  group('test login page is correctly displayed', () {

    testWidgets('check label elements of login page are here', (WidgetTester tester) async {
      await tester.pumpWidget(MyClockPage());
      final clockFinder = find.byKey(Key(CLOCK));
      final buttonsFinder = find.byType(FloatingActionButton);

      expect(clockFinder, findsOneWidget);
      expect(buttonsFinder, findsNWidgets(2));

    });
  });

}

class MyClockPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Where Assistant',
      home: ClockPage(title: 'toto',),);
  }
}