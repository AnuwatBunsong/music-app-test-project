import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:just_audio/just_audio.dart';

import 'package:music/modules/home/bloc/home_bloc.dart';
import 'package:music/modules/home/views/home_screen.dart';
import 'package:music/modules/music/models/music_model.dart';
import 'package:music/modules/music/views/tab_lyrics_next_screen.dart';

class CurrentMusicPopup extends StatelessWidget {
  const CurrentMusicPopup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final homeBloc = BlocProvider.of<HomeBloc>(context);
    final List<Music> playLists = homeBloc.state.playlists;
    int previous = 0;
    int next = 0;

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final music = state.currentMusic!;

        const iconsSize = 50.0;

        if (state.currentMusic == null) {
          return const SizedBox.shrink();
        }

        playLists.where((e) => e.name == music.name).forEach((element) {
          previous = playLists.indexOf(element) - 1;
          playLists.indexOf(element) == playLists.length - 1
              ? next = 0
              : next = playLists.indexOf(element) + 1;
        });

        bool isNotPrevious = previous == -1;
        bool isNotNext = next == 0;

        return Container(
          color: const Color.fromRGBO(45, 83, 114, 1),
          height: double.infinity,
          margin: const EdgeInsets.only(top: 50),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: buildImage(
                  imageUrl: music.imageUrl,
                  width: double.infinity,
                  height: 300,
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      music.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      music.artist,
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 30),
                    _buildProgressBar(
                      state.player!,
                      playLists,
                      next,
                      isNotNext,
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.skip_previous,
                            size: iconsSize,
                            color: isNotPrevious ? Colors.grey : Colors.white,
                          ),
                          onPressed: isNotPrevious
                              ? null
                              : () {
                                  context.read<HomeBloc>().add(
                                        PlayMusic(
                                          music: playLists[previous],
                                          player: state.player!,
                                        ),
                                      );
                                },
                        ),
                        IconButton(
                          icon:
                              state.playStatus == FormzSubmissionStatus.success
                                  ? const Icon(
                                      Icons.pause,
                                      size: iconsSize,
                                      color: Colors.white,
                                    )
                                  : const Icon(
                                      Icons.play_arrow,
                                      size: iconsSize,
                                      color: Colors.white,
                                    ),
                          onPressed: () {
                            if (state.playStatus ==
                                FormzSubmissionStatus.success) {
                              context.read<HomeBloc>().add(
                                    StopMusic(
                                      player: state.player!,
                                      onStop: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  );
                            } else {
                              context.read<HomeBloc>().add(
                                    PlayMusic(
                                      music: state.currentMusic!,
                                      player: state.player!,
                                    ),
                                  );
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.skip_next,
                            size: iconsSize,
                            color: isNotNext ? Colors.grey : Colors.white,
                          ),
                          onPressed: isNotNext
                              ? null
                              : () {
                                  context.read<HomeBloc>().add(
                                        PlayMusic(
                                          music: playLists[next],
                                          player: state.player!,
                                        ),
                                      );
                                },
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (BuildContext context) =>
                            const TabsLyricsNextScreen(),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Up Next',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Lyrics',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressBar(
    AudioPlayer player,
    List<Music> playLists,
    int next,
    bool isNotNext,
  ) {
    return StreamBuilder<Duration>(
      stream: player.positionStream,
      builder: (context, snapshot) {
        Duration position = snapshot.data ?? Duration.zero;
        Duration duration = player.duration ?? Duration.zero;
        double progress = position.inMilliseconds.toDouble();
        double total = duration.inMilliseconds.toDouble();

        if (progress > total) {
          position = Duration.zero;
          progress = position.inMilliseconds.toDouble();
        }

        return SizedBox(
          height: 2.0,
          child: Slider(
            value: progress,
            min: 0,
            max: total,
            activeColor: Colors.white,
            inactiveColor: Colors.grey,
            onChanged: (value) => {
              if (value >= total)
                {
                  player.seek(duration),
                }
              else
                {
                  player.seek(Duration(milliseconds: value.toInt())),
                }
            },
          ),
        );
      },
    );
  }
}
