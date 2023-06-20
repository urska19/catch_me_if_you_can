
import 'package:flutter/material.dart';
import 'package:catch_me_if_you_can/pages/levelPage.dart';
import 'package:catch_me_if_you_can/utils/constants.dart';

class Level2Page extends StatefulWidget {
    int currentScore;
    int numberOfAttempts;
    Level2Page(this.currentScore, this.numberOfAttempts, {super.key});
  @override
  _Level2PageState createState() => _Level2PageState();
}

class _Level2PageState extends State<Level2Page> {
  @override
  Widget build(BuildContext context) {
    return LevelPage(2, widget.numberOfAttempts, widget.currentScore, playerLevel2, ghostLevel2, playerDirLevel2, ghostLastLevel2, foodLevel2, barriersLevel2, blockGhost2, crossLRLevel2, crossUDLevel2, Colors.brown.shade600, Colors.brown.shade700, Colors.brown, foodPaddingLevel2);
  }
}
