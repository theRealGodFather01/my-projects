import 'package:flutter/material.dart';

import '../services/location_service.dart';
import '../services/weather_service.dart';

class WeatherCard extends StatefulWidget {
  const WeatherCard({super.key});

  @override
  State<WeatherCard> createState() =>
      _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  final WeatherService _weatherService =
  WeatherService();

  final LocationService _locationService =
  LocationService();

  WeatherData? _weather;

  bool _isLoading = true;

  String? _error;

  @override
  void initState() {
    super.initState();

    _loadWeather();
  }

  Future<void> _loadWeather() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      final position =
      await _locationService.getCurrentLocation();

      final weather =
      await _weatherService.getWeather(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      if (!mounted) return;

      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (error, stackTrace) {
      // Keep the technical error available in the
      // Android Studio debug console.
      debugPrint(
        'WeatherCard error: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      setState(() {
        // Never show the raw technical exception
        // to the user.
        _error =
        'We couldn\'t load the weather right now.\n'
            'Please check your internet connection.';

        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (_error != null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment:
            CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.cloud_off,
                size: 42,
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Weather unavailable',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      _error!,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              IconButton(
                tooltip: 'Try again',
                onPressed:
                _isLoading ? null : _loadWeather,
                icon: const Icon(
                  Icons.refresh,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final weather = _weather!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const Icon(
              Icons.cloud,
              size: 48,
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    weather.city,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    '${weather.temperature.toStringAsFixed(1)}°C',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall,
                  ),

                  Text(
                    weather.condition,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}