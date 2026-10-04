import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class WeatherData {
  final String city;
  final double temperature;
  final String condition;

  const WeatherData({
    required this.city,
    required this.temperature,
    required this.condition,
  });

  factory WeatherData.fromJson(
      Map<String, dynamic> json,
      ) {
    return WeatherData(
      city: json['city'] as String,
      temperature:
      (json['temperature'] as num).toDouble(),
      condition: json['condition'] as String,
    );
  }
}

class WeatherService {
  // Physical Android phone using ADB reverse.
  static const String baseUrl =
      'http://127.0.0.1:3000';

  Future<WeatherData> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.parse(
      '$baseUrl/api/weather'
          '?latitude=$latitude'
          '&longitude=$longitude',
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode != 200) {
        debugPrint(
          'Weather API error: '
              'HTTP ${response.statusCode}',
        );

        throw Exception(
          'Weather service returned an error.',
        );
      }

      final data =
      jsonDecode(response.body)
      as Map<String, dynamic>;

      return WeatherData.fromJson(data);
    } catch (error, stackTrace) {
      // Keep the technical error in the debug console.
      debugPrint(
        'Weather request failed: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      // Do not expose the technical networking
      // error to the user interface.
      rethrow;
    }
  }
}