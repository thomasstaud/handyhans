import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'app_list.dart';
import 'dart:math';

enum LauncherState { normal, accepted, rejected }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  LauncherState _state = LauncherState.normal;
  String _message = startMsg;
  String _emotiguy = emotiguyNormal;

  static const String startMsg = "Schönen guten Tag!";
  static const String acceptMsg = "Zugriff gewährt!!";
  static const String rejectMsg = "Zugriff verweigert!!";

  static const String emotiguyNormal = "assets/emotiguy_normal.png";
  static const String emotiguyAngry = "assets/emotiguy_angry.png";

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  void _requestAccess() {
    final result = Random().nextInt(2);

    _controller.forward(from: 0);

    if (result == 0) {
      setState(() {
        _state = LauncherState.accepted;
        _message = acceptMsg;
        _emotiguy = emotiguyNormal;
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;

        setState(() {
          _state = LauncherState.normal;
          _message = startMsg;
        });

        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const AppList()));
      });
    } else {
      setState(() {
        _state = LauncherState.rejected;
        _message = rejectMsg;
        _emotiguy = emotiguyAngry;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
                    textStyle: const TextStyle(
                      fontSize: 38,
                      fontFamily: "Jersey25",
                      color: Colors.white,
                      backgroundColor: Colors.black,
                    ),
                  ),
                ],
                isRepeatingAnimation: false,
              ),

              const Spacer(),

              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  Offset offset = Offset.zero;
                  double scaleX = 1.0;
                  double scaleY = 1.0;

                  final t = _controller.value;
                  if (_state == LauncherState.rejected) {
                    offset = Offset(
                      sin(t * pi * 10) * 10,
                      sin(t * pi * 15) * 12,
                    );
                  } else if (_state == LauncherState.accepted) {
                    offset = Offset(0, sin(t * pi * 2) * 16);
                    scaleX = (1 + sin(t * pi * 3)) * 5;
                  }

                  return Transform.scale(
                    scaleX: scaleX,
                    scaleY: scaleY,
                    child: Transform.translate(offset: offset, child: child),
                  );
                },
                child: Image.asset(_emotiguy),
              ),

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
