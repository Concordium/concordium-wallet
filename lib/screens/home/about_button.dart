import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Button that when pressed shows the about page for the app, including the license page.
class AboutButton extends StatelessWidget {
  const AboutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        PackageInfo.fromPlatform().then((packageInfo) {
          showAboutDialog(
            context: context,
            applicationName: packageInfo.appName,
            applicationVersion: packageInfo.version,
            applicationIcon: SvgPicture.asset(
              'assets/graphics/CCD.svg',
              semanticsLabel: 'CCD Logo',
            ),
          );
        });
      },
      child: const Text('Show About'),
    );
  }
}
