
import 'package:flutter/material.dart';
import 'package:game_clock/core/strings/widgets_keys.dart';

class Clock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key(CLOCK),
      child: Text('This is a clock'),
    );
  }
}
