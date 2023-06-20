import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catch_me_if_you_can/actors/food.dart';
import 'package:catch_me_if_you_can/actors/ghost.dart';
import 'package:catch_me_if_you_can/actors/ghostBlocker.dart';
import 'package:catch_me_if_you_can/buildingBlocks/pixel.dart';
import 'package:catch_me_if_you_can/actors/player.dart';
import 'package:catch_me_if_you_can/pages/homePage.dart';
import 'package:catch_me_if_you_can/pages/level2Page.dart';
import 'package:catch_me_if_you_can/utils/constants.dart';
import 'package:catch_me_if_you_can/utils/helpers.dart';
import 'package:catch_me_if_you_can/utils/notifiers.dart';
import 'package:tuple/tuple.dart';

import '../database/entities/userScore.dart';
import '../main.dart';

class LevelPage extends StatefulWidget {
  int levelNumber;
  int numberOfAttempts;
  int score;
  int player;
  int ghost;
  double foodPadding;
  String direction;
  String ghostLast;
  List<int> foodLevel;
  List<int> barriersLevel;
  List<int> blockGhost;
  List<Tuple2<int, int>> crossLRLevel;
  List<Tuple2<int, int>> crossUDLevel;
  Color innerBarrierColor;
  Color outerBarrierColor;
  Color textInputColor;
  LevelPage(
      this.levelNumber,
      this.numberOfAttempts,
      this.score,
      this.player,
      this.ghost,
      this.direction,
      this.ghostLast,
      this.foodLevel,
      this.barriersLevel,
      this.blockGhost,
      this.crossLRLevel,
      this.crossUDLevel,
      this.innerBarrierColor,
      this.outerBarrierColor,
      this.textInputColor,
      this.foodPadding,
      {super.key});

  @override
  _LevelPageState createState() => _LevelPageState();
}

