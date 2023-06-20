
import 'package:flutter/material.dart';
import 'package:catch_me_if_you_can/pages/levelPage.dart';
import 'package:catch_me_if_you_can/utils/constants.dart';

class Level1Page extends StatefulWidget {
  @override
  _Level1PageState createState() => _Level1PageState();
}

class _Level1PageState extends State<Level1Page> {

  @override
  Widget build(BuildContext context) {
    return LevelPage(1, defaultNumberOfTries, startScore, playerLevel1, ghostLevel1, playerDirLevel1, ghostLastLevel1, foodLevel1, barriersLevel1, [], crossLRLevel1, [], Colors.blueGrey.shade600, Colors.blueGrey.shade700, Colors.blueGrey, foodPaddingLevel1);
  }
}
