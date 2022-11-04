import 'package:demo_app/constants/routes.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(layoutDemoRoute);
              },
              child: const Text('Layout Demo'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(animatedOpacityDemoRoute);
              },
              child: const Text('AnimatedOpacity Demo'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(animatedContainerDemoRoute);
              },
              child: const Text('AnimatedContainer Demo'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(appAuthDemoRoute);
              },
              child: const Text('AppAuth Demo'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(hiveDemoRoute);
              },
              child: const Text('Hive Demo'),
            ),
          ],
        ),
      ),
    );
  }
}
