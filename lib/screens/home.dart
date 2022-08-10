import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weather/api/weather_api.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_glow/flutter_glow.dart';

const flutterColor = Color(0xFF40D0FD);

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var weatherData;
  String weatherImage = "";

  TextEditingController city = TextEditingController();

  // https://api.openweathermap.org/data/2.5/weather?lat=22.908721&lon=96.42358&appid=5b5417e6c7659fa43f3f273715ad06c6

  getWeather() async {
    var res = await API().getLocationAndWeather();
    setState(() {
      weatherData = res;
    });
    var data = res.weather[0].id;
    if (data >= 200 && data < 300) {
      weatherImage = "thunderstorm.png";
    } else if (data >= 300 && data < 500) {
      weatherImage = "drizzle.png";
    } else if (data >= 500 && data < 700) {
      weatherImage = "rain.png";
    } else if (data > 800 && data < 900) {
      weatherImage = "cloud.png";
    } else {
      weatherImage = "sun.png";
    }
  }

  getWeatherWithCityName(String cityName) async {
    var res = await API().getWeatherWithCityName(cityName);

    print("Home>>>>$res");
    if (res == 404) {
      const snackBar = SnackBar(
        content: Text('City not found'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      setState(() {
        weatherData = res;
      });

      var data = res.weather[0].id;
      if (data >= 200 && data < 300) {
        weatherImage = "thunderstorm.png";
      } else if (data >= 300 && data < 500) {
        weatherImage = "drizzle.png";
      } else if (data >= 500 && data < 700) {
        weatherImage = "rain.png";
      } else if (data > 800 && data < 900) {
        weatherImage = "cloud.png";
      } else {
        weatherImage = "sun.png";
      }
    }
  }

  // getWeatherWithCityName(String cityName) async {
  //   var res = await API().getWeatherWithCityName(cityName);
  //   // print(res.statusCode);

  //   if (res.statusCode == 200) {
  //     // print("ok");
  //     setState(() {
  //       weatherData = OverallResponse.fromRawJson(res.body);
  //     });

  //   } else if (res.statusCode == 404) {
  //     print("no");
  //   }
  //   // if (res == 404) {
  //   //   print("City not found.");
  //   // }

  //   // setState(() {
  //   //   weatherData = res;
  //   // });

  //   // var data = res.weather[0].id;
  //   // if (data >= 200 && data < 300) {
  //   //   weatherImage = "thunderstorm.png";
  //   // } else if (data >= 300 && data < 500) {
  //   //   weatherImage = "drizzle.png";
  //   // } else if (data >= 500 && data < 700) {
  //   //   weatherImage = "rain.png";
  //   // } else if (data > 800 && data < 900) {
  //   //   weatherImage = "cloud.png";
  //   // } else {
  //   //   weatherImage = "sun.png";
  //   // }
  // }

  @override
  void initState() {
    getWeather();
    // getWeatherWithCityName("ok");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: (weatherData == null)
            ? const Center(
                child: SpinKitPulse(
                color: Colors.white,
                size: 50.0,
              ))
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextField(
                        controller: city,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          hintText: "City Name",
                          hintStyle: const TextStyle(fontSize: 13),
                          contentPadding: const EdgeInsets.all(10),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search_rounded),
                            color: Colors.white,
                            onPressed: () {
                              (city.text.isEmpty)
                                  ? print("empty")
                                  : getWeatherWithCityName(city.text);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // const Icon(
                          //   Icons.location_on,
                          //   size: 23,
                          // ),
                          // const SizedBox(
                          //   width: 2,
                          // ),
                          Text(
                            weatherData.name,
                            style: GoogleFonts.ubuntu(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          // Text(DateTime.now()
                          //     .add(Duration(
                          //         seconds: weatherData.timezone -
                          //             DateTime.now().timeZoneOffset.inSeconds))
                          //     .toString()
                          //     .split(" ")[0]),
                          Text(weatherData.sys.country),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Image(
                        image: AssetImage("images/$weatherImage"),
                        width: 220,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(weatherData.weather[0].description,
                          style: GoogleFonts.ubuntu(
                              fontSize: 15,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w100)),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                          "${weatherData.main.temp.toString().split(".")[0]}°C",
                          style: TextStyle(
                            color: Colors.grey[100],
                            fontWeight: FontWeight.bold,
                            fontSize: 50,
                          )),

                      // Text(DateTime.now()
                      //     .add(Duration(
                      //         seconds: weatherData.timezone -
                      //             DateTime.now().timeZoneOffset.inSeconds))
                      //     .toString()
                      //     .split(" ")[0]),
                      // Image.network(
                      //     "http://openweathermap.org/img/w/${weatherData.weather[0].icon}.png")
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
