import 'dart:ffi';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
          textTheme: TextTheme(
              body1: TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              display1: TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ))),
      home: HomeView(
        title: "TuuzIM",
      ),
    );
  }
}

class HomeView extends StatefulWidget {
  final String title;

  HomeView({this.title});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int counter = 0;

  void plusone() {
    setState(() {
      ++counter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text(
          "Pressed in " + counter.toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("tttt"),
                          content: Text("This is my message."),
                        );
                      });
                  print("aa");
                },
                child: Icon(Icons.account_balance_outlined),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                onPressed: null,
                child: Icon(Icons.add_a_photo),
              ),
              SizedBox(
                width: 10,
                height: 0,
              ),
              FloatingActionButton(
                onPressed: null,
                child: Icon(Icons.delete_forever),
              ),
              SizedBox(
                width: 10,
                height: 0,
              ),
              FloatingActionButton(
                onPressed: plusone,
                child: Icon(Icons.plus_one),
              ),
              SizedBox(
                width: 10,
                height: 0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
