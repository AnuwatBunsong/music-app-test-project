import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/modules/music/repository/music_repository.dart';
import 'package:music/modules/music/models/music_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<PlayMusic>(_onPlayMusic);
    on<StopMusic>(_onStopMusic);
    on<FetchMusic>(_onFetchMusic);
  }

  MusicRepository get repository => MusicRepository();

  Future<void> _onPlayMusic(
    PlayMusic event,
    Emitter<HomeState> emit,
  ) async {
    try {
      await event.player.setAudioSource(
        AudioSource.uri(
          Uri.parse(event.music.url),
        ),
      );
      unawaited(
        event.player.play(),
      );
      emit(
        state.copyWith(
          player: event.player,
          currentMusic: event.music,
          playStatus: FormzSubmissionStatus.success,
        ),
      );
    } catch (e) {
      emit(state.copyWith(playStatus: FormzSubmissionStatus.failure));
    }
  }

  Future<void> _onStopMusic(
    StopMusic event,
    Emitter<HomeState> emit,
  ) async {
    try {
      await event.player.stop();
      emit(
        state.copyWith(
          player: event.player,
          currentMusic: null,
          playStatus: FormzSubmissionStatus.canceled,
        ),
      );
    } catch (e) {
      emit(state.copyWith(playStatus: FormzSubmissionStatus.failure));
    }
  }

  FutureOr<void> _onFetchMusic(
    FetchMusic event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(fetchStatus: FormzSubmissionStatus.inProgress));

    await Future.delayed(const Duration(seconds: 2));

    try {
      emit(
        state.copyWith(
          fetchStatus: FormzSubmissionStatus.success,
          playlists: repository.getPlaylistTracks(),
        ),
      );
    } catch (e) {
      emit(state.copyWith(fetchStatus: FormzSubmissionStatus.failure));
    }
  }
}
