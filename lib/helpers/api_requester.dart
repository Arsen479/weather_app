import 'package:http/http.dart' as http;

class ApiRequester {
  static String api = 'https://api.openweathermap.org/data/2.5/weather';
  static String apiKey = 'b334dc314183e55bf128bb59a333cec0';

  getResponse(String city) async {
    //Uri url = Uri(scheme: api, queryParameters: {'q': city, 'appid': apiKey});
    Uri url = Uri.parse('$api?q=$city&appid=$apiKey');
    return await http.get(url);
  }
}
