import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter_android_launcher/flutter_android_launcher.dart';

class AppList extends StatefulWidget {
  const AppList({super.key});

  @override
  State<StatefulWidget> createState() => _AppListState();
}

class _AppListState extends State<AppList> {
  List<Map<String, String>> _apps = [];
  final Map<String, Uint8List> _iconCache = {};
  final _flutterAndroidLauncherPlugin = FlutterAndroidLauncher();

  @override
  void initState() {
    super.initState();
    _getInstalledApps();
  }

  Uint8List _decodeIcon(String base64) {
    return _iconCache.putIfAbsent(base64, () => base64Decode(base64));
  }

  Future<void> _getInstalledApps() async {
    try {
      final installedApps = await _flutterAndroidLauncherPlugin
          .getInstalledApps();
      setState(() {
        _apps = installedApps;
      });
    } on PlatformException catch (e) {
      print("Failed to get installed apps: '${e.message}'.");
    }
  }

  Future<void> _launchApp(String packageName, String profile) async {
    try {
      await _flutterAndroidLauncherPlugin.launchApp(packageName, profile);
    } on PlatformException catch (e) {
      print("Failed to launch app: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GridView.builder(
        itemCount: _apps.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemBuilder: (_, index) {
          final app = _apps[index];
          final iconBase64 = app['iconBase64']!;
          return AppIconTile(
            key: ValueKey(app["packageName"]!),
            icon: _decodeIcon(iconBase64),
            label: app['appName']!,
            onTap: () => _launchApp(app['packageName']!, app['profile']!),
          );
        },
      ),
    );
  }
}

class AppIconTile extends StatelessWidget {
  final Uint8List icon;
  final String label;
  final VoidCallback onTap;

  const AppIconTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              child: Image.memory(
                icon,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 3),
            SizedBox(
              child: Text(
                label,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [Shadow(blurRadius: 5, offset: Offset(2, 2))],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
