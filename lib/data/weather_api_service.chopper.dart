// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

class _$WeatherApiService extends WeatherApiService {
  _$WeatherApiService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  final definitionType = WeatherApiService;

  Future<Response> getWeatherInfo(String cityname, String apikey) {
    final $url = '/weather?q=${cityname}&appid=${apikey}';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getForecast(String lat, String lon, String apikey) {
    final $url = '/forecast';
    final Map<String, dynamic> $params = {
      'lat': lat,
      'lon': lon,
      'apikey': apikey
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }
}
