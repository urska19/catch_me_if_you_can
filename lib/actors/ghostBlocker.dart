import 'package:flutter/material.dart';

class GhostBlocker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Image.asset(
        'assets/images/food_bonus.png'
      ),
    );
  }
}