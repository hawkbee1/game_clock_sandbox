import 'package:flutter/widgets.dart';
import 'package:game_clock/features/clock/domain/repositories/player_list.dart';

class PlayersProvider extends InheritedWidget {
  PlayersProvider({
    Key key,
    @required Widget child,
  })  : assert(child != null),
  _playerList = PlayerList();
  final PlayerList _playerList;

  static PlayersProvider of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(PlayersProvider);

  @override
  bool updateShouldNotify(InheritedWidget _) => false;

  /// Reset the countdown
  void addPlayer() => _playerList.addPlayer();
}
