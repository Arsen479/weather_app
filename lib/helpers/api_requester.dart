import 'package:http/http.dart' as http;

class ApiRequester {
  static String api = 'https://api.openweathermap.org/data/2.5/weather';
  static String apiHourly = 'https://api.openweathermap.org/data/2.5/forecast';
  static String apiKey = 'b334dc314183e55bf128bb59a333cec0';
  static String apiKeyHourly = 'b9492f011176869c0b9b21dbfd3dde9a';

  getResponse(String city) async {
    //Uri url = Uri(scheme: api, queryParameters: {'q': city, 'appid': apiKey});
    Uri url = Uri.parse('$api?q=$city&appid=$apiKey&units=metric');
    return await http.get(url);
  }

  getHourlyResponse(String city) async {
    Uri url2 = Uri.parse('$apiHourly?q=$city&appid=$apiKeyHourly&units=metric');
    return await http.get(url2);
  }

  String urll2 = 'api.openweathermap.org';

  getResponse2(String path, Map<String, dynamic>? queryParameters) async {
    Uri uri = Uri.https(urll2,'/data/2.5'+ path, queryParameters);
    return await http.get(uri);
  }
}
