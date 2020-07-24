class SettingsModel {
  bool isLight;
  String language;

  SettingsModel({this.isLight, this.language});

  SettingsModel.fromJson(Map<String, dynamic> json) {
    isLight = json['isLight'];
    language = json['language'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isLight'] = this.isLight;
    data['language'] = this.language;
    return data;
  }
}
