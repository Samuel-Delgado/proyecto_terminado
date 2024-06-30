import 'package:on_audio_query/on_audio_query.dart';

class SongService {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  Future<List<SongModel>> getSongs() async {
    var canciones = await _audioQuery.querySongs(
      orderType: OrderType.ASC_OR_SMALLER,
      uriType:
          UriType.EXTERNAL,
    );
    return canciones;
  }
}
