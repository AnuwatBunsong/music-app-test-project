import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:music/modules/home/bloc/home_bloc.dart';

class CurrentMusicPopup extends StatelessWidget {
  const CurrentMusicPopup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.currentMusic == null) {
          return const Center(child: Text('No song playing.'));
        }

        final songTitle = state.currentMusic?.name ?? 'Song Title';
        const artistName = 'Artist Name';
        if (state.currentMusic == null) {
          return const Center(child: Text('No song playing.'));
        }

        return Container(
          height: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Text(
                songTitle,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                artistName,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              // Playback controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: state.playStatus == FormzSubmissionStatus.success
                        ? const Icon(Icons.pause)
                        : const Icon(Icons.play_arrow),
                    onPressed: () {
                      if (state.playStatus == FormzSubmissionStatus.success) {
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
                    icon: const Icon(Icons.skip_next),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text('Lyrics'),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Up Next'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
