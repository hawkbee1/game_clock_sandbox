import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:game_clock/features/clock/domain/repositories/player_list.dart';
import 'package:game_clock/features/clock/domain/usecases/add_player.dart';
import 'package:game_clock/features/clock/presentation/widget/global_clock.dart';
import 'package:game_clock/features/clock/presentation/widget/player_clock.dart';
import 'package:game_clock/injection_container.dart';

class ClockPage extends StatelessWidget {
  final String title;
  ClockPage({this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(title)),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Transform.scale(
              scale: 0.7,
                child: GlobalClock()),
            Spacer(),
            PlayerClock(),
            Spacer(),
            Container(
              child: NbPlayers(),
            ),
            Spacer(),
          ],
        ),
      ),
      floatingActionButton:
          AddPlayerButton(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class DisplayNbPlayers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PlayerList _playerList = sl();
    return null;
  }

}

class NbPlayers extends StatefulWidget {
  const NbPlayers({
    Key key,
  }) : super(key: key);

  @override
  _NbPlayersState createState() => _NbPlayersState();
}

class _NbPlayersState extends State<NbPlayers> {
  PlayerList _playerList = sl();
  int _nbPlayers;
  @override
  void initState() {
    super.initState();
    _nbPlayers = _playerList.players.length;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Text('$_nbPlayers players'),
    );
  }
}
