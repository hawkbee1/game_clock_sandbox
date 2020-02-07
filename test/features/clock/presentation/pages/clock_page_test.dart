import 'package:flutter/material.dart';
import 'package:flutter_game_clock/features/clock/data/datasources/stopwatch_provider.dart';
import 'package:flutter_game_clock/features/clock/domain/repositories/active_player_repository.dart';
import 'package:flutter_game_clock/injection_container.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_game_clock/core/strings/widgets_keys.dart';
import 'package:flutter_game_clock/features/clock/presentation/pages/clock_page.dart';
import 'package:flutter_game_clock/injection_container.dart' as di;

void main() {

  group('test login page is correctly displayed', () {

    testWidgets('check label elements of login page are here', (WidgetTester tester) async {
      await di.init();
      await tester.pumpWidget(MyClockPage());
      final clockFinder = find.byKey(Key(GLOBAL_TIMER));
      final buttonsFinder = find.byType(FloatingActionButton);

      expect(clockFinder, findsOneWidget);
      expect(buttonsFinder, findsNWidgets(5));
      final StopwatchProvider _stopwatchProvider = sl();
      final ActivePlayer _activePlayer = sl();
      _stopwatchProvider.dispose();
      _activePlayer.dispose();
    });
  });

}

class MyClockPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Where Assistant',
      home: ClockPage(),);
  }
}