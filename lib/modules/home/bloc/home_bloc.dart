import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/modules/home/repository/home.dart';
import 'package:music/modules/music/models/music_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<PlayMusic>(_onPlayMusic);
    on<StopMusic>(_onStopMusic);
    on<FetchMusic>(_onFetchMusic);
  }

  HomeRepository get repository => HomeRepository();

  Future<void> _onPlayMusic(
    PlayMusic event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(playStatus: FormzSubmissionStatus.inProgress));

    try {
      await event.player.setAudioSource(
        AudioSource.uri(
          Uri.parse(event.music.url),
        ),
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
      emit(
        state.copyWith(
          player: event.player,
          currentMusic: null,
          playStatus: FormzSubmissionStatus.canceled,
        ),
      );
      event.onStop?.call();
    } catch (e) {
      emit(state.copyWith(playStatus: FormzSubmissionStatus.failure));
    }
  }

  FutureOr<void> _onFetchMusic(
    FetchMusic event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(fetchStatus: FormzSubmissionStatus.inProgress));
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
