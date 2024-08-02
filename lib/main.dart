import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

//Coded by Mohit Tiwari

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Coded by Mohit Tiwari
      title: 'Sangeet Sarovar',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner:
          false, // remove debug badge con i dont want it Coded by Mohit Tiwari
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isPlaying = false;
  double _progress = 0.0;

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _previousSong() {
    // previuos song logic will go here
    print("Previous song");
  }

  void _nextSong() {
    // next soong loginc will go here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sangeet Sarovar'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // album image
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Icon(Icons.music_note, size: 100, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),
            // song name
            const Text(
              'Song name',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Artist name
            const Text(
              'Artist Name',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            // Progress Bar
            Slider(
              value: _progress,
              onChanged: (value) {
                setState(() {
                  _progress = value;
                });
              },
              min: 0.0,
              max: 1.0,
              activeColor: Colors.deepPurple,
              inactiveColor: Colors.grey[300],
            ),
            const SizedBox(height: 20),
            // Control Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.skip_previous,
                      size: 50, color: Colors.deepPurple),
                  onPressed: _previousSong,
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
                  onPressed: _nextSong,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
