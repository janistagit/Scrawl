import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:english_words/english_words.dart';
import 'package:scrawl/animals.dart';
import 'package:scrawl/characters.dart';
import 'package:scrawl/objects.dart';

class MyIdeaPage extends StatefulWidget {
  const MyIdeaPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyIdeaPage> createState() => _MyIdeaPageState();
}

class _MyIdeaPageState extends State<MyIdeaPage> {
  String _idea = "";

  void generateIdea() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      final _random = new Random();
      String adj = adjectives[_random.nextInt(adjectives.length)];
      String noun = nouns[_random.nextInt(nouns.length)];
      _idea = adj + " " + noun;
    });
  }

  Timer _timer = Timer(const Duration(seconds: 10), () => null);
  int _start = 10;
  bool countdownComplete = true;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    if (_timer != null) {
      _timer.cancel();
      _start = 10;
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

  @override
  Widget build(BuildContext context) {
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
              'Categories',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35.0, // insert your font size here
              ),
            ),
            const SizedBox(height: 35),
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const MyAnimalPage(title: "Animal Ideas Page")));
              },
              child: const Text('Animals',
                style: TextStyle(
                  fontSize: 20.0, // insert your font size here
                ),
              ),
            ),
            const SizedBox(height: 15),
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const MyCharacterPage(title: "Character Ideas Page")));
              },
              child: const Text('Characters',
                style: TextStyle(
                  fontSize: 20.0, // insert your font size here
                ),
              ),
            ),
                                                                                    const SizedBox(height: 15),
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const MyObjectPage(title: "Object Ideas Page")));
              },
              child: const Text('Objects',
                style: TextStyle(
                  fontSize: 20.0, // insert your font size here
                ),
              ),
            ),
          ],
        ),
      ),
     ),]
    );
  }
}
