import 'package:flutter/material.dart';
import 'backend_logic.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static const Color appbarBackgroundColor = Color.fromARGB(255, 70, 20, 140);
  static const Color scaffoldBackgroundColor = Color.fromARGB(255, 215, 190, 245);
  static const Color appbarForegroundColor = Color.fromARGB(255, 140, 205, 245);
  static const Color textColor = Color.fromARGB(255, 30, 25, 35);

  @override
  Widget build(BuildContext context) {
    final ScreenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Century Gothic',
        appBarTheme: AppBarTheme(
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
          titleLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          )
        ),

        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(appbarBackgroundColor),
            foregroundColor: WidgetStateProperty.all(appbarForegroundColor),
            padding: WidgetStateProperty.all(EdgeInsets.symmetric(vertical: 12, horizontal: 20)),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            textStyle: WidgetStateProperty.all(TextStyle(fontSize: 16)),
            fixedSize: WidgetStateProperty.all(Size(ScreenWidth*0.5, (ScreenWidth*0.5)/5)),//FIX THIS: These values were given at random, check and give the correct values.
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
    if (dest == '') {return submitTrip();}
    else {return result();}
  }

  Widget submitTrip(){
    final double space = 12;
    final ScreenWidth = MediaQuery.of(context).size.width;
    final widthFactor = 0.9;
    return Center(
      child: ListView (
        padding: EdgeInsets.fromLTRB(16, 12, 16, 12),

        children: [
          Padding(
            padding: EdgeInsets.only(bottom: space),
            child: Text(
              'Welcome to our "Travel Planner" app!\nPlease fill out the fields below then click "submit".\nThe unit for "Duration" is Days, and the unit for "Budget" is USD.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),

          Padding(
            padding: EdgeInsets.only(bottom: space),//I have no idea what the spaces are like, we can test the app and tweak the numbers and see which give the best look
            child: Center(
              child: SizedBox(
                width: ScreenWidth*widthFactor,
                child: TextField(
                  decoration: InputDecoration(labelText: 'Destination'),
                  onChanged: (gotDest){dest = gotDest;},
                  style: Theme.of(context).textTheme.bodySmall,
                )
              )
            )
          ),

          Padding(
            padding: EdgeInsets.only(bottom: space),//I have no idea what the spaces are like, we can test the app and tweak the numbers and see which give the best look
            child: Center(
              child: SizedBox(
                width: ScreenWidth*widthFactor,
                child: TextField(
                  keyboardType: TextInputType.numberWithOptions(),
                  decoration: InputDecoration(labelText: 'Number of People'),
                  onChanged: (gotNb){nbOfPeople = int.tryParse(gotNb) ?? 0;},
                  style: Theme.of(context).textTheme.bodySmall,
                )
              )
            )
          ),

          Padding(
            padding: EdgeInsets.only(bottom: space),//I have no idea what the spaces are like, we can test the app and tweak the numbers and see which give the best look
            child: Center(
              child: SizedBox(
                width: ScreenWidth * widthFactor,
                child: TextField(
                  keyboardType: TextInputType.numberWithOptions(),
                  decoration: InputDecoration(labelText: 'Duration'),
                  onChanged: (gotDur){duration = int.tryParse(gotDur) ?? 0;},
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              )
            )
          ),

          Padding(
            padding: EdgeInsets.only(bottom: space),//I have no idea what the spaces are like, we can test the app and tweak the numbers and see which give the best look
            child: Center(
              child: SizedBox(
                width: ScreenWidth*widthFactor,
                child: TextField(
                  keyboardType: TextInputType.numberWithOptions(),
                  decoration: InputDecoration(labelText: 'Buget (0 for minimum or 00 to disregard)'),
                  onChanged: (gotBud){budget = parseBud(gotBud);},
                  style: Theme.of(context).textTheme.bodySmall,
                )
              ),
            )
          ),

          Center(child: TextButton(onPressed: (){setState((){});}, child: Text('SUBMIT')))
        ]
      ),
    );
  }

  Widget result(){
    String shownString = '';
    final double space = 12;
    bool error = false;
    Trip? trip;
    late Widget image1;
    List<String>? images;


    try {
      trip = Trip(dest, nbOfPeople, duration, budget);
      shownString = trip.availability();
    } catch (E){
      shownString = '$E';
      error = true;
    }


    if (error) {image1 = Image.asset('assets/images/error.png', fit: BoxFit.fitWidth);}
    else {images = trip!.dest.getImages(); image1 = Image.asset(images[0], fit: BoxFit.fitWidth);}

    return Center(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: space*1.5),
                  child: image1,
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: space),
                  child: Text(shownString, style: Theme.of(context).textTheme.bodySmall)
                ),

                if (!error) ...[
                  Padding(
                    padding: EdgeInsets.only(bottom: space*1.3, top:space),
                    child: Text('${trip!.dest.name.toUpperCase()}:', style: Theme.of(context).textTheme.bodyLarge,)
                  ),

                  Padding(
                    padding: EdgeInsets.only(bottom: space*0.5),
                    child: Image.asset(images![1], fit: BoxFit.fitWidth)
                  ),

                  Padding(
                    padding: EdgeInsets.only(bottom: space*0.5),
                    child: Image.asset(images![2], fit: BoxFit.fitWidth)
                  ),

                  Padding(
                    padding: EdgeInsets.only(bottom: space*0.5),
                    child: Image.asset(images![3], fit: BoxFit.fitWidth)
                  )
                ]
              ],
            )
          ),
          TextButton(onPressed: (){setState((){dest = ''; nbOfPeople = 0; duration = 0; budget = -2;});}, child: Text('CLOSE'))
        ]
      )
    );
  }
  
  

  int parseBud(String a){
    a = a.trim();
    if (a == '0') {return 0;}
    else if (a == '00') {return -1;}
    return int.tryParse(a) ?? -2;
  }
}