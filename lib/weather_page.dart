import 'package:flutter/material.dart';
import 'variable.dart';
import 'weather_info.dart';
import 'city.dart';

class WeatherPage extends StatefulWidget {
  WeatherPage({super.key, required this.locationWeather});

  final locationWeather;

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Weather weather = Weather();
  var temperature;
  var weatherMessage;
  String? weatherIcon;
  var cityName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        cityName = 'No city';
        weatherIcon = 'Error';
        weatherMessage = 'Unable to get weather Data';
      }

      double temp = weatherData['main']['temp'];
      temperature = temp.toInt();
      var condition = weatherData['weather'][0]['id'];
      cityName = weatherData['name'];
      weatherIcon = weather.getWeatherIcon(condition);
      weatherMessage = weather.getMessage(temperature);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('img/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      dynamic weatherData = await weather.getCurrentWeather();

                      updateUI(weatherData);
                    },
                    child: const Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      var result = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return CityScreen();
                          }));

                      if (result != null) {
                        dynamic weatherData =
                        await weather.getCityWeather(cityName: result);

                        updateUI(weatherData);
                      }
                    },
                    child: const Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temperature°',
                      //'32°',
                      style: vTemperatureStyle,
                    ),
                    Text(
                      weatherIcon.toString(),
                      //'☀️',
                      style: TextStyle(fontSize: 100),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  '$weatherMessage in $cityName',
                  textAlign: TextAlign.right,
                  style: vMessageStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
