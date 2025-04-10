import 'package:music/modules/music/models/music_model.dart';

class MusicRepository {
  List<Music> getPlaylistTracks() {
    final List<Music> tracks = [
      Music(
        name: 'SoundHelix Song 1',
        artist: 'SoundHelix',
        imageUrl: 'assets/images/img_album_1.jpg',
        url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      ),
      Music(
        name: 'SoundHelix Song 2',
        artist: 'SoundHelix',
        imageUrl: 'assets/images/img_album_2.jpg',
        url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
      ),
      Music(
        name: 'SoundHelix Song 3',
        artist: 'SoundHelix',
        imageUrl: 'assets/images/img_album_3.jpg',
        url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
      ),
      Music(
        name: 'SoundHelix Song 4',
        artist: 'SoundHelix',
        imageUrl: 'assets/images/img_album_4.jpg', // Example image URL
        url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
      ),
    ];

    return tracks;
  }
}
