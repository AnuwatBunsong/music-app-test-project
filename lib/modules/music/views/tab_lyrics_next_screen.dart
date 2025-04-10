import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:just_audio/just_audio.dart';

import 'package:music/modules/home/bloc/home_bloc.dart';
import 'package:music/modules/home/views/home_screen.dart';
import 'package:music/modules/music/models/music_model.dart';

class TabsLyricsNextScreen extends StatefulWidget {
  const TabsLyricsNextScreen({super.key});

  @override
  State<TabsLyricsNextScreen> createState() => _TabsLyricsNextScreenState();
}

class _TabsLyricsNextScreenState extends State<TabsLyricsNextScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeBloc = BlocProvider.of<HomeBloc>(context);
    final List<Music> playLists = homeBloc.state.playlists;

    int next = 0;

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final music = state.currentMusic!;
        final player = state.player!;

        if (state.currentMusic == null) {
          return const SizedBox.shrink();
        }

        playLists.where((e) => e.name == music.name).forEach((element) {
          playLists.indexOf(element) == playLists.length - 1
              ? next = 0
              : next = playLists.indexOf(element) + 1;
        });

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
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: _buildCurrentMusic(
                  homeBloc: homeBloc,
                  music: music,
                  isPlaying: state.playStatus == FormzSubmissionStatus.success,
                  player: state.player!,
                  playLists: playLists,
                  isNotNext: isNotNext,
                  next: next,
                ),
              ),
              TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                dividerHeight: 0,
                isScrollable: false,
                padding: EdgeInsets.zero,
                labelPadding: EdgeInsets.zero,
                tabs: [
                  Tab(
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Up Next'.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Lyrics'.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    ListView.builder(
                      padding: const EdgeInsets.only(top: 10),
                      controller: scrollController,
                      itemCount: playLists.length,
                      itemBuilder: (context, index) {
                        final Music music = playLists[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            music.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            "${music.artist} - ${player.duration?.inMinutes}:${player.duration?.inSeconds.remainder(60).toString().padLeft(2, '0')}",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[300],
                            ),
                          ),
                          onTap: () {
                            homeBloc.add(
                              PlayMusic(
                                music: music,
                                player: homeBloc.state.player!,
                              ),
                            );
                          },
                          leading: buildImage(
                            imageUrl: music.imageUrl,
                            width: 70,
                            height: 70,
                          ),
                          trailing: const Icon(
                            Icons.menu,
                            size: 20,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Lyrics will be here of ${music.name} by ${music.artist} \n\n' *
                            10,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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

  Widget _buildCurrentMusic({
    required HomeBloc homeBloc,
    required AudioPlayer player,
    required List<Music> playLists,
    required Music music,
    required bool isPlaying,
    bool isNotNext = false,
    int next = 0,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          child: Row(
            children: [
              buildImage(
                imageUrl: music.imageUrl,
                width: 50,
                height: 50,
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
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    music.artist,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            isPlaying
                ? homeBloc.add(StopMusic(player: homeBloc.state.player!))
                : homeBloc.add(
                    PlayMusic(music: music, player: homeBloc.state.player!));
          },
          icon: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
            size: 30,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.skip_next,
            size: 30,
            color: isNotNext ? Colors.grey : Colors.white,
          ),
          onPressed: isNotNext
              ? null
              : () {
                  homeBloc.add(
                    PlayMusic(
                      music: playLists[next],
                      player: player,
                    ),
                  );
                },
        ),
      ],
    );
  }
}
