import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_player_app/providers/audio_provider.dart';
import 'package:music_player_app/screens/player_screen.dart';
import 'package:music_player_app/services/song_service.dart';
import 'package:music_player_app/utils/permissions.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class SongListScreen extends StatefulWidget {
  @override
  _SongListScreenState createState() => _SongListScreenState();
}

class _SongListScreenState extends State<SongListScreen> {
  late List<SongModel> canciones;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchSongs();
  }

  Future<void> _fetchSongs() async {
    bool hasPermission = await Permissions.requestStoragePermission();
    if (hasPermission) {
      try {
        var songService = SongService();
        var fetchedSongs = await songService.getSongs();
        setState(() {
          canciones = fetchedSongs;
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          errorMessage = 'Error al cargar las canciones. Inténtalo de nuevo.';
          isLoading = false;
        });
      }
    } else {
      setState(() {
        errorMessage =
            'Permiso de almacenamiento denegado. Por favor, habilita el permiso en la configuración.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reproductor de Música'),
        backgroundColor: Colors.black,
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomBar(),
      backgroundColor: Colors.black,
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (errorMessage.isNotEmpty) {
      return Center(
          child: Text(errorMessage, style: TextStyle(color: Colors.white)));
    } else {
      return ListView.builder(
        itemCount: canciones.length,
        itemBuilder: (context, index) {
          var song = canciones[index];
          return ListTile(
            leading: _buildLeadingImage(song),
            title: Text(
              song.title,
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              song.artist ?? "Artista desconocido",
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              Provider.of<AudioProvider>(context, listen: false)
                  .setSongs(canciones, index);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlayerScreen(),
                ),
              );
            },
          );
        },
      );
    }
  }

  Widget _buildLeadingImage(SongModel song) {
    final String? albumArtwork = _getAlbumArtwork(song);
    if (albumArtwork != null && albumArtwork.isNotEmpty) {
      return CircleAvatar(
        backgroundImage: FileImage(File(albumArtwork)),
      );
    } else {
      return CircleAvatar(
        child: Icon(Icons.music_note, color: Colors.white),
      );
    }
  }

  String? _getAlbumArtwork(SongModel song) {
    return null;

  Widget _buildBottomBar() {
    final audioProvider = Provider.of<AudioProvider>(context);
    final currentSong = audioProvider.canciones.isNotEmpty
        ? audioProvider.canciones[audioProvider.currentIndex]
        : null;

    if (currentSong != null) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlayerScreen(),
            ),
          );
        },
        child: Container(
          color: Colors.grey[900],
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                    audioProvider.isPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: () {
                  audioProvider.playPause();
                },
                color: Colors.white,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  currentSong.title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
