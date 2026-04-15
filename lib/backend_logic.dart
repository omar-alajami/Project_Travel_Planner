import 'custExceptions.dart';

class Trip{
  //datafields below
  late Destination dest;
  late int numberOfPeople;
  late int duration;
  late int budget;

  //constructor. It throws an exception if you pass a string (name of destination) that does not exist in "destinations".
  Trip(String name, int numberOfPeople, int duration, int budget){
    if (!(Destination.contains(name))) throw INV_DEST('Invalid destination. Either the destination does not exist in our database (there is no database) or the destination is written wrong.');
    if (numberOfPeople <= 0) throw INV_NBPPL('Number of people must be greater than 0');
    if (duration <= 0) throw INV_DUR('Duration must be greater than 0 days');
    if (budget < 0 && budget != -1) throw INV_BUDG('Budget cannot be negative');

    this.dest = Destination.getDestination(name);
    this.numberOfPeople = numberOfPeople;
    this.duration = duration;
    this.budget = budget;
  }

  int calculateMinimumCost(){
    return ((dest.ticketPriceMin)*(numberOfPeople)) + (dest.accomodationCostPerPersonPerDayMin*duration*numberOfPeople) + (dest.dailyExpensesMin*duration);
  }

  int calculateLevel1(){
    return ((dest.ticketPriceMin)*(numberOfPeople)) + (dest.accomodationCostPerPersonPerDayAvg*duration*numberOfPeople) + (dest.dailyExpensesMin*duration);
  }

  int calculateLevel2(){
    return ((dest.ticketPriceMin)*(numberOfPeople)) + (dest.accomodationCostPerPersonPerDayAvg*duration*numberOfPeople) + (dest.dailyExpensesMin*duration) + (dest.getLocCost()*numberOfPeople);
  }

  int calculateLevel3(){
    return ((dest.ticketPriceHigh)*(numberOfPeople)) + (dest.accomodationCostPerPersonPerDayAvg*duration*numberOfPeople) + (dest.dailyExpensesMin*duration) + (dest.getLocCost()*numberOfPeople);
  }


  /*
  below is the method to compare cost of trip to budget, then return "budget insufficient for trip", or 
  "your budget is just enough for the trip", or "you can enjoy your trip staying at a 
  good hotel, and sightsee".
  make it so if budget is 0, return the minimum required, if -1, return max package.
  */
  String availability(){
    String none = 'Unfortunately, your budget of ${this.budget}USD is not enough for a trip to ${dest.name.toLowerCase()}.';
    String one = 'The minimum budget for this trip to ${dest.name.toLowerCase()} is ${calculateMinimumCost()}USD.The cheapest plane tickets would cost you ${dest.ticketPriceMin}USD each, so ${dest.ticketPriceMin*numberOfPeople}USD in total; you can expect to spend about ${dest.accomodationCostPerPersonPerDayMin*numberOfPeople*duration}USD on stay and food if you stay at a cheap hotel and do not dine in fancy restaurants; and an extra ${dest.dailyExpensesMin}USD each day on various needs like transport and small purchases';
    String two = 'Your budget of ${this.budget}USD for a trip to ${dest.name.toLowerCase()} is just enough to cover the minimum costs.The cheapest plane tickets would cost you ${dest.ticketPriceMin}USD each, so ${dest.ticketPriceMin*numberOfPeople}USD in total; you can expect to spend about ${dest.accomodationCostPerPersonPerDayMin*numberOfPeople*duration}USD on stay and food if you stay at a cheap hotel and do not dine in fancy restaurants; and an extra ${dest.dailyExpensesMin}USD each day on various needs like transport and small purchases';
    String three = 'Your budget of ${this.budget}USD for a trip to ${dest.name.toLowerCase()} is enough to allow you to stay at a good hotel and dine in a fancy restaurant (costing you about ${dest.accomodationCostPerPersonPerDayAvg*numberOfPeople}USD per day), but you would still need to travel economy class (${dest.ticketPriceMin}USD per ticket), and cannot experience the countries landmarks';
    String four = 'Your budget of ${this.budget}USD for a trip to ${dest.name.toLowerCase()} is enough to allow you to stay at a good hotel and dine in a fancy restaurant (costing you about ${dest.accomodationCostPerPersonPerDayAvg*numberOfPeople}USD per day), and you can experience the countries landmarks like ${dest.getLocString()} costing you about ${dest.getLocCost()*numberOfPeople}USD, but you would still need to take a cheap flight (cheapest flights cost ${dest.ticketPriceMin})';
    String five = 'Your budget of ${this.budget}USD for a trip to ${dest.name.toLowerCase()} is more than enough to allow you to stay at a good hotel, dine in a fancy restaurant, and experience the countries landmarks like ${dest.getLocString()}.';
    String six = 'To get the maximum out of a trip to ${dest.name.toLowerCase()} you would need about ${calculateLevel3()}USD, this will allow you to get the best airplane tickets, dine in a fancy restaurant, and experience the countries landmarks like ${dest.getLocString()}.';

    String add = "\n\nThe country's official currency is ${dest.currency} at an exchange rate of ${dest.exchRate}${dest.currency}:1USD. So 100USD would get you ${100*dest.exchRate}${dest.currency}";

    if (budget == 0) {
      return one + add;
    } else if (budget == -1){
      return six + add;
    } else if (budget < calculateMinimumCost()){
      return none;
    } else if (budget < calculateLevel1()){
      return two + add;
    } else if (budget < calculateLevel2()){
      return three + add;
    } else if (budget < calculateLevel3()){
      return four + add;
    } else {return five + add;}
  }
    
}

