import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/modules/home/bloc/home_bloc.dart';
import 'package:music/modules/music/models/music_model.dart';
import 'package:music/modules/music/views/cuurrent_music_screen.dart';

class Homepeage extends StatefulWidget {
  const Homepeage({super.key});

  @override
  State<Homepeage> createState() => _HomepeageState();
}

class _HomepeageState extends State<Homepeage> {
  late final HomeBloc homeBloc;

  final player = AudioPlayer();
  List<Music> playLists = [];

  @override
  void initState() {
    super.initState();
    homeBloc = BlocProvider.of<HomeBloc>(context);
    homeBloc.add(const FetchMusic());
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music List'),
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        listenWhen: (previous, current) =>
            previous.fetchStatus != current.fetchStatus,
        listener: (context, state) async {
          if (state.fetchStatus == FormzSubmissionStatus.success) {
            playLists = state.playlists;
          } else if (state.fetchStatus == FormzSubmissionStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to fetch playlists')),
            );
          }
        },
        buildWhen: (previous, current) =>
            previous.fetchStatus != current.fetchStatus,
        builder: (context, state) {
          return ListView.builder(
            itemCount: playLists.length,
            itemBuilder: (context, index) {
              final Music music = playLists[index];
              return BlocBuilder<HomeBloc, HomeState>(
                buildWhen: (previous, current) =>
                    previous.playStatus != current.playStatus,
                builder: (context, state) {
                  return ListTile(
                    leading: Image.asset(
                      playLists[index].imageUrl,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                    title: Text(music.name),
                    subtitle: Text(music.artist),
                    onTap: () {
                      if (state.playStatus == FormzSubmissionStatus.success) {
                        homeBloc.add(
                          StopMusic(
                            player: player,
                          ),
                        );
                      } else {
                        homeBloc.add(
                          PlayMusic(
                            music: music,
                            player: player,
                          ),
                        );
                      }
                    },
                    trailing: Icon(
                      state.playStatus == FormzSubmissionStatus.success
                          ? Icons.pause_circle_outline
                          : Icons.play_circle_outline,
                      color: Colors.black,
                      size: 30,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      bottomSheet: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state.currentMusic == null) {
            return const SizedBox.shrink();
          }

          final music = state.currentMusic!;
          return GestureDetector(
            onTap: () {
              _showCurrentMusicPopup(context, music.url);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    music.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  Icon(
                    state.playStatus == FormzSubmissionStatus.success
                        ? Icons.pause_circle_outline
                        : Icons.play_circle_outline,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showCurrentMusicPopup(BuildContext context, String? songUrl) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const CurrentMusicPopup();
      },
    );
  }
}
