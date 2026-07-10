import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';


class AppList extends StatefulWidget {
  const AppList({super.key});

  @override
  State<StatefulWidget> createState() => _AppListState();
}

class _AppListState extends State<AppList> {
  List<Application> _apps = [];

  @override
  void initState() {
    super.initState();

    DeviceApps.getInstalledApplications().then((initialApps) {
      setState(() {
        _apps = initialApps;
      });
    });

    DeviceApps.listenToAppsChanges().listen((event) {
      if (event is ApplicationEventInstalled) {
        setState(() {
          _apps.add(event.application);
        });
      } else if (event is ApplicationEventEnabled) {
        setState(() {
          _apps.add(event.application);
        });
      } else if (event is ApplicationEventUninstalled) {
        setState(() {
          _apps.removeWhere((app) => app.packageName == event.packageName);
        });
      } else if (event is ApplicationEventDisabled) {
        setState(() {
          _apps.removeWhere((app) => app.packageName == event.packageName);
        });
      } else if (event is ApplicationEventUpdated) {
        setState(() {
          _apps.removeWhere((app) => app.packageName == event.packageName);
          _apps.add(event.application);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _apps.length,
      itemBuilder: (context, index) {
        return Text(_apps[index].appName);
      },
    );
  }
}
