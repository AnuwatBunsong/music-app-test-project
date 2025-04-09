import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/modules/home/bloc/home_bloc.dart';
import 'package:music/modules/music/models/music_model.dart';
import 'package:music/modules/music/views/cuurrent_music_screen.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
        title: const Text(
          'My Playlist',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) async {
          switch (state.fetchStatus) {
            case FormzSubmissionStatus.inProgress:
              playLists = List.generate(
                  4,
                  (index) => Music(
                        name: 'Loading...',
                        artist: 'Loading...',
                        imageUrl: 'assets/images/img_album_1.jpg',
                        url: 'https://example.com/loading.mp3',
                      ));
              break;
            case FormzSubmissionStatus.success:
              playLists = state.playlists;
              break;
            case FormzSubmissionStatus.failure:
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Failed to fetch music'),
                ),
              );
            default:
              break;
          }
        },
        builder: (context, state) {
          return Skeletonizer(
            enabled: state.fetchStatus == FormzSubmissionStatus.inProgress,
            child: ListView.builder(
              itemCount: playLists.length,
              itemBuilder: (context, index) {
                final Music music = playLists[index];
                bool isPlaying = state.currentMusic?.url == music.url &&
                    state.playStatus == FormzSubmissionStatus.success;

                return BlocBuilder<HomeBloc, HomeState>(
                  buildWhen: (previous, current) =>
                      previous.playStatus != current.playStatus,
                  builder: (context, state) {
                    return ListTile(
                      titleAlignment: ListTileTitleAlignment.center,
                      leading: Image.asset(
                        music.imageUrl,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        music.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        music.artist,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600],
                        ),
                      ),
                      onTap: () {
                        if (isPlaying) {
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
                      trailing: Skeleton.shade(
                          child: Icon(
                        isPlaying
                            ? Icons.pause_circle_outline
                            : Icons.play_circle_outline,
                        color: isPlaying ? Colors.black : Colors.grey[500],
                        size: 35,
                      )),
                    );
                  },
                );
              },
            ),
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
