part of 'home_bloc.dart';

class HomeState extends Equatable {
  final AudioPlayer? player;
  final Music? currentMusic;
  final List<Music> playlists;

  final FormzSubmissionStatus playStatus;
  final FormzSubmissionStatus fetchStatus;

  const HomeState({
    this.player,
    this.currentMusic,
    this.playlists = const [],
    this.playStatus = FormzSubmissionStatus.initial,
    this.fetchStatus = FormzSubmissionStatus.initial,
  });

  HomeState copyWith({
    AudioPlayer? player,
    Music? currentMusic,
    List<Music>? playlists,
    FormzSubmissionStatus? playStatus,
    FormzSubmissionStatus? fetchStatus,
  }) {
    return HomeState(
      player: player ?? this.player,
      currentMusic: currentMusic ?? this.currentMusic,
      playlists: playlists ?? this.playlists,
      playStatus: playStatus ?? this.playStatus,
      fetchStatus: fetchStatus ?? this.fetchStatus,
    );
  }

  @override
  List<Object?> get props => [
        playStatus,
        fetchStatus,
        player,
        currentMusic,
        playlists,
      ];
}
