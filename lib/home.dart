import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'app_list.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _message = startMsg;

  static const String startMsg = "Schönen guten Tag!";
  static const String acceptMsg = "Zugriff gewährt!!";
  static const String rejectMsg = "Zugriff verweigert!!";

  static const String emotiguyAngry = "assets/emotiguy_angry.png";

  void _requestAccess() {
    final result = Random().nextInt(2);

    if (result == 0) {
      setState(() {
        _message = acceptMsg;
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const AppList()));
      });
    } else {
      setState(() {
        _message = rejectMsg;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              AnimatedTextKit(
                key: ValueKey(_message),
                animatedTexts: [
                  TypewriterAnimatedText(
                    _message,
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                ],
                isRepeatingAnimation: false,
              ),

              const Spacer(),

              Image.asset(emotiguyAngry),

              const Spacer(),

              ElevatedButton(
                onPressed: _requestAccess,
                child: Text("Zugriff beantragen"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
