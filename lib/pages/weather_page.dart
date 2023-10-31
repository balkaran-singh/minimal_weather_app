import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:min_weather_app/models/weather_model.dart';
import 'package:min_weather_app/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //api key
  final _weatherService = WeatherService('1ada57768fe82980f61802fe85e97032');
  Weather? _weather;

  //fetching weather
  _fetchWeather() async {
    //for getting current city
    String cityName = await _weatherService.getCurrentCity();

    //get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }

    //for errors
    catch (e) {
      print(e);
    }
  }

  //weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      //looked into the openweather to get the keywords
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunder':
        return 'assets/thunder.json';
      case 'cear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  //init state
  @override
  void initState() {
    super.initState();

    //fetch weather on startup
    _fetchWeather();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_pin,
              color: Colors.grey[500],
              size: 55.0,
            ),
          //city name
          Text(_weather?.cityName ?? "loading city...",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),

          //animation
          Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

          SizedBox(height: 10.0,),

          //temperature
          //used interpolation to format it
          Text('${_weather?.temperature.round()}°C',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),

          //weather condition
            Text(_weather?.mainCondition ?? ""),

        ],),
      ),
    );
  }
}
