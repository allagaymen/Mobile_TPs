import 'package:flutter/material.dart';
import 'package:flutter_application_tp2/home.dart';

class Splas extends StatefulWidget {
  const Splas({Key? key}) : super(key: key);

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

    _animation = Tween<double>(begin: 0, end: 1).animate(
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
      backgroundColor: Color.fromARGB(255, 229, 255, 0),
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Image.asset("assets/images/logo.png"),
        ),
      ),
    );
  }
}
