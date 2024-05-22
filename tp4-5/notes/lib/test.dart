import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
    FlutterTts flutterTts = FlutterTts();
 void speak(String text) async {
    await flutterTts.setLanguage('fr-FR');
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(child: Text("ded") , onPressed: (){
          speak("NADIA elouali");
        },),
      ),
    );
  }
}