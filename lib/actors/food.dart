import 'package:flutter/material.dart';

class Food extends StatelessWidget {
  double padding;
  Food(this.padding, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Image.asset('assets/images/food_level1.png'),
    );
  }
}