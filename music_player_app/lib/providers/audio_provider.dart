import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioProvider with ChangeNotifier {
  AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  List<SongModel> _canciones = [];
  int _currentIndex = -1;

  AudioPlayer get audioPlayer => _audioPlayer;
  bool get isPlaying => _isPlaying;
  Duration get duration => _duration;
  Duration get position => _position;
  List<SongModel> get canciones => _canciones;
  int get currentIndex => _currentIndex;

  AudioProvider() {
    _audioPlayer.onDurationChanged.listen((d) {
      _duration = d;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((p) {
      _position = p;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      nextSong();
    });
  }

  void setSongs(List<SongModel> canciones, int initialIndex) {
    _canciones = canciones;
    _currentIndex = initialIndex;
    _play();
  }

  Future<void> _play() async {
    await _audioPlayer.play(DeviceFileSource(_canciones[_currentIndex].data));
    _isPlaying = true;
    notifyListeners();
  }

  void playPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
      _isPlaying = false;
    } else {
      _audioPlayer.resume();
      _isPlaying = true;
    }
    notifyListeners();
  }

  void stop() {
    _audioPlayer.stop();
    _isPlaying = false;
    _position = Duration.zero;
    notifyListeners();
  }

  void nextSong() {
    if (_currentIndex < _canciones.length - 1) {
      _currentIndex++;
      _play();
    }
  }

  void previousSong() {
    if (_currentIndex > 0) {
      _currentIndex--;
      _play();
    }
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
