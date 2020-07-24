import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:radio_app/models/setting_model.dart';

class SettingsService {

  static Future<String> get getFilePath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get getFile async {
    final path = await getFilePath;
    return File("$path/settings.json");
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

  static Future<bool> deleteFile() async {
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

  static Future<SettingsModel> readfromeFile() async {
    SettingsModel gotSettings = SettingsModel();
    try {
      final file = await getFile;
      var gotData = json.decode(file.readAsStringSync());
      Map stationMap = jsonDecode(gotData);
      gotSettings = SettingsModel.fromJson(stationMap);
      return gotSettings;
    } catch (e) {
      print(e.message);
      return null;
    }
  }

  static Future<bool> writeToFile(SettingsModel settings) async {
    String jsonString = jsonEncode(settings);
    try {
      final file = await getFile;
      file.writeAsStringSync(json.encode(jsonString));
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}