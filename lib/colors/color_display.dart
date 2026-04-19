import 'package:flutter/material.dart';

class ColorDisplay extends StatelessWidget {
  final Color color;

  ColorDisplay({required this.color});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Color Display")),
      body: Center(
        child: Container(
          width: 150,
          height: 150,
          color: color,
        ),
      ),
    );
  }
}