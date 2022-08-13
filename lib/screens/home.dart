import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weather/api/weather_api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glass_kit/glass_kit.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map weatherData = {};
  String weatherImage = "";
  String dayOrNight = "";
  bool searchButton = false;

  TextEditingController city = TextEditingController();

  // https://api.openweathermap.org/data/2.5/weather?lat=22.908721&lon=96.42358&appid=5b5417e6c7659fa43f3f273715ad06c6

  getWeatherWithLocation() async {
    setState(() {
      searchButton = true;
    });

    var res = await API().getWeatherWithCurrentLocation();
    setState(() {
      weatherData = res;
      searchButton = false;
    });
    var icon = res["weather"][0]["icon"].split("")[2];
    if (icon == "d") {
      dayOrNight = "day";
    } else {
      dayOrNight = "night";
    }
    // print(icon);
    var data = res["weather"][0]["id"];
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

  getWeatherWithLocationWithCityName(String cityName) async {
    setState(() {
      searchButton = true;
    });

    var res = await API().getWeatherWithCityName(cityName);

    // print("Home>>>>$res");
    if (res == 404) {
      setState(() {
        searchButton = false;
      });
      var snackBar = SnackBar(
        backgroundColor: Colors.deepOrange,
        duration: const Duration(seconds: 1),
        content: Text(
          'City not found',
          style: GoogleFonts.ubuntu(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      setState(() {
        weatherData = res;
        city.clear();
        searchButton = false;
      });
      var icon = res["weather"][0]["icon"].split("")[2];
      if (icon == "d") {
        dayOrNight = "day";
      } else {
        dayOrNight = "night";
      }
      var data = res["weather"][0]["id"];
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

  @override
  void initState() {
    getWeatherWithLocation();
    // getWeatherWithLocationWithCityName("ok");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[900],
      // backgroundColor: Colors.grey[200],
      backgroundColor:
          (dayOrNight == "day") ? Colors.blueAccent : Colors.grey[900],
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: (weatherData.isEmpty)
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
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: city,
                                // cursorColor: Colors.grey[900],
                                cursorColor: Colors.grey[200],
                                decoration: InputDecoration(
                                  hintText: "City Name",
                                  hintStyle: const TextStyle(fontSize: 13),
                                  contentPadding: const EdgeInsets.all(10),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                    // borderSide: BorderSide(color: Colors.black,),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                    // borderSide: BorderSide(color: Colors.black,),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.search_rounded),
                                    // color: Colors.black,
                                    color: Colors.white,
                                    iconSize: 25,
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      (city.text.isEmpty)
                                          ? null
                                          : getWeatherWithLocationWithCityName(
                                              city.text);
                                    },
                                  ),
                                ),
                                onSubmitted: (String city) {
                                  getWeatherWithLocationWithCityName(city);
                                },
                              ),
                            ),
                            // IconButton(onPressed: (){}, icon: Icon(Icons.location_searching))
                            const SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                              height: 47,
                              child: OutlinedButton(
                                  onPressed: () {
                                    city.clear();
                                    FocusScope.of(context).unfocus();
                                    getWeatherWithLocation();
                                  },
                                  style: OutlinedButton.styleFrom(
                                      primary: Colors.white,
                                      side: const BorderSide(
                                          width: 1, color: Colors.white)),
                                  child: const Icon(
                                    Icons.location_searching,
                                    size: 20,
                                  )),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        (searchButton)
                            ? SpinKitWave(
                                size: 30,
                                color: Colors.grey[200],
                              )
                            : Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.location_on,
                                                  size: 18,
                                                ),
                                                const SizedBox(
                                                  width: 2,
                                                ),
                                                Text(
                                                  weatherData["name"],
                                                  style: GoogleFonts.ubuntu(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(DateTime.now()
                                                .add(Duration(
                                                    seconds: weatherData[
                                                            "timezone"] -
                                                        DateTime.now()
                                                            .timeZoneOffset
                                                            .inSeconds))
                                                .toString()
                                                .split(" ")[0]),
                                          ],
                                        ),
                                        Text(weatherData["sys"]["country"]),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Image(
                                    image: AssetImage(
                                        "images/$dayOrNight/$weatherImage"),
                                    width: 220,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(weatherData["weather"][0]["description"],
                                      style: GoogleFonts.ubuntu(
                                          fontSize: 15,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.w100)),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "${weatherData["main"]["temp"].toString().split(".")[0]}°C",
                                    // style: const TextStyle(
                                    //   // color: Colors.blueAccent,
                                    //   fontWeight: FontWeight.bold,
                                    //   fontSize: 50,
                                    // )),
                                    style: GoogleFonts.ubuntu(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 50,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  // SizedBox(
                                  //   width: 320,
                                  //   height: 150,
                                  //   child: Card(

                                  //   ),
                                  // ),
                                  GlassContainer.clearGlass(
                                    height: 110, width: 300,
                                    borderRadius: BorderRadius.circular(8),
                                    padding: const EdgeInsets.all(15),
                                    borderWidth: 0,
                                    // blur: 1,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.air),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "wind speed",
                                              style: GoogleFonts.ubuntu(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "${weatherData["wind"]["speed"]}",
                                              style: GoogleFonts.ubuntu(),
                                            )
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.water),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "humidity",
                                              style: GoogleFonts.ubuntu(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "${weatherData["main"]["humidity"]}",
                                              style: GoogleFonts.ubuntu(),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                        // Image.network(
                        //     "http://openweathermap.org/img/w/${weatherData.weather[0].icon}.png")
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
