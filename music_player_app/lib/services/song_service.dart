import 'package:on_audio_query/on_audio_query.dart';

class SongService {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  Future<List<SongModel>> getSongs() async {
    // Uso de SortBy enum o string para definir el orden de la consulta
    var canciones = await _audioQuery.querySongs(
      //sort: SortBy.ARTIST, // Suponiendo que existe SortBy enum
      orderType: OrderType.ASC_OR_SMALLER, // Ejemplo en orden ascendente
      uriType:
          UriType.EXTERNAL, // Ejemplo filtrando para almacenamiento externo
    );
    return canciones;
  }
}
