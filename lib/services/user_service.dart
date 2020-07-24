import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/station_model.dart';

class UserService {

  Future<String> get getFilePath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get getFile async {
    final path = await getFilePath;
    return File("$path/favorites.json");
  }

  Future<bool> isFile() async {
    try {
      final file = await getFile;
      if (file.existsSync()){
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> deleteFile() async {
    try {
      final file = await getFile;
      if (file.existsSync()){
        file.deleteSync();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<StationModel>> readfromeFile() async {
    List<StationModel> gotStations = List();
    try {
      final file = await getFile;
      var gotData = (json.decode(file.readAsStringSync()) as List);
      for (var station in gotData){
        Map stationMap = jsonDecode(station);
        gotStations.add(StationModel.fromJson(stationMap));
      }
      return gotStations;
    } catch (e) {
      print(e.message);
      return gotStations;
    }
  }

  Future<bool> addToFavorite(StationModel station) async {
    List<String> jsonList = List();
    List<StationModel> savedFavorite = await readfromeFile();
    if (savedFavorite == null){
      String jsonString = jsonEncode(station);
      jsonList.add(jsonString);
    } else {
      if (!isContains(savedFavorite, station)){
        savedFavorite.add(station);
      }
      for (StationModel i in savedFavorite){
        String jsonString = jsonEncode(i);
        jsonList.add(jsonString);
      }
    }
    try {
      final file = await getFile;
      file.writeAsStringSync(json.encode(jsonList));
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> deleteFromFavorite(StationModel station) async {
    List<String> jsonList = List();
    List<StationModel> savedFavorite = await readfromeFile();
    if (savedFavorite == null || savedFavorite.isEmpty){
      return true;
    } else {
      savedFavorite.removeWhere((item) => item.channelId == station.channelId);
      for (StationModel i in savedFavorite){
        String jsonString = jsonEncode(i);
        jsonList.add(jsonString);
      }
    }
    try {
      final file = await getFile;
      file.writeAsStringSync(json.encode(jsonList));
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  bool isContains(List<StationModel> stationsList, StationModel checkStation) {
    for (StationModel station in stationsList){
      if (station.channelId == checkStation.channelId){
        return true;
      }
    }
    return false;
  }
}