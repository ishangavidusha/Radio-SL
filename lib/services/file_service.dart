import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

import 'package:radio_app/models/station_model.dart';

class FileService {

  static Future<String> get getFilePath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get getFile async {
    final path = await getFilePath;
    return File("$path/stations.json");
  }

  static Future<bool> saveToFile(List<StationModel> stations) async {
    List<String> contents = List();
    for (StationModel station in stations){
      String data = jsonEncode(station);
      contents.add(data);
    }
    try {
      final file = await getFile;
      file.writeAsStringSync(json.encode(contents));
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<List<StationModel>> readfromeFile() async {
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
      return null;
    }
  }

  static Future<bool> isFile() async {
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
}
