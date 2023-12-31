/* GENERAL */
import 'package:tuple/tuple.dart';

double titleSize = 18;
double contextSize = 14;
double textHeight = 1.5;
double actionButtonTextSize = 28;

const nameOfGame = "Catch me if you can";
int blockGhostScore = 50;
int maxLengthOfNameToDisplay = 12;
int startScore = 0;
int defaultNumberOfTries = 3;

/* LEVELS */
int numberInRow = 11;
int numberOfSquares = numberInRow * 17;
int playerLevel1 = numberInRow * 15 + 1;
int playerLevel2 = numberInRow * 15 + 1;
int ghostLevel1 = numberInRow * 2 - 2;
int ghostLevel2 = 5;
String playerDirLevel1 = "right";
String playerDirLevel2 = "right";
String ghostLastLevel1 = "left";
String ghostLastLevel2 = "down";
String playPausedTextPlay = "GO";
String playPausedTextPause = "WAIT";
double foodPaddingLevel1 = 4.0;
double foodPaddingLevel2 = 8.0;

const List<int> barriersLevel1 = [
  0,
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
  21,
  32,
  43,
  54,
  65,
  76,
  87,
  109,
  120,
  131,
  142,
  153,
  164,
  175,
  11,
  22,
  33,
  44,
  55,
  66,
  77,
  99,
  110,
  121,
  132,
  143,
  154,
  165,
  176,
  177,
  178,
  179,
  180,
  181,
  182,
  183,
  184,
  185,
  186,
  24,
  35,
  46,
  57,
  26,
  37,
  38,
  39,
  28,
  30,
  41,
  52,
  63,
  78,
  81,
  70,
  59,
  61,
  72,
  83,
  86,
  100,
  103,
  114,
  125,
  127,
  116,
  105,
  108,
  123,
  134,
  145,
  156,
  129,
  140,
  151,
  162,
  158,
  147,
  148,
  149,
  160
];

List<int> foodLevel1 = [
  12,
  13,
  14,
  15,
  16,
  17,
  18,
  19,
  20,
  23,
  25,
  27,
  29,
  31,
  34,
  36,
  40,
  42,
  45,
  47,
  48,
  49,
  50,
  51,
  53,
  56,
  58,
  60,
  62,
  64,
  67,
  68,
  69,
  71,
  73,
  74,
  75,
  79,
  80,
  82,
  84,
  85,
  88,
  89,
  90,
  91,
  92,
  93,
  94,
  95,
  96,
  97,
  98,
  101,
  102,
  104,
  106,
  107,
  111,
  112,
  113,
  115,
  117,
  118,
  119,
  122,
  124,
  126,
  128,
  130,
  133,
  135,
  136,
  137,
  138,
  139,
  141,
  144,
  146,
  150,
  152,
  155,
  157,
  159,
  161,
  163,
  166,
  167,
  168,
  169,
  170,
  171,
  172,
  173,
  174
];

const List<Tuple2<int, int>> crossLRLevel1 = [Tuple2(88, 98)];
const List<Tuple2<int, int>> crossLRLevel2 = [Tuple2(77, 87), Tuple2(132, 142)];
const List<Tuple2<int, int>> crossUDLevel2 = [Tuple2(5, 181)];
const List<int> blockGhost2 = [12, 104, 163];

const List<int> barriersLevel2 = [
  0,
  1,
  2,
  3,
  4,
  6,
  7,
  8,
  9,
  10,
  21,
  32,
  38,
  39,
  41,
  43,
  49,
  52,
  54,
  65,
  76,
  98,
  109,
  120,
  131,
  153,
  164,
  175,
  11,
  22,
  33,
  44,
  55,
  66,
  88,
  99,
  110,
  121,
  143,
  154,
  165,
  176,
  177,
  178,
  179,
  180,
  182,
  183,
  184,
  185,
  186,
  15,
  17,
  58,
  59,
  92,
  103,
  116,
  117,
  122,
  130,
  144,
  146,
  147,
  149,
  152,
  160
];

List<int> foodLevel2 = [
  5,
  13,
  14,
  16,
  18,
  19,
  20,
  23,
  24,
  25,
  26,
  27,
  28,
  29,
  30,
  31,
  34,
  35,
  36,
  37,
  40,
  42,
  45,
  46,
  47,
  48,
  50,
  51,
  53,
  56,
  57,
  60,
  61,
  62,
  63,
  64,
  67,
  68,
  69,
  70,
  71,
  72,
  73,
  74,
  75,
  77,
  78,
  79,
  80,
  81,
  82,
  83,
  84,
  85,
  86,
  87,
  89,
  90,
  91,
  93,
  94,
  95,
  96,
  97,
  100,
  101,
  102,
  105,
  106,
  107,
  108,
  111,
  112,
  113,
  114,
  115,
  118,
  119,
  123,
  124,
  125,
  126,
  127,
  128,
  129,
  132,
  133,
  134,
  135,
  136,
  137,
  138,
  139,
  140,
  141,
  142,
  145,
  148,
  150,
  151,
  155,
  156,
  157,
  158,
  159,
  161,
  162,
  166,
  167,
  168,
  169,
  170,
  171,
  172,
  173,
  174,
  181
];

/* INFO BOX */
const double infoBoxPadding = 20;

/* Text */
const homePageBeginGame = "LET'S GO!";
const homePageTopScores = "The Fearless Five";
const levelPageScore = "Catch:";
const levelPageAlertBackButtonTitle = "That's it?";
const levelPageAlertBackButtonContext = "Is the fun over?";
const buttonYep = "Yep";
const buttonNope = "Nope";
const levelPageAlertTryAgainTitle = "One more?";
const buttonEnough = "Enough";
const buttonTryAgain = "One more";
const textFieldEnterName = "Label Hero";
const levelPageAlertRunAway = "You run away!";
const buttonNextOne = "Next one";
const buttonYay = "Yay!";
const levelPageAlertOverTitle = "The fun is over.";
const levelPageAlertOverContext = "Catch:";
const buttonOhNo = "Oh, no!";
const leaveLevel = "I'am out";

/* LEVELS */

List<String> levelDifficulty = ['Freshman Foothills', 'Skilled Summit'];
