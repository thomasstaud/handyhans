import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_android_launcher/flutter_android_launcher.dart';


class AppList extends StatefulWidget {
  const AppList({super.key});

  @override
  State<StatefulWidget> createState() => _AppListState();
}

class _AppListState extends State<AppList> {
  List<Map<String, String>> _apps = [];
  final _flutterAndroidLauncherPlugin = FlutterAndroidLauncher();

  @override
  void initState() {
    super.initState();
    _getInstalledApps();
  }

  Future<void> _getInstalledApps() async {
    try {
      final installedApps = await _flutterAndroidLauncherPlugin.getInstalledApps();
      setState(() {
        _apps = installedApps;
      });
    } on PlatformException catch (e) {
      print("Failed to get installed apps: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _apps.length,
      itemBuilder: (context, index) {
        return Text(_apps[index]['appName']!);
      },
    );
  }
}
