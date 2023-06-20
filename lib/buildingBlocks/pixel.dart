import 'package:flutter/material.dart';

class Pixel extends StatelessWidget {
  final innerColor;
  final outerColor;
  final double edgeInsets;

  Pixel(this.innerColor, this.outerColor, this.edgeInsets);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(1),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: EdgeInsets.all(edgeInsets),
              color: outerColor,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: innerColor
                ),
              ),
            )));
  }
}
