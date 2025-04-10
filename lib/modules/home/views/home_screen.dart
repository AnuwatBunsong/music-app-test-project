import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:just_audio/just_audio.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
                ),
              );
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
                    return _buildPlaylist(
                      music,
                      isPlaying,
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      bottomSheet: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
        if (state.currentMusic == null ||
            state.playStatus == FormzSubmissionStatus.inProgress) {
          return const SizedBox.shrink();
        }
        final music = state.currentMusic!;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildProgressBar(player),
            _buildCurrentMusic(
              music: music,
              isPlaying: state.playStatus == FormzSubmissionStatus.success,
            ),
          ],
        );
      }),
    );
  }

  Widget _buildPlaylist(
    Music music,
    bool isPlaying,
  ) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        titleAlignment: ListTileTitleAlignment.center,
        leading: buildImage(
          imageUrl: music.imageUrl,
          width: 70,
          height: 70,
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
          isPlaying
              ? homeBloc.add(StopMusic(player: player))
              : homeBloc.add(PlayMusic(music: music, player: player));
        },
        trailing: Skeleton.shade(
          child: Icon(
            isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline,
            color: isPlaying ? Colors.black : Colors.grey[500],
            size: 35,
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(
    AudioPlayer player,
  ) {
    return StreamBuilder<Duration>(
      stream: player.positionStream,
      builder: (context, snapshot) {
        final position = snapshot.data ?? Duration.zero;
        final duration = player.duration ?? Duration.zero;
        final progress = position.inMilliseconds.toDouble();
        final total = duration.inMilliseconds.toDouble();

        if (progress > total) {
          homeBloc.add(StopMusic(player: player));
          return const SizedBox.shrink();
        }

        return SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4.0,
            trackShape: const RoundedRectSliderTrackShape(),
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 0.0,
            ),
            thumbColor: Colors.transparent,
            activeTrackColor: Colors.yellow[700],
            inactiveTrackColor: Colors.grey[300],
          ),
          child: SizedBox(
            height: 4.0,
            child: Slider(
              value: progress,
              min: 0,
              max: total,
              activeColor: Colors.yellow[700],
              onChanged: (value) {
                player.seek(Duration(milliseconds: value.toInt()));
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildCurrentMusic({
    required Music music,
    required bool isPlaying,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: const Color.fromRGBO(45, 83, 114, 1),
              builder: (BuildContext context) => const CurrentMusicPopup(),
            ),
            child: Row(
              children: [
                buildImage(
                  imageUrl: music.imageUrl,
                  width: 70,
                  height: 70,
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      music.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      music.artist,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              isPlaying
                  ? homeBloc.add(StopMusic(player: player))
                  : homeBloc.add(PlayMusic(music: music, player: player));
            },
            child: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.black,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildImage({
  required String imageUrl,
  double width = 70,
  double height = 70,
}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      image: DecorationImage(
        image: AssetImage(imageUrl),
        fit: BoxFit.cover,
      ),
    ),
  );
}
