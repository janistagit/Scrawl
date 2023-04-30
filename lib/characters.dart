import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:english_words/english_words.dart';
import 'package:scrawl/picture.dart';

class MyCharacterPage extends StatefulWidget {
  const MyCharacterPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyCharacterPage> createState() => _MyCharacterPageState();
}

class _MyCharacterPageState extends State<MyCharacterPage> {
  String _idea = "";
  static const List<String> characters = [
    "fairy", "wizard", "knight", "dragon", "farmer", "cowboy", "archer", "mage",
    "bandit", "assassin", "queen", "king", "princess", "prince", "warrior", "scholar",
    "medic", "student", "witch", "druid", "summoner", "spy", "healer", "thief",
    "magical girl", "cleric", "chef", "engineer", "sniper", "hero", "singer", "maid",
    "necromancer", "mermaid", "harpy", "zombie", "paladin", "bard", "astrologer",
    "pirate", "librarian", "artist", "ninja", "lawyer", "guard", "bartender", "dancer",
    "swordsman", "scientist", "musician"
  ];
  int dropdownvalue = 30;
  var items = [30, 60, 120, 300];
  Map<int, String> duration() => {
    30: "30 sec",
    60: "1 min",
    120: "2 min",
    300: "5 min"
  };
  bool activated = false;

  void generateIdea() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      final _random = new Random();
      String adj = adjectives[_random.nextInt(adjectives.length)];
      String character = characters[_random.nextInt(characters.length)];
      _idea = adj + " " + character;
    });
  }

  Timer _timer = Timer(const Duration(seconds: 10), () => null);
  int _start = 0;
  int _min = 0;
  bool countdownComplete = true;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    if (_timer != null) {
      _timer.cancel();
      _start = dropdownvalue;
      _min = (_start/60).truncate();
      countdownComplete = false;
    }
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            countdownComplete = true;
          });
        } else {
          setState(() {
            _start--;
            _min = (_start/60).truncate();
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String intFixed(int n, int count) => n.toString().padLeft(count, "0");

  Future<void> _navigateToCamera(BuildContext context) async {
    WidgetsFlutterBinding.ensureInitialized();

    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TakePictureScreen(camera:firstCamera)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(activated && countdownComplete){
      _navigateToCamera(context);
      activated = false;
    }

    return Stack( // <-- STACK AS THE SCAFFOLD PARENT
        children: [
    Container(
    decoration: BoxDecoration(
    image: DecorationImage(
        image: AssetImage("assets/scrawl_bg.png"), // <-- BACKGROUND IMAGE
    fit: BoxFit.fitHeight,
    ),
    ),
    ),
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
     Scaffold(
    backgroundColor: Colors.transparent, // <-- SCAFFOLD WITH TRANSPARENT BG
    appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Draw:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35.0, // insert your font size here
              ),
            ),
            Text(
              _idea,
              style: TextStyle(
                fontSize: 35.0, // insert your font size here
              ),
            ),
            const SizedBox(height: 15),
            FilledButton(
              style:
              ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    // If the button is pressed, return grey, otherwise purple
                    if (!countdownComplete) {
                      return Colors.grey;
                    }
                    return Colors.deepPurple;
                  })),
              onPressed: () {
                countdownComplete ? generateIdea() : null;
                countdownComplete ? startTimer() : null;
                activated = true;
              },
              child: const Text('Generate',
                style: TextStyle(
                  fontSize: 20.0, // insert your font size here
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(intFixed(_min, 2) + ":" + intFixed(_start%60, 2),
              style: TextStyle(
                fontSize: 35.0, // insert your font size here
              ),
            ),
            const SizedBox(height: 15),
            DropdownButton(

              // Initial Value
              value: dropdownvalue,

              // Down Arrow Icon
              icon: const Icon(Icons.keyboard_arrow_down),

              // Array list of items
              items: items.map((int items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items.toString()),
                );
              }).toList(),
              // After selecting the desired option,it will
              // change button value to selected value
              onChanged: (int? newValue) {
                setState(() {
                  dropdownvalue = newValue!;
                });
              },
              style: const TextStyle(
                  fontSize: 25.0,
                  color: Colors.blueGrey
              ),
            ),
          ],
        ),
      ),
     ),]
    );
  }
}
