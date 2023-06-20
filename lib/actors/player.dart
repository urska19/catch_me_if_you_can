import 'package:flutter/material.dart';

class Player extends StatelessWidget {
  String direction;
  Player(this.direction, {super.key});

  @override
  Widget build(BuildContext context) {
    if (direction == 'front') {
      return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Image.asset('assets/images/player_front.png')
      );
    } else if (direction == 'back') {
      return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Image.asset('assets/images/player_back.png')
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Image.asset('assets/images/player_open.png')
      );
    }
  }
}
