import 'package:flutter/material.dart';
import 'package:game_clock/features/clock/domain/usecases/reset_clock.dart';
import 'package:game_clock/features/clock/domain/usecases/start_clock.dart';
import 'package:game_clock/features/clock/domain/usecases/stop_clock.dart';
import 'package:game_clock/features/clock/presentation/widget/global_timer.dart';

class GlobalClock extends StatelessWidget {
  const GlobalClock({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
          child: Transform.scale(scale: 0.7, child: GlobalTimer()),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: StartClockButton(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: StopClockButton(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ResetClockButton(),
            ),
          ],
        ),
      ],);
  }
}
