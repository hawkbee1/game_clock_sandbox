import 'dart:async';

import 'package:game_clock/features/clock/data/datasources/stopwatch_provider.dart';
import 'package:game_clock/features/clock/domain/repositories/active_player_repository.dart';
import 'package:game_clock/features/clock/domain/repositories/player_list.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
sl.registerLazySingleton<StopwatchProvider>(() => StopwatchProvider());
sl.registerLazySingleton<PlayerList>(() => PlayerList());
sl.registerLazySingleton<ActivePlayer>(() =>ActivePlayer(playerList: sl()));
/*
  // Bloc ?????
  // Use cases
  sl.registerLazySingleton<>(() => LoginWithGoogle(sl()));

  // repository
  sl.registerLazySingleton<AuthenticationRepository>(() => AuthenticationRepositoryImpl(
    sl(),
    sl(),
  ));

  // Data Sources
  sl.registerLazySingleton<AuthenticationRemoteDataSource>(() => AuthenticationRemoteDataSourceImpl(sl()));

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External
  final firebaseAuth = FirebaseAuth.instance;
  sl.registerLazySingleton<FirebaseAuth>(() => firebaseAuth);
  sl.registerLazySingleton(() => DataConnectionChecker());
*/
}
