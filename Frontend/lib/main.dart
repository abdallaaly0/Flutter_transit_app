import 'package:flutter/material.dart';
import 'package:flutter_transit_app/screens/train_list.dart';
import 'maps.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MapSample(),
    );
  }
}

/*class MyHomePage extends StatelessWidget {
  final _bottomNavigationBarItems = [
    const BottomNavigationBarItem(
        icon: Icon(
          Icons.star,
          color: Colors.blue,
        ),
        label: 'Train Lines'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          TrainListScreen(),
        ],
      ),
      bottomNavigationBar:
          BottomNavigationBar(items: _bottomNavigationBarItems),
    );
  }
}
*/