class _LevelPageState extends State<LevelPage>
    with SingleTickerProviderStateMixin {
  Timer? timerPlayer;
  Timer? timerGhost;
  Timer? timerDialog;
  late int score = widget.score;
  bool paused = true;
  bool newGame = true;
  String playPausedText = playPausedTextPlay;
  late int numberOfTries = widget.numberOfAttempts;
  late List<int> foodInLevel = List.from(widget.foodLevel);
  late List<int> barriersLevel = List.from(widget.barriersLevel);
  late List<int> blockGhost = List.from(widget.blockGhost);
  late List<Tuple2<int, int>> crossLRLevel = List.from(widget.crossLRLevel);
  late List<Tuple2<int, int>> crossUDLevel = List.from(widget.crossUDLevel);
  TextEditingController firstNameController = TextEditingController();
  late AnimationController animationController;
  AudioPlayer player = AudioPlayer();
  AudioPlayer playerCaught = AudioPlayer();
  AudioPlayer playerGameOver = AudioPlayer();
  AudioPlayer playerNextLevel = AudioPlayer();
  AudioPlayer playerButton = AudioPlayer();

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    disposeTimers();
    super.dispose();
  }

  // when back button on Android is tapped
  Future<bool> _onWillPop() async {
    setState(() {
      paused = true;
      playPausedText = playPausedTextPlay;
    });
    return (await leaveLevelDialog()) ?? false;
  }

  void startGame() {
    timerDialog = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      // caught
      if (widget.player == widget.ghost) {
        setState(() {
          widget.player = -1;
        });
        // reduce tries
        if (defaultNumberOfTries - numberOfTries < defaultNumberOfTries - 1) {
          numberOfTries--;
          setState(() {
            paused = true;
            playPausedText = playPausedTextPlay;
          });
          // still more tries available - user can continue or go back to homePage
          if (widget.levelNumber == 1) {
            playerCaught.play(AssetSource('audio/angry_girl.mp3'));
          } else {
            playerCaught.play(AssetSource('audio/mans_cry.mp3'));
          }
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Center(
                      child: Text(levelPageAlertTryAgainTitle,
                          style: TextStyle(
                              height: textHeight, fontSize: titleSize))),
                  content: Text(attemptsLeftText(numberOfTries),
                      style:
                          TextStyle(height: textHeight, fontSize: contextSize)),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        playButton();
                        Navigator.of(context).pushAndRemoveUntil(
                            createRouteSlide(HomePage(), true),
                            (Route<dynamic> route) => false);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.outerBarrierColor,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        child: const Text(buttonEnough),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        playButton();
                        setState(() {
                          prepareToGoAgain();
                          restart();
                          Navigator.pop(context);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.outerBarrierColor,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        child: const Text(buttonTryAgain),
                      ),
                    )
                  ],
                );
              });
        } else {
          // continue
          setState(() {
            paused = true;
            playPausedText = playPausedTextPlay;
          });
          if (numberOfTries > 0) numberOfTries--;
          player.play(AssetSource('audio/fail.mp3'));
          // no more tries left - game over dialog
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Center(
                      child: Text(levelPageAlertOverTitle,
                          style: TextStyle(
                              height: textHeight, fontSize: titleSize))),
                  content: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text("$levelPageAlertOverContext $score",
                            style: TextStyle(
                                height: textHeight, fontSize: contextSize)),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 16),
                            child: TextFormField(
                              cursorColor: widget.textInputColor,
                              keyboardType: TextInputType.name,
                              controller: firstNameController,
                              onSaved: (value) {
                                firstNameController.text = value!;
                              },
                              decoration: InputDecoration(
                                border: const UnderlineInputBorder(),
                                labelText: textFieldEnterName,
                                labelStyle:
                                    TextStyle(color: widget.textInputColor),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: widget.textInputColor)),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: widget.textInputColor),
                                ),
                              ),
                            )),
                      ]),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        playButton();
                        storeScore(firstNameController);
                        Navigator.of(context).pushAndRemoveUntil(
                            createRouteSlide(HomePage(), true),
                            (Route<dynamic> route) => false);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.outerBarrierColor,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        child: const Text(buttonOhNo),
                      ),
                    )
                  ],
                );
              });
        }
      }
      // no more food - winner
      if (foodInLevel.isEmpty) {
        timerDialog!.cancel();
        setState(() {
          paused = true;
          playPausedText = playPausedTextPlay;
        });
        // level 1 -> continue to level 2
        if (widget.levelNumber == 1) {
          playerNextLevel.play(AssetSource(('audio/level_passed.mp3')));
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Center(
                      child: Text(
                    levelPageAlertRunAway,
                    style: TextStyle(fontSize: titleSize, height: textHeight),
                  )),
                  content: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text("$levelPageAlertOverContext $score",
                            style: TextStyle(
                                height: textHeight, fontSize: contextSize)),
                      ]),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        playButton();
                        Navigator.of(context).pushReplacement(createRouteSlide(
                            Level2Page(score, numberOfTries), false));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.outerBarrierColor,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        child: const Text(buttonNextOne),
                      ),
                    )
                  ],
                );
              });
        } else {
          // level 2 - record players name
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Center(
                      child: Text(
                    levelPageAlertRunAway,
                    style: TextStyle(fontSize: titleSize, height: textHeight),
                  )),
                  content: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text("$levelPageAlertOverContext: $score",
                            style: TextStyle(
                                height: textHeight, fontSize: contextSize)),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 16),
                            child: TextFormField(
                              cursorColor: widget.textInputColor,
                              keyboardType: TextInputType.name,
                              controller: firstNameController,
                              onSaved: (value) {
                                firstNameController.text = value!;
                              },
                              decoration: InputDecoration(
                                border: const UnderlineInputBorder(),
                                labelText: textFieldEnterName,
                                labelStyle: TextStyle(
                                    color: widget.textInputColor,
                                    fontSize: contextSize,
                                    height: textHeight),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: widget.textInputColor)),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: widget.textInputColor),
                                ),
                              ),
                            )),
                      ]),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        playButton();
                        storeScore(firstNameController);
                        Navigator.of(context).pushAndRemoveUntil(
                            createRouteSlide(HomePage(), true),
                            (Route<dynamic> route) => false);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.outerBarrierColor,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        child: const Text(buttonYay),
                      ),
                    )
                  ],
                );
              });
        }
      }
    });
    // ghost's moves and his tempo
    timerGhost = Timer.periodic(const Duration(milliseconds: 190), (timer) {
      if (!paused) {
        var singleNotifier =
            Provider.of<SingleNotifier>(context, listen: false);
        if (singleNotifier.currentDifficulty == levelDifficulty[0]) {
          moveGhost();
        } else {
          moveGhostAdvanced();
        }
      }
    });
    // player's tempo
    timerPlayer = Timer.periodic(const Duration(milliseconds: 220), (timer) {
      // reduce food
      if (foodInLevel.contains(widget.player)) {
        setState(() {
          foodInLevel.remove(widget.player);
        });
        score++;
      }
      // reduce ghost blockers
      if (blockGhost.contains(widget.player)) {
        setState(() {
          blockGhost.remove(widget.player);
        });
        score = score + blockGhostScore;
      }

      switch (widget.direction) {
        case "left":
          if (!paused) moveLeft();
          break;
        case "right":
          if (!paused) moveRight();
          break;
        case "up":
          if (!paused) moveUp();
          break;
        case "down":
          if (!paused) moveDown();
          break;
      }
    });
  }

  void restart() {
    startGame();
  }

  void disposePlayers() {
    player.dispose();
    playerCaught.dispose();
    playerGameOver.dispose();
    playerNextLevel.dispose();
    playerButton.dispose();
  }

  void disposeTimers() {
    timerPlayer?.cancel();
    timerDialog?.cancel();
    timerGhost?.cancel();
  }

  void playFootstep(int position) {
    if (!foodInLevel.contains(position) && !blockGhost.contains(position)) {
      player.play(AssetSource('audio/footstep.mp3'));
    } else if (foodInLevel.contains(position)) {
      player.play(AssetSource('audio/eat.mp3'));
    } else if (blockGhost.contains(position)) {
      player.play(AssetSource('audio/ghost_guard_eaten.mp3'));
    }
  }

  void playButton() {
    playerButton.play(AssetSource('audio/button.mp3'));
  }

  storeScore(TextEditingController controller) async {
    var name = controller.text.trim();
    var storeName = name == "" ? "/" : name;
    var userScore = UserScore(name: storeName, score: score);
    dbHelper.insert('userScore', userScore.toMap());
    controller.text = "";
  }

  String attemptsLeftText(int attempts) {
    if (attempts == 1) {
      return "$numberOfTries attempt left.";
    } else {
      return "$numberOfTries attempts left.";
    }
  }

  List<Container> attemptsLeftTextPicture(int attempts) {
    List<Container> attempsLeft = [];
    for (int i = 1; i <= attempts; i++) {
      attempsLeft.add(Container(
        height: 35,
        padding: const EdgeInsets.only(bottom: 5.0, right: 8),
        child: Player('front'),
      ));
    }
    return attempsLeft;
  }

  void prepareToGoAgain() {
    setState(() {
      widget.player = widget.levelNumber == 1 ? playerLevel1 : playerLevel2;
      widget.direction =
          widget.levelNumber == 1 ? playerDirLevel1 : playerDirLevel2;
      widget.direction = playerDirLevel1;
      playPausedText = playPausedTextPause;
      paused = false;
    });
    timerPlayer?.cancel();
    timerGhost?.cancel();
    timerDialog?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Column(children: [
            Expanded(
                flex: 5,
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    if (details.delta.dy > 0) {
                      widget.direction = "down";
                    } else if (details.delta.dy < 0) {
                      widget.direction = "up";
                    }
                  },
                  onHorizontalDragUpdate: (details) {
                    if (details.delta.dx > 0) {
                      widget.direction = "right";
                    } else if (details.delta.dx < 0) {
                      widget.direction = "left";
                    }
                  },
                  child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: numberOfSquares,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: numberInRow),
                      itemBuilder: (BuildContext context, int index) {
                        if (widget.player == index) {
                          switch (widget.direction) {
                            case "left":
                              return Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationY(pi),
                                child: Player('side'),
                              );
                            case "right":
                              return Player('side');
                            case "up":
                              return Player('back');
                            case "down":
                              return Player('front');
                            default:
                              return Player('side');
                          }
                        } else if (widget.ghost == index) {
                          return Ghost();
                        } else if (barriersLevel.contains(index)) {
                          return Pixel(widget.innerBarrierColor,
                              widget.outerBarrierColor, 4);
                        } else if (blockGhost.contains(index)) {
                          return AnimatedBuilder(
                            animation: animationController,
                            child: GhostBlocker(),
                            builder: (BuildContext context, Widget? child) {
                              return Transform.rotate(
                                angle: animationController.value * 6.3,
                                child: child,
                              );
                            },
                          );
                        } else if (foodInLevel.contains(index)) {
                          return Food(widget.foodPadding);
                        } else {
                          return Pixel(Colors.black, Colors.black, 12);
                        }
                      }),
                )),
            Expanded(
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                        child: Column(children: [
                      Expanded(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:
                                    attemptsLeftTextPicture(numberOfTries)),
                            Text("$levelPageScore $score",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: contextSize,
                                    height: textHeight))
                          ])),
                      Expanded(
                          child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(bottom: 16),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    paused = true;
                                    playPausedText = playPausedTextPlay;
                                  });
                                  playButton();
                                  leaveLevelDialog();
                                },
                                child: Text(leaveLevel,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: contextSize,
                                        height: textHeight)),
                              )))
                    ])),
                    Expanded(
                        child: Container(
                            alignment: Alignment.center,
                            child: GestureDetector(
                                onTap: () {
                                  playButton();
                                  if (paused) {
                                    paused = false;
                                    setState(() {
                                      playPausedText = playPausedTextPause;
                                    });
                                    if (newGame) {
                                      startGame();
                                      newGame = false;
                                    }
                                  } else {
                                    paused = true;
                                    setState(() {
                                      playPausedText = playPausedTextPlay;
                                    });
                                  }
                                },
                                child: Text(playPausedText,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: actionButtonTextSize))))),
                  ]),
            ),
          ]),
        ));
  }

  leaveLevelDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(levelPageAlertBackButtonTitle,
            style: TextStyle(height: textHeight, fontSize: titleSize)),
        content: Text(levelPageAlertBackButtonContext,
            style: TextStyle(height: textHeight, fontSize: contextSize)),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              playButton();
              Navigator.of(context).pop(false);
            },
            child: const Text(buttonNope),
          ),
          TextButton(
            onPressed: () {
              playButton();
              Navigator.of(context).pushAndRemoveUntil(
                  createRouteSlide(HomePage(), true),
                  (Route<dynamic> route) => false);
            },
            child: const Text(buttonYep),
          ),
        ],
      ),
    );
  }

