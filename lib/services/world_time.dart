import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:retry/retry.dart';

class WorldTime {
  late String location; // location name for the UI
  late String time; // the time in that location
  late String flag; // url to an asset flag icon
  late String url; // location url for api endpoint
  late bool isDaytime;

  WorldTime({required this.location, required this.flag, required this.url});

  Future<void> getTime() async {
    final client = Client();
    request() => client.get(Uri.parse('http://worldtimeapi.org/api/timezone/$url'));

    final response = await retry(
      request,
      maxAttempts: 5,
      retryIf: (e) => e is Exception,
      delayFactor: const Duration(seconds: 2),
    );

    if (response == null) {
      time = 'Could not get time data';
      return;
    }

    // get properties from data
    Map data = jsonDecode(response.body);
    String datetime = data['datetime'];
    String offset = data['utc_offset'].substring(1, 3);

    // create a DateTime object
    DateTime now = DateTime.parse(datetime);
    now = now.add(Duration(hours: int.parse(offset)));

    // set the time property
    isDaytime = now.hour > 6 && now.hour < 20;
    time = DateFormat.jm().format(now);

    client.close();
  }
}