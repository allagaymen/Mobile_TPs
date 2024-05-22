import 'package:flutter/material.dart';
import 'package:flutter_application_tp2/prayer_page.dart'; // Import the PrayerDetailsPage widget

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  
  

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset(0, -1.5),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SALATEK',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: SlideTransition(
          position: _offsetAnimation,
          child: PrayerImages(),
        ),
      ),
    );
  }
}

class PrayerImages extends StatefulWidget {
  @override
  _PrayerImagesState createState() => _PrayerImagesState();
}

class _PrayerImagesState extends State<PrayerImages> {
  String? tappedImage;

  final String image_fajr = 'assets/images/esobh.jpg';
  final String image_dhohr = 'assets/images/dhohr.jpg';
  final String image_elasr = 'assets/images/elasr.jpg';

  final Map<String, String> prayernames = {
    'assets/images/esobh.jpg': '2 rakaat',
    'assets/images/dhohr.jpg': '4 rakaat',
    'assets/images/elasr.jpg': '4 rakaat',
    // Add more prayer images as needed
  };

  final Map<String, List<String>> stepss = {
    "assets/images/esobh.jpg": [
      'assets/images/w1.png',
      'assets/images/w2.png',
      'assets/images/w3.png',
      'assets/images/w4.png'
    ],
    'assets/images/dhohr.jpg': [
      'assets/images/w3.png',
      'assets/images/w4.png',
      'assets/images/w5.png',
      'assets/images/w6.png'
    ],
    'assets/images/elasr.jpg': [
      'assets/images/w2.png',
      'assets/images/w3.png',
      'assets/images/w4.png',
      'assets/images/w5.png',
      'assets/images/w6.png'
    ]
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          GestureDetector(
            onLongPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrayerDetailsPage(
                    title: prayernames[image_fajr] ?? '',
                    description: 'The Fajr prayer, also known as the Sobh prayer, is the dawn prayer performed by Muslims before the sun rises. It is the first of the five daily prayers (Salat) prescribed by Islam. The Fajr prayer consists of two units (raka"at), making it a relatively short prayer. It holds significant spiritual importance as it marks the beginning of the Muslim day and is seen as a time for seeking guidance and blessings from Allah. The Fajr prayer is emphasized in Islam, and its performance is considered a sign of commitment and devotion to the faith.',
                    imagePath: image_fajr,
                  ),
                ),
              );
            },
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 250,
                    child: Image.asset(
                      image_fajr,
                    ),
                  ),
                  Container(
                    color: Colors.blue,
                    height: 2,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onLongPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrayerDetailsPage(
                    title: prayernames[image_dhohr] ?? '',
                    description: 'The Dhuhr prayer, also known as the Noon prayer, is the second of the five daily prayers (Salat) observed by Muslims. It is performed after the sun reaches its zenith, marking the midday period. The Dhuhr prayer consists of four units (raka"at), making it one of the longer prayers during the day. It serves as a pause in the daily activities, allowing Muslims to take a break from their work or studies to reconnect with their faith and seek spiritual nourishment. The Dhuhr prayer holds significance as it symbolizes gratitude for the blessings received throughout the day and serves as a reminder of the importance of regular prayer in the life of a Muslim.',
                    imagePath: image_dhohr,
                  ),
                ),
              );
            },
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 250,
                    child: Image.asset(
                      image_dhohr,
                      
                    ),
                  ),
                  Container(
                    color: Colors.blue,
                    height: 2,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onLongPress: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrayerDetailsPage(
                    title: prayernames[image_elasr] ?? '',
                    description: 'The Asr prayer, also known as the Afternoon prayer, is one of the five daily prayers (Salat) performed by Muslims. It is offered in the late afternoon after the Dhuhr prayer and before sunset. The Asr prayer consists of four units (raka"at), making it similar in length to the Dhuhr prayer. As the day progresses towards evening, the Asr prayer serves as a moment of reflection and spiritual rejuvenation, allowing Muslims to pause and seek closeness to Allah amidst their daily activities. It holds significance as a reminder of the fleeting nature of time and the importance of utilizing every moment to worship and seek the pleasure of Allah.',
                    imagePath: image_elasr,
                  ),
                ),
              );
            },
            onTap: () {
              
            },
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 250,
                    child: Image.asset(
                      image_elasr,
                      
                    ),
                  ),
                  Container(
                    color: Colors.blue,
                    height: 2,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
