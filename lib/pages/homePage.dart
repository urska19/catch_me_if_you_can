import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:catch_me_if_you_can/buildingBlocks/infoBox.dart';
import 'package:catch_me_if_you_can/buildingBlocks/settingsBox.dart';
import 'package:catch_me_if_you_can/pages/level1Page.dart';
import 'package:catch_me_if_you_can/utils/helpers.dart';

import '../database/entities/userScore.dart';
import '../main.dart';
import '../utils/constants.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

Future<List<UserScore>> getTopScores() async {
  return await dbHelper.queryTop5Scores('userScore');
}

class _HomePageState extends State<HomePage> {
  late List<UserScore> top5Scores;
  AudioPlayer player = AudioPlayer();
  AudioPlayer playerButton = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    playBackgroundMusic();
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/first.png"),
            fit: BoxFit.fitWidth),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
            // mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          padding: const EdgeInsets.only(top: 45, left: 15),
                          child: IconButton(
                            icon:
                                Image.asset('assets/images/icon_settings.png'),
                            onPressed: () {
                              playButton();
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const SettingsBox();
                                  });
                            },
                          ),
                        )),
                    Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: const EdgeInsets.only(top: 45, right: 15),
                          child: IconButton(
                            icon: Image.asset('assets/images/icon_info.png'),
                            onPressed: () {
                              playButton();
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const InfoBox();
                                  });
                            },
                          ),
                        )),
                  ]),
              Expanded(child: Container()),
              Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: Colors.blueGrey.withOpacity(0.5)),
                  padding: const EdgeInsets.all(30),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Center(
                        child: Text(homePageTopScores,
                            style: TextStyle(
                                fontSize: titleSize,
                                color: Colors.white,
                                height: textHeight))),
                    FutureBuilder(
                      future: getTopScores(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text(snapshot.error.toString()));
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          // data loaded:
                          var userScores = snapshot.data as List<UserScore>;
                          if (userScores.isEmpty) {
                            return Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text(
                                    "Be the first to survive",
                                    style: TextStyle(
                                        fontSize: contextSize,
                                        color: Colors.white,
                                        height: textHeight)));
                          } else {
                            return ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                separatorBuilder: (context, index) =>
                                    const Divider(),
                                shrinkWrap: true,
                                itemCount: userScores.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Row(
                                    children: [
                                      Text(
                                        userScores[index].name.length >
                                                maxLengthOfNameToDisplay
                                            ? userScores[index]
                                                .name
                                                .substring(
                                                    0, maxLengthOfNameToDisplay)
                                                .trim()
                                            : userScores[index].name,
                                        style: TextStyle(
                                            fontSize: contextSize,
                                            color: Colors.white,
                                            height: textHeight),
                                      ),
                                      Expanded(
                                          child: Text('.' * 100,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                  color: Colors.white))),
                                      Text(
                                        "${userScores[index].score}",
                                        style: TextStyle(
                                            fontSize: contextSize,
                                            color: Colors.white,
                                            height: textHeight),
                                      )
                                    ],
                                  );
                                });
                          }
                        }
                      },
                    ),
                  ])),
              Expanded(child: Container()),
            ]),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          color: Colors.black,
          child: ElevatedButton(
              onPressed: () {
                playButton();
                player.dispose();
                Navigator.of(context)
                    .pushReplacement(createRouteSlide(Level1Page(), false));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey[700],
              ),
              child: Container(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(homePageBeginGame,
                      style: TextStyle(fontSize: actionButtonTextSize)))),
        ),
      ),
    );
  }

  void playButton() {
    playerButton.play(AssetSource('audio/button.mp3'));
  }

  void playBackgroundMusic() {
    player.play(AssetSource('audio/intro_heart_beat.mp3'));
    player.onPlayerComplete.listen((event) {
      player.play(
        AssetSource('audio/intro_heart_beat.mp3'),
      );
    });
  }
}
