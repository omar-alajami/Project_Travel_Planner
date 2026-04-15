import 'package:flutter/material.dart';
import 'backend_logic.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static const Color appbarBackgroundColor = Color.fromARGB(255, 70, 20, 140);
  static const Color scaffoldBackgroundColor = Color.fromARGB(255, 215, 190, 245);
  static const Color appbarForegroundColor = Color.fromARGB(255, 120, 200, 250);
  static const Color textColor = Color.fromARGB(255, 30, 25, 35);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Century Gothic',
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Century Gothic',
            color: const Color.fromARGB(255, 190, 228, 252),
          ),
          backgroundColor: appbarBackgroundColor,
          foregroundColor: appbarForegroundColor,
          centerTitle: true,
        ),
        scaffoldBackgroundColor: scaffoldBackgroundColor,

        textTheme: TextTheme(
          bodyLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
          bodySmall: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: textColor, 
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(appbarBackgroundColor),
            foregroundColor: WidgetStateProperty.all(appbarForegroundColor),
            padding: WidgetStateProperty.all(EdgeInsets.symmetric(vertical: 12, horizontal: 20)),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            textStyle: WidgetStateProperty.all(TextStyle(fontSize: 16))
          )
        )
      ),
      title: 'Planner_App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Travel Planner'),
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
  int budget = -2;

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
            padding: EdgeInsets.only(top: 8, bottom: 12),//I have no idea what the spaces are like, we can test the app and tweak the numbers and see which give the best look
            child: TextField(
              decoration: InputDecoration(labelText: 'Destination'),
              onChanged: (gotDest){dest = gotDest;},
              style: Theme.of(context).textTheme.bodySmall,
            )
          ),

          Padding(
            padding: EdgeInsets.only(bottom: 12),//I have no idea what the spaces are like, we can test the app and tweak the numbers and see which give the best look
            child: TextField(
              keyboardType: TextInputType.numberWithOptions(),
              decoration: InputDecoration(labelText: 'Number of People'),
              onChanged: (gotNb){nbOfPeople = int.tryParse(gotNb) ?? 0;},
              style: Theme.of(context).textTheme.bodySmall,
            )
          ),

          Padding(
            padding: EdgeInsets.only(bottom: 12),//I have no idea what the spaces are like, we can test the app and tweak the numbers and see which give the best look
            child: TextField(
              keyboardType: TextInputType.numberWithOptions(),
              decoration: InputDecoration(labelText: 'Duration'),
              onChanged: (gotDur){duration = int.tryParse(gotDur) ?? 0;},
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),

          Padding(
            padding: EdgeInsets.only(bottom: 12),//I have no idea what the spaces are like, we can test the app and tweak the numbers and see which give the best look
            child: TextField(
              keyboardType: TextInputType.numberWithOptions(),
              decoration: InputDecoration(labelText: 'Enter buget (0 for minimum or 1 to disregard)'),
              onChanged: (gotBud){budget = parseBud(gotBud);},
              style: Theme.of(context).textTheme.bodySmall,
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
                  padding: EdgeInsets.only(top:8, bottom: 8),
                  child: Text('IMG_HERE'),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child:Text(shownString, style: Theme.of(context).textTheme.bodySmall)
                ),
              ],
            )
          ),
          TextButton(onPressed: (){setState((){dest = ''; nbOfPeople = 0; duration = 0; budget = -2;});}, child: Text('CLOSE'))
        ]
      )
    );
  }
  

  int parseBud(String a){
    int b = int.tryParse(a) ?? -2;
    if (b == 1) {b = -1;}
    return b;
  }
}