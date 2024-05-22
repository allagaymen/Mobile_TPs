import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:flutter_tts/flutter_tts.dart';

class NoteDetails extends StatefulWidget {
  final String content;
  final DateTime date;

  NoteDetails({required this.content, required this.date});

  @override
  _NoteDetailsState createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> with WidgetsBindingObserver {
  final DateFormat formatter = DateFormat('MMM dd, yyyy HH:mm'); // Define date format
  late FlutterTts flutterTts;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    flutterTts = FlutterTts();
  }

  void speak(String text) async {
    await flutterTts.setLanguage('fr-FR');
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }

  void stop() async {
    await flutterTts.stop();
  }



  @override
  void dispose() {
    stop();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      print('**********************************************************stopped');
      stop();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note Details'),
        backgroundColor: Color.fromARGB(255, 243, 255, 24),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 50, // Adjust as needed
              height: 50, // Adjust as needed
            ),

            SizedBox(height: 16.0),
            Text(
              widget.content,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            Text(
              'Created: ${formatter.format(widget.date)}',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[600],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                speak(widget.content);
              },
              child: Text('Read Aloud'),
            ),
            ElevatedButton(
              onPressed: () {
                stop();
              },
              child: Text('stop'),
            ),
          ],
        ),
      ),
    );
  }
}