import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catch_me_if_you_can/utils/notifiers.dart';
import 'database/databaseHelper.dart';
import 'pages/HomePage.dart';

// Here we are using a global variable. You can use something like
// get_it in a production app.
final dbHelper = DatabaseHelper();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   // initialize the database
  await dbHelper.init();
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider<SingleNotifier>(create: (_) => SingleNotifier(),)
    ],
    child: CatchMeIfYouCan(),
  ));
}

class CatchMeIfYouCan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'PressStart2P'),
      debugShowCheckedModeBanner: false,
      home: HomePage());
  }
}
