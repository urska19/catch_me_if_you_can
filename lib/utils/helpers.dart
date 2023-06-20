import 'dart:math';

import 'package:flutter/material.dart';
import 'package:catch_me_if_you_can/utils/constants.dart';

T randomListElement<T>(List<T> list) {
  final randN = Random().nextInt(list.length);
  return list[randN];
}

int directionToPosition(String direction, int position) {
  switch (direction) {
    case "right":
      return position++;
    case "left":
      return position--;
    case "up":
      return position - numberInRow;
    case "down":
      return position + numberInRow;
    default:
      return position;
  }
}

Route createRouteSlide(Widget page, bool left) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = const Offset(1.0, 0.0);
      const end = Offset.zero;
      if (left) {
        begin = const Offset(-1.0, 0.0);
      }
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
