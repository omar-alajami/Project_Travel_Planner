import 'package:flutter/material.dart';
import 'backend_logic.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planner_App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Travel Planner'),
          centerTitle: true,
        ),

        body: Returned(),
      ),
    );
  }
}

class Returned extends StatefulWidget{
  const Returned({super.key});
  @override
  State<Returned> createState() => _ReturnedState();
}

class _ReturnedState extends State<Returned>{

  String dest = '';
  late int nbOfPeople;
  late int duration;
  late int budget;

  @override
  Widget build(BuildContext context){
    return swinger();
  }

  Widget swinger(){
    if (dest == '') return submitTrip();
    else return result();
  }

  Widget submitTrip(){
    return Center(
      child: ListView (
        padding: EdgeInsets.fromLTRB(16, 8, 16, 8),

        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 4),//I have no idea what the spaces are like, we can test the app and tweak the numbers and see which give the best look
            child: TextField(
              decoration: InputDecoration(labelText: 'Destination'),
              onChanged: (gotDest){dest = gotDest;},
            )
          ),

          Padding(
            padding: EdgeInsets.only(bottom: 4),//I have no idea what the spaces are like, we can test the app and tweak the numbers and see which give the best look
            child: TextField(
              keyboardType: TextInputType.numberWithOptions(),
              decoration: InputDecoration(labelText: 'Number of People'),
              onChanged: (gotNb){nbOfPeople = int.tryParse(gotNb) ?? 0;},
            )
          ),

          Padding(
            padding: EdgeInsets.only(bottom: 4),//I have no idea what the spaces are like, we can test the app and tweak the numbers and see which give the best look
            child: TextField(
              keyboardType: TextInputType.numberWithOptions(),
              decoration: InputDecoration(labelText: 'Duration'),
              onChanged: (gotDur){duration = int.tryParse(gotDur) ?? 0;},
            ),
          ),

          Padding(
            padding: EdgeInsets.only(bottom: 4),//I have no idea what the spaces are like, we can test the app and tweak the numbers and see which give the best look
            child: TextField(
              keyboardType: TextInputType.numberWithOptions(),
              decoration: InputDecoration(labelText: 'Enter buget (0 for minimum or keep empty to disregard)'),
              onChanged: (gotBud){budget = parseBud(gotBud);},
            ),
          ),

          TextButton(onPressed: (){setState((){});}, child: Text('SUBMIT'))
        ]
      ),
    );
  }

  Widget result(){

    String shownString = '';
    try {
      Trip trip = Trip(dest, nbOfPeople, duration, budget);
      shownString = trip.availability();
    } catch (E){
      shownString = '$E';
    }

    return Center(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Text('IMG_HERE'),
                ),
                Text(shownString)
              ],
            )
          ),
          TextButton(onPressed: (){setState((){dest = '';});}, child: Text('CLOSE'))
        ]
      )
    );
  }
  

  int parseBud(String a){
    late int b;
    if (a == '') {b = -1;}
    else {b = int.tryParse(a) ?? -2;}

    return b;
  }
}