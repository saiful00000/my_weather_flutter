import 'dart:convert';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_weather/colors/background_gradients.dart';
import 'package:my_weather/data/weather_api_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  var gradient = BackgroundGradientColors();

  final String appKey = 'df7f38f0d174720b53e452fca216e5db';

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
          .getWeatherInfo('Dhaka', appKey),
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
                          ],
                        )),
                  ),
                ],
              ))),
    );
  }



  void _getForecastData(BuildContext context) async {
    print('getForecast Method called');
    final response = await Provider.of<WeatherApiService>(context)
    .getForecast('23.7104', '90.4074' ,appKey);

    if(response.isSuccessful){
      //print('response success');
      print(response.body);
    }else{
      //print('response failed');
    }

  }

  String _getImageUrl(String icon) {
    return 'http://openweathermap.org/img/wn/${icon}@2x.png';
  }

  String _getCurrentDateTime(String type) {
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
    var now = DateTime.now();
    var date = DateFormat('yMd').format(now);
    var part = date.toString().split('/');
    String result = names[int.parse(part[0])] + ' ' + part[1] + ', ' + part[2];
    var time = DateFormat('jm').format(now);

    if (type == 'time')
      return time;
    else
      return result;
  }
} // end of class





















