import 'dart:convert';

//import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:geolocator/geolocator.dart';
//import 'package:great_circle_distance2/great_circle_distance2.dart';

//import 'package:provider/provider.dart';

class City {
  String name, englishName;

  City({this.name, this.englishName});

  factory City.fromJson(Map<String, dynamic> json) => City(
    name: json["name"],
    englishName: json["english_name"],
  );
}


class LocationHelper {
  List<City> _cities;
  //LocationPosition _myPos;

  List<City> get cities => _cities;

  static final LocationHelper _singleton = LocationHelper._();

  factory LocationHelper() => _singleton;

  LocationHelper._();

  void init(List<City> cities) {
    _cities = cities;
  }

  Future<String> cityName(BuildContext context, String locale,
      int locationID) async {
    return (locale == 'he')
        ? _cities[locationID].name
        : _cities[locationID].englishName;
  }


  static Future<List<City>> loadCountriesJson(BuildContext context) async {
    //  Cleaning up the countries list before we put our data in it
    var countries = <City>[];

    //  Fetching the json file, decoding it and storing each object as Country
    //  in countries(list)
    var value = await DefaultAssetBundle.of(context)
        .loadString("assets/raw/israel_cities.json");
    var countriesJson = json.decode(value);
    for (var country in countriesJson) {
      countries.add(City.fromJson(country));
    }

    //Finally adding the initial data to the _countriesSink
    // _countriesSink.add(countries);
    return countries;
  }
}