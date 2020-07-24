import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:radio_app/models/station_model.dart';
import 'package:http/http.dart' as http;

class StationProvider extends ChangeNotifier {
  String initialurl =
      "http://ishanga.pythonanywhere.com/radio/stations/?format=json";
  List<StationModel> allStations;

  Future<List<StationModel>> getAllStations() async {
    await Future.delayed(Duration(seconds: 2));
    notifyListeners();
    return tempAllStations;
    // final response = await http.get(
    //   Uri.encodeFull(initialurl),
    //   headers: {"Accept" : "application/json"}
    // );
    // if (response.statusCode == 200){
    //   allStations = (json.decode(utf8.decode(response.bodyBytes)) as List)
    //       .map((data) => new StationModel.fromJson(data))
    //       .toList();
    //   if (allStations.length == 0){
    //     return null;
    //   } else {
    //     return allStations;
    //   }
    // } else {
    //   return null;
    // }
  }
}
