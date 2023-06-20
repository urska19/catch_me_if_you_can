import 'package:flutter/material.dart';
import 'package:catch_me_if_you_can/utils/constants.dart';

class InfoBox extends StatefulWidget {
  const InfoBox({super.key});

  @override
  _InfoBoxState createState() => _InfoBoxState();
}

class _InfoBoxState extends State<InfoBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(infoBoxPadding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(infoBoxPadding),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(infoBoxPadding),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Master the Mechanics",
                style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w600,
                    height: textHeight),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                  height: 450.0,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Text(
                        "Welcome to $nameOfGame! In this game, you'll navigate a maze while collecting items and avoiding enemies. \n\nSwipe in the direction you want to move.\nCollect all of the items to progress to the next level. If an enemy catches you, you'll lose a life.\nYou start with three lives. If you lose all of your lives, the game is over.\n\nThat's it! Let's see how far you can get!",
                        style: TextStyle(
                            fontSize: contextSize, height: textHeight),
                        textAlign: TextAlign.center,
                      ))),
              const SizedBox(
                height: 22,
              ),
            ],
          ),
        )
      ],
    );
  }
}
