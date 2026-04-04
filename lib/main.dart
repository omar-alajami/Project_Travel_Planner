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
  int nbOfPeople = 0;
  int duration = 0;
  int budget = 0;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 100),
            TextField(
              decoration: InputDecoration(labelText: 'Destination'),
              onSubmitted: (gotDest){dest = gotDest;},
            ),

            SizedBox(height: 50),
            TextField(
              keyboardType: TextInputType.numberWithOptions(),
              decoration: InputDecoration(labelText: 'Nb of People'),
              onSubmitted: (gotNb){nbOfPeople = int.tryParse(gotNb) ?? 0;},//make a function that handles if input is different, then call that function passing gotNb as parameter, instead of writing the whole function here.
            ),

            SizedBox(height: 50),
            TextField(
              keyboardType: TextInputType.numberWithOptions(),
              decoration: InputDecoration(labelText: 'Duration'),
              onSubmitted: (gotDur){duration = int.tryParse(gotDur) ?? 0;},
            ),

            SizedBox(height: 50),
            TextField(
              decoration: InputDecoration(labelText: 'Enter buget (min for minimum or keep empty to disregard)'),
              onSubmitted: (gotBud){budget = parseBud(gotBud);},
            ),

            SizedBox(height: 50),
            TextButton(onPressed: (){getOutput();}, child: Text('SUBMIT'))
          ]
        )
      )
    );
  }

  void getOutput(){
    String shownString = '';
    try{
      Trip trip = Trip(dest, nbOfPeople, duration, budget);
      setState((){
        shownString = trip.availability();
      });
    } catch(E){
      setState((){
        shownString = 'ERROR\n$E';
      });
    }

    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text('OUTPUT'),
          content: Text(shownString),
        );
      }
    );
  }
  

  int parseBud(String a){
    late int b;
    if (a == 'min'){b = 0;}
    else if (a == '' || a == 'backdoor') {b = -1;}
    else {b = int.tryParse(a) ?? -2;}

    return b;
  }
}