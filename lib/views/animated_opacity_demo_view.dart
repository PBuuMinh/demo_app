import 'package:flutter/material.dart';

const owlUrl =
    'https://raw.githubusercontent.com/flutter/website/master/src/images/owl.jpg';

class FadeInDemo extends StatefulWidget {
  const FadeInDemo({Key? key}) : super(key: key);

  @override
  State<FadeInDemo> createState() => _FadeInDemoState();
}

class _FadeInDemoState extends State<FadeInDemo> {
  double opacity = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AnimatedOpacity Demo')),
      body: Column(children: <Widget>[
        Image.network(owlUrl),
        TextButton(
          child: const Text(
            'Show Details',
            style: TextStyle(color: Colors.blueAccent),
          ),
          onPressed: () => setState(() {
            opacity = 1.0;
          }),
        ),
        AnimatedOpacity(
          duration: const Duration(seconds: 2),
          opacity: opacity,
          child: Column(
            children: const [
              Text('Type: Owl'),
              Text('Age: 39'),
              Text('Employment: None'),
            ],
          ),
        )
      ]),
    );
  }
}