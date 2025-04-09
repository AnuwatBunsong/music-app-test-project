part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class PlayMusic extends HomeEvent {
  final Music music;
  final AudioPlayer player;

  const PlayMusic({
    required this.music,
    required this.player,
  });

  @override
  List<Object?> get props => [
        music,
        player,
      ];
}

class StopMusic extends HomeEvent {
  final AudioPlayer player;
  final Function? onStop;
  const StopMusic({this.onStop, required this.player});

  @override
  List<Object?> get props => [
        player,
        onStop,
      ];
}

class FetchMusic extends HomeEvent {
  const FetchMusic();

  @override
  List<Object?> get props => [];
}
