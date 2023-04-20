import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(WeatherApp());

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  String _city = '';
  String _temperature = '';
  String _description = '';
  bool _isLoading = false;

  Future<void> _getWeatherData() async {
    setState(() {
      _isLoading = true;
    });

    final apiKey = '74a6cd55003de1db533ef52a0e1870ea';
    final apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=$_city&appid=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final mainData = jsonBody['main'];
      final weatherData = jsonBody['weather'][0];

      setState(() {
        _temperature = (mainData['temp'] - 273.15).toStringAsFixed(2) + '°C';
        _description = weatherData['description'];
      });
    } else {
      setState(() {
        _temperature = 'Горд не найден';
        _description = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      home: Scaffold(
        appBar: AppBar(title: Text('Weather App')),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    _city = value;
                  });
                },
                decoration:
                    InputDecoration(labelText: 'Введите название города'),
              ),
              ElevatedButton(
                onPressed: _isLoading ? null : _getWeatherData,
                child: Text('Узнать погоду'),
              ),
              SizedBox(height: 16.0),
              if (_isLoading)
                CircularProgressIndicator()
              else
                Column(
                  children: [
                    Text('Температура: $_temperature'),
                    Text('Описание: $_description'),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
