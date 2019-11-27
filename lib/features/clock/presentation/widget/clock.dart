import 'package:flutter/material.dart';
import 'package:game_clock/core/strings/widgets_keys.dart';
import 'package:game_clock/core/util/utils.dart';

class Clock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key(CLOCK),
      child: Text(
        prettyPrintDuration(Duration(
          hours: 1,
          minutes: 32,
          seconds: 13,
        )),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 60,
          color: Colors.black,
        ),
      ),
    );
  }
}
