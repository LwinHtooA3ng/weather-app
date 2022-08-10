import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../model/weather_model.dart';

String apiKey = "5b5417e6c7659fa43f3f273715ad06c6";

class API {
  getLocationAndWeather() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      // print(permission);
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      // print(position);
      var latitube = position.latitude;
      var longitube = position.longitude;
      var uri = Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?lat=$latitube&lon=$longitube&appid=$apiKey&units=metric");
      var res = await http.get(uri);

      if (res.statusCode == 200) {
        // var weatherData = jsonDecode(res.body);
        // return weatherData;
        var weatherData = OverallResponse.fromRawJson(res.body);
        return weatherData;
      } else {
        throw Exception("Failed to get weather data.");
      }
    } catch (e) {
      throw Exception("Failed to get location.");
    }
  }

  getWeatherWithCityName(String cityName) async {
    var uri = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric");
    var res = await http.get(uri);

    print("API C${res.statusCode}");

    // return(res.statusCode);

    // var weatherData = jsonDecode(res.body);
    // return weatherData;

    //     var weatherData = OverallResponse.fromRawJson(res.body);
    // return weatherData;

    if (res.statusCode == 200) {
      // print("API Res body${res.body}");
      var weatherData = OverallResponse.fromRawJson(res.body);
      print(weatherData);
      return weatherData;
    } else if (res.statusCode == 404) {
      return 404;
    } else {
      throw Exception(">>>Failed to get weather data.");
    }
  }
}
