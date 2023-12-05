import 'package:concordium_wallet/widgets/app_bar_constructors.dart';
import 'package:concordium_wallet/widgets/base_page.dart';
import 'package:flutter/material.dart';

class ExampleBaseWithPositionPage extends StatelessWidget {
  const ExampleBaseWithPositionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      appBar: AppBarConstructors.withInfo(
          context,
          "Some header",
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("This is it.."))),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 5)),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 200,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: -8.0,
                    right: -8.0,
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.red,
                    ),
                  )
                ],
              ),
            ),
            const Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
          ],
        ),
      ),
    );
  }
}
