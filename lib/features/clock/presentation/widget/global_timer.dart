import 'package:flutter/material.dart';
import 'package:flutter_game_clock/core/strings/widgets_keys.dart';
import 'package:flutter_game_clock/core/util/utils.dart';
import 'package:flutter_game_clock/features/clock/data/datasources/stopwatch_provider.dart';
import 'package:flutter_game_clock/injection_container.dart';
import 'package:google_fonts/google_fonts.dart';

class GlobalTimer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final StopwatchProvider stopwatchProvider = sl();

    return Container(
      key: Key(GLOBAL_TIMER),
      child: Tooltip(
        message: 'Display global clock',
        child: StreamBuilder<Duration>(
          stream: stopwatchProvider.stream,
          builder: (context, snapshot) {
            if(!snapshot.hasData) return CircularProgressIndicator();
            return Text(
              prettyPrintDuration(snapshot.data),
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                fontSize: 60,
                color: Colors.black,
              ),
            );
          }
        ),
      ),
    );
  }
}
