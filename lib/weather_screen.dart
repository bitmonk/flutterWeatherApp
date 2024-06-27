import "dart:convert";
import "dart:ui";

import "package:flutter/material.dart";
import "package:weather_app/additional_info_item.dart";
import "package:weather_app/personal.dart";
import "package:weather_app/weather_forecast_item.dart";
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'London';
      final result = await http.get(
        Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherApiKey')
      );

      final data = jsonDecode(result.body);
      if(data['cod'] != '200'){
        throw 'An Unexpected Eror Occured !';
      }

      return data;

    } catch (e){
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()));
          }
        final data = snapshot.data!;
        final currentWeatherData = data['list'][0];

        final currentTemp = currentWeatherData['main']['temp'];
        final currentSky = currentWeatherData['weather'][0]['main'];
        final currentPressure = currentWeatherData['main']['pressure'];
        
        final windSpeed = currentWeatherData['wind']['speed'];
        
        final currentHumidity = currentWeatherData['main']['humidity'];
        
        

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 10,
                          sigmaY: 10,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '$currentTemp K',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Icon(
                              currentSky == 'Clouds' || currentSky == 'Rain' ? Icons.cloud : Icons.sunny,
                                size: 64,
                              ),
                              const SizedBox(height: 16),
                               Text(
                                currentSky,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Weather Forecats',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      HourlyForecastItem(
                        time: '00:45',
                        icon: Icons.cloud,
                        temp: '104',
                      ),
                      HourlyForecastItem(
                        time: '01:45',
                        icon: Icons.sunny,
                        temp: '50',
                      ),
                      HourlyForecastItem(
                        time: '02:45',
                        icon: Icons.sunny,
                        temp: '85',
                      ),
                      HourlyForecastItem(
                        time: '03:45',
                        icon: Icons.foggy,
                        temp: '87',
                      ),
                      HourlyForecastItem(
                        time: '04:45',
                        icon: Icons.cloud,
                        temp: '95',
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Additional Information',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoItem(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: currentHumidity.toString(),
                    ),
                      AdditionalInfoItem(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      value: windSpeed.toString(),
                    ),
                    AdditionalInfoItem(
                      icon: Icons.beach_access,
                      label: 'Pressure',
                      value: currentPressure.toString(),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}