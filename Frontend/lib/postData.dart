import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'post_client.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Variable being displayed on screen when button is clicked
  String aTrainData = 'Hello World';

  //Creates an instance of object PostClient that handels http requests
  final PostClient _postClient = PostClient();

  //Fucntion called when button is clicked
  void _getATrainData() async {
    //Gets data from API stores it into varbalie
    final data = await _postClient.fetchPost();
    print(data);

    setState(() {
      aTrainData = data.data; //Displays data on screen
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(aTrainData,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getATrainData,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
