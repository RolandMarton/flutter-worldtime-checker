import 'package:http/http.dart';
import 'dart:convert';

class WorldTime {

  late String location; // location name for the UI
  late String time; // the time in that location
  late String flag; // url to an asset flag icon
  late String url; // location url for api endpoint

  WorldTime({ required this.location, required this.flag, required this.url });

  Future<void> getTime() async {

    // make the request
    Response response = await get(Uri.parse('http://worldtimeapi.org/api/timezone/$url'));
    Map data = jsonDecode(response.body);

    // get properties from data
    String datetime = data['datetime'];
    String offset = data['utc_offset'].substring(1,3);

    // create a DateTime object
    DateTime now = DateTime.parse(datetime);
    now = now.add(Duration(hours: int.parse(offset)));

    // set the time property
    time = now.toString();
  }
  
}