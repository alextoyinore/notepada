import 'package:notepada/features/intro/presentation/pages/intro.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    redirect();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Splash'),
      ),
    );
  }

  Future<void> redirect() async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const Intro()));
  }
}