/* MOVEMENTS */
  void moveLeft() {
    if (!barriersLevel.contains(widget.player - 1)) {
      setState(() {
        widget.player--;
      });
      playFootstep(widget.player);
    } else {
      for (var item in crossLRLevel) {
        if (widget.player == item.item1) {
          setState(() {
            widget.player = item.item2;
          });
          playFootstep(widget.player);
        }
      }
    }
  }

  void moveRight() {
    if (!barriersLevel.contains(widget.player + 1)) {
      setState(() {
        widget.player++;
      });
      playFootstep(widget.player);
    } else {
      for (var item in crossLRLevel) {
        if (widget.player == item.item2) {
          setState(() {
            widget.player = item.item1;
          });
          playFootstep(widget.player);
        }
      }
    }
  }

  void moveUp() {
    bool set = false;
    if (!barriersLevel.contains(widget.player - numberInRow)) {
      for (var item in crossUDLevel) {
        if (widget.player == item.item1) {
          setState(() {
            widget.player = item.item2;
          });
          set = true;
        }
      }
      if (!set) {
        setState(() {
          widget.player -= numberInRow;
        });
      } else {
        set = false;
      }
      playFootstep(widget.player);
    }
  }

  void moveDown() {
    bool set = false;
    if (!barriersLevel.contains(widget.player + numberInRow)) {
      for (var item in crossUDLevel) {
        if (widget.player == item.item2) {
          setState(() {
            widget.player = item.item1;
          });
          set = true;
        }
      }
      if (!set) {
        setState(() {
          widget.player += numberInRow;
        });
      } else {
        set = false;
      }
      playFootstep(widget.player);
    }
  }

  bool moveGhostRight() {
    bool set = false;
    bool moveMade = false;
    if (!barriersLevel.contains(widget.ghost + 1)) {
      for (var item in crossLRLevel) {
        if (widget.ghost == item.item2) {
          setState(() {
            widget.ghost = item.item1;
          });
          set = true;
        }
      }
      if (!set) {
        setState(() {
          widget.ghost++;
        });
      } else {
        set = false;
      }
      moveMade = true;
    }
    return moveMade;
  }

  bool moveGhostLeft() {
    bool set = false;
    bool moveMade = false;
    if (!barriersLevel.contains(widget.ghost - 1)) {
      for (var item in crossLRLevel) {
        if (widget.ghost == item.item1) {
          setState(() {
            widget.ghost = item.item2;
          });
          set = true;
        }
      }
      if (!set) {
        setState(() {
          widget.ghost--;
        });
      } else {
        set = false;
      }
      moveMade = true;
    }
    return moveMade;
  }

  bool moveGhostDown() {
    bool set = false;
    bool moveMade = false;
    if (!barriersLevel.contains(widget.ghost + numberInRow)) {
      for (var item in crossUDLevel) {
        if (widget.ghost == item.item2) {
          setState(() {
            widget.ghost = item.item1;
          });
          set = true;
        }
      }
      if (!set) {
        setState(() {
          widget.ghost += numberInRow;
        });
      } else {
        set = false;
      }
      moveMade = true;
    }
    return moveMade;
  }

  bool moveGhostUp() {
    bool set = false;
    bool moveMade = false;
    if (!barriersLevel.contains(widget.ghost - numberInRow)) {
      for (var item in crossUDLevel) {
        if (widget.ghost == item.item1) {
          setState(() {
            widget.ghost = item.item2;
          });
          set = true;
        }
      }
      if (!set) {
        setState(() {
          widget.ghost -= numberInRow;
        });
      } else {
        set = false;
      }
      moveMade = true;
    }
    return moveMade;
  }

  void moveGhost() {
    switch (widget.ghostLast) {
      case "left":
        bool stepMade = moveGhostLeft();
        if (!stepMade) {
          if (!barriersLevel.contains(widget.ghost - numberInRow) &&
              !barriersLevel.contains(widget.ghost + numberInRow)) {
            var direction = randomListElement(['right', 'up', 'down']);
            setState(() {
              widget.ghost = directionToPosition(direction, widget.ghost);
              widget.ghostLast = direction;
            });
          } else if (!barriersLevel.contains(widget.ghost - numberInRow)) {
            var direction = randomListElement(['right', 'up']);
            setState(() {
              widget.ghost = directionToPosition(direction, widget.ghost);
              widget.ghostLast = direction;
            });
          } else if (!barriersLevel.contains(widget.ghost + numberInRow)) {
            var direction = randomListElement(['right', 'down']);
            setState(() {
              widget.ghost = directionToPosition(direction, widget.ghost);
              widget.ghostLast = direction;
            });
          } else {
            var direction = randomListElement(['right']);
            setState(() {
              widget.ghost = directionToPosition(direction, widget.ghost);
              widget.ghostLast = direction;
            });
          }
        }
        break;
      case "right":
        bool stepMade = moveGhostRight();
        if (!stepMade) {
          if (!barriersLevel.contains(widget.ghost - numberInRow) &&
              !barriersLevel.contains(widget.ghost + numberInRow)) {
            var direction = randomListElement(['left', 'up', 'down']);
            setState(() {
              widget.ghost = directionToPosition(direction, widget.ghost);
              widget.ghostLast = direction;
            });
          } else if (!barriersLevel.contains(widget.ghost - numberInRow)) {
            var direction = randomListElement(['left', 'up']);
            setState(() {
              widget.ghost = directionToPosition(direction, widget.ghost);
              widget.ghostLast = direction;
            });
          } else if (!barriersLevel.contains(widget.ghost + numberInRow)) {
            var direction = randomListElement(['left', 'down']);
            setState(() {
              widget.ghost = directionToPosition(direction, widget.ghost);
              widget.ghostLast = direction;
            });
          } else {
            var direction = randomListElement(['left']);
            setState(() {
              widget.ghost = directionToPosition(direction, widget.ghost);
              widget.ghostLast = direction;
            });
          }
        }
        break;
      case "up":
        bool stepMade = moveGhostUp();
        if (!stepMade) {
          if (!barriersLevel.contains(widget.ghost - 1) &&
              !barriersLevel.contains(widget.ghost + 1)) {
            var direction = randomListElement(['down', 'left', 'right']);
            setState(() {
              widget.ghost = directionToPosition(direction, widget.ghost);
              widget.ghostLast = direction;
            });
          } else if (!barriersLevel.contains(widget.ghost - 1)) {
            var direction = randomListElement(['down', 'left']);
            setState(() {
              widget.ghost = directionToPosition(direction, widget.ghost);
              widget.ghostLast = direction;
            });
          } else if (!barriersLevel.contains(widget.ghost + 1)) {
            var direction = randomListElement(['down', 'right']);
            setState(() {
              widget.ghost = directionToPosition(direction, widget.ghost);
              widget.ghostLast = direction;
            });
          } else {
            var direction = randomListElement(['down']);
            setState(() {
              widget.ghost = directionToPosition(direction, widget.ghost);
              widget.ghostLast = direction;
            });
          }
        }
        break;
      case "down":
        bool stepMade = moveGhostDown();
        if (!stepMade) {
          if (!barriersLevel.contains(widget.ghost - 1) &&
              !barriersLevel.contains(widget.ghost + 1)) {
            var direction = randomListElement(['up', 'left', 'right']);
            setState(() {
              widget.ghost = directionToPosition(direction, widget.ghost);
              widget.ghostLast = direction;
            });
          } else if (!barriersLevel.contains(widget.ghost - 1)) {
            var direction = randomListElement(['up', 'left']);
            setState(() {
              widget.ghost = directionToPosition(direction, widget.ghost);
              widget.ghostLast = direction;
            });
          } else if (!barriersLevel.contains(widget.ghost + 1)) {
            var direction = randomListElement(['up', 'right']);
            setState(() {
              widget.ghost = directionToPosition(direction, widget.ghost);
              widget.ghostLast = direction;
            });
          } else {
            var direction = randomListElement(['up']);
            setState(() {
              widget.ghost = directionToPosition(direction, widget.ghost);
              widget.ghostLast = direction;
            });
          }
        }
        break;
    }
  }

  void moveGhostAdvanced() {
    var rowGhost = (widget.ghost / numberInRow).floor();
    var colGhost = widget.ghost.remainder(numberInRow);

    var rowPlayer = (widget.player / numberInRow).floor();
    var colPlayer = widget.player.remainder(numberInRow);

    if ((colPlayer - colGhost) > 0) {
      //right
      bool rightStepMade = moveGhostRight();
      if (!rightStepMade) {
        //up/down
        if ((rowPlayer - rowGhost) > 0) {
          //down
          bool downStepMade = moveGhostDown();
          if (!downStepMade) {
            bool leftStepMade = moveGhostLeft();
            if (!leftStepMade) {
              moveGhostUp();
            }
          }
        } else {
          //up
          bool upStepMade = moveGhostUp();
          if (!upStepMade) {
            bool leftStepMade = moveGhostLeft();
            if (!leftStepMade) {
              moveGhostDown();
            }
          }
        }
      }
    } else if ((colPlayer - colGhost) < 0) {
      //left
      bool leftStepMade = moveGhostLeft();
      if (!leftStepMade) {
        //up/down
        if ((rowPlayer - rowGhost) > 0) {
          //down
          bool downStepMade = moveGhostDown();
          if (!downStepMade) {
            bool rightStepMade = moveGhostRight();
            if (!rightStepMade) {
              moveGhostUp();
            }
          }
        } else {
          //up
          bool upStepMade = moveGhostUp();
          if (!upStepMade) {
            bool rightStepMade = moveGhostRight();
            if (!rightStepMade) {
              moveGhostDown();
            }
          }
        }
      }
    } else if ((colPlayer - colGhost) == 0) {
      //up/down
      if ((rowPlayer - rowGhost) > 0) {
        //down
        bool downStepMade = moveGhostDown();
        if (!downStepMade) {
          bool rightStepMade = moveGhostRight();
          if (!rightStepMade) {
            var leftStepMade = moveGhostLeft();
            if (!leftStepMade) {
              moveGhostUp();
            }
          }
        }
      } else {
        //up
        bool upStepMade = moveGhostUp();
        if (!upStepMade) {
          bool rightStepMade = moveGhostRight();
          if (!rightStepMade) {
            var leftStepMade = moveGhostLeft();
            if (!leftStepMade) {
              moveGhostDown();
            }
          }
        }
      }
    }
  }
}
