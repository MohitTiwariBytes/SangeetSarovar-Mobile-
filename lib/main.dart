import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // ......
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sangeet Sarovar - By Mohit Tiwari',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sangeet Sarovar'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          MusicGenreCard(
              genre: 'Pop', icon: Icons.music_note, color: Colors.blue),
          MusicGenreCard(
              genre: 'Rock', icon: Icons.music_video, color: Colors.red),
          MusicGenreCard(
              genre: 'Jazz', icon: Icons.library_music, color: Colors.yellow),
          MusicGenreCard(
              genre: 'Classical',
              icon: Icons.library_books,
              color: Colors.green),
        ],
      ),
    );
  }
}

class MusicGenreCard extends StatelessWidget {
  final String genre;
  final IconData icon;
  final Color color;

  const MusicGenreCard(
      {required this.genre,
      required this.icon,
      required this.color,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: color,
      margin: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MusicPage(genre: genre),
            ),
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: 80, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                genre,
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MusicPage extends StatefulWidget {
  final String genre;

  const MusicPage({required this.genre, super.key});

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  late AudioPlayer _player;
  List<Map<String, String>> _tracks = [];
  int _currentTrackIndex = 0;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _fetchTracks();
  }

  // the hardest code i ever wrote in my life ----->>

  Future<void> _fetchTracks() async {
    final response = await http.get(Uri.parse(
        'https://api.jamendo.com/v3.0/tracks?client_id=8428cdd9&format=json&genre={widget.genre}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final List<dynamic>? tracks = data['results'] as List<dynamic>?;

      setState(() {
        _tracks = tracks?.map((dynamic track) {
              final Map<String, dynamic> trackMap =
                  track as Map<String, dynamic>;
              return {
                'title': trackMap['name'] as String? ??
                    'Unknown Title', // setting the title to unknown title if the music is'nt available
                'url': trackMap['preview'] as String? ?? '', // same here
              };
            }).toList() ??
            [];

        if (_tracks.isNotEmpty) {
          _playTrack(_currentTrackIndex);
        }
      });
    } else {
      throw Exception('Failed to load tracks'); // throw the error
    }
  }

  void _playTrack(int index) {
    if (index < 0 || index >= _tracks.length) return;

    setState(() {
      _currentTrackIndex = index;
      _player.setUrl(_tracks[_currentTrackIndex]['audio']!);
      _player.play();
      _isPlaying = true;
    });
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _player.pause();
      } else {
        _player.play();
      }
      _isPlaying = !_isPlaying;
    });
  }

  void _previousTrack() {
    if (_tracks.isNotEmpty) {
      final newIndex =
          (_currentTrackIndex - 1 + _tracks.length) % _tracks.length;
      _playTrack(newIndex);
    }
  }

  void _nextTrack() {
    if (_tracks.isNotEmpty) {
      final newIndex = (_currentTrackIndex + 1) % _tracks.length;
      _playTrack(newIndex);
    }
  }

  @override
  void dispose() {
    _player.dispose();
    //Coded by Mohit Tiwari
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sangeet Sarovar - ${widget.genre}'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: _tracks.isEmpty
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    _tracks[_currentTrackIndex]['title'] ?? 'No Title',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  // Control Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.skip_previous,
                            size: 50, color: Colors.deepPurple),
                        onPressed: _previousTrack,
                      ),
                      IconButton(
                        icon: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 50,
                          color: Colors.deepPurple,
                        ),
                        onPressed: _togglePlayPause,
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next,
                            size: 50, color: Colors.deepPurple),
                        onPressed: _nextTrack,
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
