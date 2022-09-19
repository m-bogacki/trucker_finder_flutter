import 'package:flutter/material.dart';

class TrucksMapScreen extends StatelessWidget {
  static const routeName = '/map';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: Center(
        child: Text('Map'),
      ),
    );
  }
}
