import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class PrayerDetailsPage extends StatefulWidget {
  final String title;
  final String description;
  final String imagePath;

  const PrayerDetailsPage({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  State<PrayerDetailsPage> createState() => _PrayerDetailsPageState();
}

class _PrayerDetailsPageState extends State<PrayerDetailsPage> {
  
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _playMusic();
  }

  Future<void> _playMusic() async {
    await _audioPlayer.play(AssetSource('audios/1.mp3'));
  }

  Future<void> _stopMusic() async {
    await _audioPlayer.stop();
  }

  @override
  void dispose() {
    _stopMusic();
    _audioPlayer.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.description,
              style: TextStyle(fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                widget.imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
