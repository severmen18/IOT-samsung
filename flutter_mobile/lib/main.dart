import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Проект на iot',
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  dynamic my_temp = "0";
  dynamic my_humidity = "0";
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }
  bool ustal = false;
  @override
  Widget build(BuildContext context) {
    var counter = 3;
    if (ustal == false){
      ustal = true;
      Timer.periodic(const Duration(seconds: 1), (timer) async {

        var response=  await http.get(Uri.parse("http://192.168.137.1:8000/get-temp"));
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
        var a = 6;
        setState(() {
          my_temp = decodedResponse['temp'];
          my_humidity = decodedResponse['humidity'];
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        backgroundColor: Colors.amber,
        title: Text("Проект на iot"),
      ),
      body: Column(
        children: [
          Card(
          shadowColor: Colors.blue,
            child:   Container(
              width: double.infinity,
              child: Text(
                  "Выберите режим",
                style: TextStyle(fontFamily: 'Georgia', fontSize: 20, ),
              ),
              alignment: Alignment.center,
            ),
          ),
          Text("Температура "+my_temp+", влажность "+my_humidity),
          TextButton(onPressed: () async {
            await http.get(Uri.parse("http://192.168.137.1:8000/set-status?status=0"));
          }, child: Text("Полное отключение")),
          TextButton(onPressed: () async {
            await http.get(Uri.parse("http://192.168.137.1:8000/set-status?status=1"));
          }, child: Text("Нагрев")),
          TextButton(onPressed: () async {
            await http.get(Uri.parse("http://192.168.137.1:8000/set-status?status=2"));
          }, child: Text("Провертивание")),

        ],
      )
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}



