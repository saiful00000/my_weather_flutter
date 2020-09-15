import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_weather/colors/background_gradients.dart';
import 'package:my_weather/data/weather_api_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<HomePage> {
  var gradient = BackgroundGradientColors();

  final String appKey = 'df7f38f0d174720b53e452fca216e5db';

  Map<String, dynamic> fiveDayForecastMap = new Map();
  List<String> mapKeys;
  int mapKeyLength = 0;

  Map<String, dynamic> coord;

  //Map<String, dynamic> weather;
  var weather;
  String base;
  Map<String, dynamic> main;
  var visibility;
  Map<String, dynamic> wind;
  Map<String, dynamic> clouds;
  Map<String, dynamic> sys;
  var timezone;
  String cityName = "Dhaka";
  var date;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      /*body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              gradient.gOne,
              gradient.gTwo,
              gradient.gThree,
              gradient.gFour,
              gradient.gFour
            ]
          )
        ),
      ),*/
      body: _BuildBody(context),
    );
  }

  FutureBuilder<Response> _BuildBody(BuildContext context) {
    /*return FutureBuilder<Response>(
      future: Provider.of<WeatherApiService>(context)
          .getWeatherInfo('Dhaka', 'df7f38f0d174720b53e452fca216e5db'),
      builder: (context, shoot) {
        if (shoot.connectionState == ConnectionState.done) {
          Map<String, dynamic> map = jsonDecode(shoot.data.bodyString);
          print('forecast responded');
          if (map != null) print(map);
          return Container(
            child: Text('success'),
          );
        } else {
          print('forecast not responded');
          return Container(
            child: Text('failed'),
          );
        }
      },
    );*/

    _getForecastData(context);

    return FutureBuilder<Response>(
      future: Provider.of<WeatherApiService>(context)
          .getWeatherInfo(cityName, appKey),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          //print('response success');
          Map<String, dynamic> map = jsonDecode(snapshot.data.bodyString);
          if (map != null) {
            coord = map['coord'];
            weather = map['weather'];
            main = map['main'];
            visibility = map['visibility'];
            wind = map['wind'];
            clouds = map['clouds'];
            date = map['dt'];
            sys = map['sys'];
            cityName = map['name'];
          }
          return _bindHomePageData(context);
        } else {
          //print('response not success');
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Container _bindHomePageData(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.cover)),
      child: new BackdropFilter(
          filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: new Container(
              decoration:
                  new BoxDecoration(color: Colors.white.withOpacity(0.0)),
              child: ListView(
                padding: EdgeInsets.fromLTRB(10, 50, 10, 10),
                children: <Widget>[
                  Container(
                    child: Text(
                      cityName,
                      style: GoogleFonts.lato(
                          color: Colors.white70,
                          fontSize: 30,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Text(
                      _getCurrentDateTime('date'),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 40, top: 5),
                    child: Text(
                      _getCurrentDateTime('time'),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        height: 60,
                        width: 60,
                        child: Image.network(_getImageUrl(weather[0]['icon'])),
                      ),
                      Container(
                        child: Text(
                          weather[0]['main'],
                          style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'Max : ${(main['temp_max'] - 273.15).toString() + ' \u00B0'}',
                        style: TextStyle(color: Colors.white),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Text(
                          'Min : ${(main['temp_min'] - 273.15).toString() + ' \u00B0'}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 40),
                    child: Text(
                      (main['temp'] - 273.15).toString() + ' \u00B0',
                      style: GoogleFonts.lato(
                          fontSize: 80,
                          color: Colors.white,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                    child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: new BoxDecoration(
                            color: Colors.black26.withOpacity(0.1)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                'Forecast',
                                style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Divider(
                              height: 20,
                              thickness: 2,
                              color: Colors.white,
                            ),
                            Container(child: _bindForeCastData(context, 0)),
                            Container(child: _bindForeCastData(context, 1)),
                            Container(child: _bindForeCastData(context, 2)),
                            Container(child: _bindForeCastData(context, 3)),
                            Container(child: _bindForeCastData(context, 4)),
                          ],
                        )),
                  ),
                ],
              ))),
    );
  }

  String string = 'shaiful';

  dynamic _bindForeCastData(BuildContext context, int index) {
    if (mapKeys != null) {
      print('map keys length: ' + mapKeys.length.toString());
    }
    if (mapKeyLength > index) {
      var weather = fiveDayForecastMap[mapKeys[index]];
      return Row(
        children: [
          Expanded(flex: 5, child: Container(
            child: Text(
              _getFormatedDate(fiveDayForecastMap[mapKeys[index]]['dt']),
              style: GoogleFonts.lato(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),),
          Expanded(flex: 4, child: Container(
            //margin: EdgeInsets.only(left: 30, right: 30),
            height: 60,
            width: 60,
            child: Image.network(_getImageUrl(fiveDayForecastMap[mapKeys[index]]
            ['weather'][0]['icon']
                .toString())),
          ),),
          Expanded(flex: 2, child: Container(
            //max temparature
            child: Text(
              _getFormatedTemp(fiveDayForecastMap[mapKeys[index]]['main']['temp_max']),
              style: GoogleFonts.lato(color: Colors.white, fontSize: 16),
            ),
          ),),
          Expanded(flex: 2, child: Container(
            //margin: EdgeInsets.only(left: 20),
            //min temparature
            child: Text(
              _getFormatedTemp(fiveDayForecastMap[mapKeys[index]]['main']['temp_min']),
              style: GoogleFonts.lato(color: Colors.white, fontSize: 16),
            ),
          ),),

        ],
      );
    } else {
      //_getForecastData(context);
      return Text(
        string,
        style: TextStyle(color: Colors.white),
      );
    }
  }

  void _getForecastData(BuildContext context) async {
    print('getForecast Method called');
    final response = await Provider.of<WeatherApiService>(context)
        .getForecast('23.7104', '90.4074', appKey);

    if (response.isSuccessful) {
      print('forecast response success');

      var forecastResponse = response.body;
      var forecastList = forecastResponse['list'];

      for (var forecast in forecastList) {
        String month = _getFormatedDate(forecast['dt']);
        fiveDayForecastMap[month] = forecast;
        //log(month);
      }

      mapKeys = new List();
      for (var key in fiveDayForecastMap.keys) {
        mapKeys.add(key);
      }
      mapKeyLength = mapKeys.length;
      //string = 'shaiful islam';

      log('map keys' + mapKeys.toString());

      //build(context);
      //setState();

    } else {
      print('forecast response failed');
    }
  }

  String _getImageUrl(String icon) {
    return 'http://openweathermap.org/img/wn/${icon}@2x.png';
  }

  String _getFormatedDate(var date) {
    var result = DateTime.fromMillisecondsSinceEpoch(date * 1000);
    var div = result.toString().split(' ');
    var dateDiv = div[0].toString().split('-');
    String month = dateDiv[1];
    if (month.length == 2 && month[0] == '0') {
      month = month[1];
    }
    return _getMonthNameFromNumber(month) +
        ' ' +
        dateDiv[2] +
        ', ' +
        dateDiv[0];
  }

  String _getCurrentDateTime(String type) {
    var now = DateTime.now();
    var date = DateFormat('yMd').format(now);
    var part = date.toString().split('/');
    String result =
        _getMonthNameFromNumber(part[0]) + ' ' + part[1] + ', ' + part[2];
    var time = DateFormat('jm').format(now);

    if (type == 'time')
      return time;
    else
      return result;
  }

  String _getMonthNameFromNumber(String number) {
    var names = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return names[int.parse(number)];
  }

  String _getFormatedTemp(double temp){
    temp = (temp - 273.15);
    String result = temp.toStringAsFixed(1);
    return result + ' \u00B0';
  }
} // end of class
