import 'package:flutter/material.dart';
import 'package:notes/home.dart';

class Splas extends StatefulWidget {
  const Splas({super.key});

  @override
  State<Splas> createState() => _SplasState();
}

class _SplasState extends State<Splas> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    _animation = Tween<double>(begin: 1, end: 0).animate(
      // Changing begin and end values
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();

    navigateHome();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  navigateHome() async {
    await Future.delayed(Duration(seconds: 5), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow, // Set background color to yellow
      body: Center(
        child: FadeTransition(
          // Using FadeTransition instead of SlideTransition
          opacity: _animation,
          child: Image.asset("assets/images/logo.jpg"),
        ),
      ),
    );
  }
}
