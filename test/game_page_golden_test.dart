import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_clock_sandbox/pages/game_page.dart';
import 'package:game_clock_sandbox/state/game_notifier.dart';
import 'package:game_clock_sandbox/models/game_state.dart';
import 'package:game_clock_sandbox/models/player.dart';
import 'package:game_clock_sandbox/services/color_generator.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

/// Design Pattern: Factory Method (Custom Devices)
/// Centralizes the creation of Device configurations for different platforms
/// and screen sizes as requested.
class DeviceConfigFactory {
  static const Device androidPhone = Device(
    name: 'android_phone',
    size: Size(411, 823),
    devicePixelRatio: 3.0,
  );

  static const Device androidSmall = Device(
    name: 'android_small',
    size: Size(320, 533),
    devicePixelRatio: 2.0,
  );

  static const Device androidTablet = Device(
    name: 'android_tablet',
    size: Size(800, 1280),
    devicePixelRatio: 2.0,
    textScale: 1.5,
  );

  static const Device iosPhone = Device(
    name: 'ios_phone',
    size: Size(390, 844),
    devicePixelRatio: 3.0,
  );

  static const Device iosSmall = Device(
    name: 'ios_small',
    size: Size(320, 568),
    devicePixelRatio: 2.0,
  );

  static const Device iosTablet = Device(
    name: 'ios_tablet',
    size: Size(1024, 1366),
    devicePixelRatio: 2.0,
    textScale: 1.5,
  );

  static List<Device> get allDevices => [
    androidPhone,
    androidSmall,
    androidTablet,
    iosPhone,
    iosSmall,
    iosTablet,
  ];
}

void main() {
  setUpAll(() async {
    // Load Roboto font from assets for the goldens.
    await loadAppFonts();
  });

  group('GamePage Golden Tests', () {
    testGoldens('GamePage - Initial State (Paused)', (tester) async {
      // Design Pattern: Builder (DeviceBuilder from golden_toolkit)
      // Used to construct a multi-device comparison snapshot.
      final builder = DeviceBuilder()
        ..overrideDevicesForAllScenarios(
          devices: DeviceConfigFactory.allDevices,
        )
        ..addScenario(
          name: 'Initial State',
          widget: ProviderScope(
            overrides: [
              gameNotifierProvider.overrideWith(
                (ref) => GameNotifier(
                  colorGenerator: FixedColorGenerator([
                    Colors.blue,
                    Colors.red,
                    Colors.green,
                    Colors.yellow,
                    Colors.purple,
                  ]),
                ),
              ),
            ],
            child: const GamePage(),
          ),
        );

      await tester.pumpDeviceBuilder(builder);

      await screenMatchesGolden(tester, 'game_page_initial_state');
    });

    testGoldens('GamePage - Running State', (tester) async {
      final runningState = GameState(
        isRunning: true,
        gameElapsed: const Duration(minutes: 12, seconds: 34),
        players: [
          const Player(
            id: '1',
            name: 'Player 1',
            color: Colors.blue,
            elapsed: Duration(minutes: 5),
          ),
          const Player(
            id: '2',
            name: 'Player 2',
            color: Colors.red,
            elapsed: Duration(minutes: 7, seconds: 34),
          ),
        ],
        currentPlayerIndex: 1,
      );

      final builder = DeviceBuilder()
        ..overrideDevicesForAllScenarios(
          devices: DeviceConfigFactory.allDevices,
        )
        ..addScenario(
          name: 'Running State',
          widget: ProviderScope(
            overrides: [
              gameNotifierProvider.overrideWith(
                (ref) => GameNotifier()..state = runningState,
              ),
            ],
            child: const GamePage(),
          ),
        );

      await tester.pumpDeviceBuilder(builder);

      await screenMatchesGolden(tester, 'game_page_running_state');
    });
  });
}