class Destination{
    String name;
    int ticketPriceMin;
    int ticketPriceHigh;
    int accomodationCostPerPersonPerDayMin;
    int accomodationCostPerPersonPerDayAvg;
    String currency;
    double exchRate; //to US Dollar. One unit of 'exchRate' is equivalent to 1USD.
    int dailyExpensesMin;
    //locations belows. As in eiffel tower for 'france' and bs. maybe we won't use them, but just putting them in case we need them.
    Map<String, int>? locations;//String is the name of loc, int is price to get that loc. (entry fee (if any) + cost to get there + other idk) 

    //For lamita
    //if you have the time, you can add a Map<String, int> here which is "hotels" or "restaurants" or whatever you want, then in the "availability()" function, add a new String which says: "hotels in [country]: [list them] [add cost to each per night]", you can also add "you can afford to say here" if you want. To do that, compare the "cost of staying at this hotel per night + food cost" to "accomodationCostPerDayPerPerson[min/avg depending on where you're comparing]", if it's less then add "to stay here you would need to go over the budget", else add "you can stay here".


    //'destinations' is supposed to have all destinations we create. You will never really use the "Destination" constructor alone, but do "addDestination(Destination(params))".
    static List<Destination> destinations = [
      Destination('UAE', 175, 400, 75, 180, 'AED', 3.67, 30, {'Burj Khalifa':60}),
      Destination('TURKEY', 190, 420, 45, 120, 'TRY', 31, 15, {'The Hagia Sophia':30}),
      Destination('FRANCE', 300, 700, 65, 130, 'EUR', 0.9, 20, {'The Eiffel Tower':25}),
      Destination('GERMANY', 320, 750, 110, 200, 'EUR', 0.9, 40, {'The Neuschwanstein Castle':40}),
      Destination('EGYPT', 160, 380, 40, 90, 'EGP', 50, 10, {'The Pyramids of Giza':25}),
      Destination('ITALY', 290, 550, 65, 160, 'EUR', 0.9, 35, {'The Colosseum':50}),
    ];

    //constructor. There is no checking for any datafield, you can input whatever. We can later define currencies and only allow these currencies, make ticketPrice always positive, other bs.
    Destination(this.name, this.ticketPriceMin, this.ticketPriceHigh, this.accomodationCostPerPersonPerDayMin, this.accomodationCostPerPersonPerDayAvg, this.currency, this.exchRate, this.dailyExpensesMin, [this.locations]);
    
    String getLocString(){
      String a = 'NO_LOCATIONS';
      locations?.forEach((key, value){
        a = key;
      });
      return a;
    }

    int getLocCost(){
      int a = 0;
      locations?.forEach((key, value){
        a = value;
      });
      return a;
    }

    //in case we want to add destinations from the app (future development; have a page where you add destination (in that case add ways to modify existing destination))
    static void addDestination(Destination a){
        destinations.add(a);
        //I just noticed that this method is kinda pointless, as we can add to "destinations" directly without needing this method.
        //but I'll keep it, because it makes syntax better. Instead of doing "Destination.destinations.add(Destination())", we do "Destination.addDestination(Destination())"
        //Additionally, we will not be adding any new destinations in this app, because we would need an extra page, and the project is supposed to be a single page program
        //so we won't be adding to 'destinations' at all.
    }

    static bool contains(String a){
      a = a.toUpperCase();
        for (int i = 0; i < destinations.length; i++){
            if (destinations[i].name.toUpperCase() == a) return true;
        }
        return false;
    }

    static Destination getDestination(String a){
      a = a.toUpperCase();
      for (int i = 0; i < destinations.length; i++){
        if (destinations[i].name.toUpperCase() == a) return destinations[i];
      }
      return destinations[0];
      /* 
      considering we will never call the method "getDestination" except in the constructor, after making sure 'destinations' contains the string a,
      we will ALWAYS return a destination inside the for-loop. So we will never reach "return destinations[0]" after the for-loop, but we need to 
      return a destination or dart says "error: method may not return a Destination".
      */
    }
}