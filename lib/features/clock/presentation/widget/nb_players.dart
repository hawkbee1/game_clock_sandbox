import 'package:flutter/material.dart';
import 'package:flutter_game_clock/features/clock/domain/repositories/player_list.dart';
import 'package:flutter_game_clock/injection_container.dart';
import 'package:google_fonts/google_fonts.dart';

class NbPlayers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PlayerList _playerList = sl();
    return StreamBuilder(
      stream: _playerList.nbPlayer,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(!snapshot.hasData) return Padding(
          padding: const EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        );
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Number of players: ${snapshot.data}',
            style: GoogleFonts.lato(fontWeight: FontWeight.bold,
            fontSize: 14.0),
          ),
        );
      },

    );
  }
}
