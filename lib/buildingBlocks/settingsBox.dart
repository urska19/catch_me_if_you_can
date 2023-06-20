import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catch_me_if_you_can/utils/constants.dart';
import 'package:catch_me_if_you_can/utils/notifiers.dart';

class SettingsBox extends StatefulWidget {
  const SettingsBox({super.key});

  @override
  _SettingsBoxState createState() => _SettingsBoxState();
}

class _SettingsBoxState extends State<SettingsBox> {
  AudioPlayer playerButton = AudioPlayer();
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
    var singleNotifier = Provider.of<SingleNotifier>(context);
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
                "Select your struggle:",
                style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w600,
                    height: textHeight),
              ),
              const SizedBox(
                height: 15,
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: levelDifficulty
                      .map((d) => RadioListTile(
                            title: Text(d,
                                style: TextStyle(
                                    fontSize: contextSize, height: textHeight)),
                            value: d,
                            groupValue: singleNotifier.currentDifficulty,
                            selected: singleNotifier.currentDifficulty == d,
                            onChanged: (value) {
                              playerButton
                                  .play(AssetSource('audio/button.mp3'));
                              if (value != singleNotifier.currentDifficulty) {
                                singleNotifier.updateDifficulty(value!);
                              }
                            },
                          ))
                      .toList(),
                ),
              ),
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
