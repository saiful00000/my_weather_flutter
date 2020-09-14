import 'package:chopper/chopper.dart';

part 'weather_api_service.chopper.dart';

@ChopperApi(baseUrl: '')
abstract class WeatherApiService extends ChopperService {

  @Get(path: '/weather?q={cityname}&appid={apikey}')
  Future<Response> getWeatherInfo(
     @Path('cityname') String cityname, @Path('apikey') String apikey);

  @Get(path: '/forecast')
  Future<Response> getForecast(
      @Query('lat') String lat, @Query('lon') String lon, @Query('apikey') String apikey);

  // singleton client
  static WeatherApiService create() {
    final client = ChopperClient(
      baseUrl: 'http://api.openweathermap.org/data/2.5',
      services: [
        _$WeatherApiService()
      ],
      converter: JsonConverter()
    );
    return _$WeatherApiService(client);
  }
}
