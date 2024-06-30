import 'package:flutter/material.dart';
import 'package:music_player_app/providers/audio_provider.dart';
import 'package:provider/provider.dart';

class PlayerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Reproductor de Música',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Center(
                    child: Icon(
                      Icons.music_note,
                      size: 100,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Song title
                Text(
                  audioProvider.canciones.isNotEmpty
                      ? audioProvider
                          .canciones[audioProvider.currentIndex].title
                      : 'No song selected',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                SizedBox(height: 8),
                Text(
                  audioProvider.canciones.isNotEmpty
                      ? audioProvider
                              .canciones[audioProvider.currentIndex].artist ??
                          'Unknown Artist'
                      : '',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.6), fontSize: 16),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Slider(
                        value: audioProvider.position.inSeconds.toDouble(),
                        min: 0,
                        max: audioProvider.duration.inSeconds.toDouble(),
                        onChanged: (value) {
                          audioProvider.seek(Duration(seconds: value.toInt()));
                        },
                        activeColor: Colors.white,
                        inactiveColor: Colors.white.withOpacity(0.3),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${audioProvider.position.inMinutes}:${(audioProvider.position.inSeconds % 60).toString().padLeft(2, '0')}',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            '${audioProvider.duration.inMinutes}:${(audioProvider.duration.inSeconds % 60).toString().padLeft(2, '0')}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Player controls: play/pause, skip next, skip previous
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.skip_previous, size: 48, color: Colors.white),
                onPressed: audioProvider.previousSong,
              ),
              SizedBox(width: 32),
              IconButton(
                icon: Icon(
                  audioProvider.isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  size: 64,
                  color: Colors.white,
                ),
                onPressed: audioProvider.playPause,
              ),
              SizedBox(width: 32),
              IconButton(
                icon: Icon(Icons.skip_next, size: 48, color: Colors.white),
                onPressed: audioProvider.nextSong,
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
