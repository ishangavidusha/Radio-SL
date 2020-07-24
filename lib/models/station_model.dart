class StationModel {
  String channelId;
  String channelName;
  String channelWebsite;
  String channelUrl;
  String channelImage;
  String channelDiscription;
  String channelCategory;

  StationModel(
      {this.channelId,
      this.channelName,
      this.channelWebsite,
      this.channelUrl,
      this.channelImage,
      this.channelDiscription,
      this.channelCategory});

  StationModel.fromJson(Map<String, dynamic> json) {
    channelId = json['channel_id'];
    channelName = json['channel_name'];
    channelWebsite = json['channel_website'];
    channelUrl = json['channel_url'];
    channelImage = json['channel_image'];
    channelDiscription = json['channel_discription'];
    channelCategory = json['channel_category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['channel_id'] = this.channelId;
    data['channel_name'] = this.channelName;
    data['channel_website'] = this.channelWebsite;
    data['channel_url'] = this.channelUrl;
    data['channel_image'] = this.channelImage;
    data['channel_discription'] = this.channelDiscription;
    data['channel_category'] = this.channelCategory;
    return data;
  }
}

List<StationModel> tempAllStations = [
  StationModel(
    channelId: '6579000d38aa4c2c98d660a67cd864b3',
    channelName: 'Siyatha FM',
    channelWebsite: 'https://siyathafm.lk/',
    channelUrl: 'http://198.178.123.8:8408/stream/1/',
    channelImage: 'https://i.ibb.co/5vws7LJ/siyatha.png',
    channelDiscription:
        'Siyatha FM is a radio channel based in Colombo, Sri Lanka. It is owned by Voice of Asia Ltd., which also runs its sister television channel Siyatha TV. Siyatha FM is available on 98.2 MHz,98.4 MHz Islandwide in Sri Lanka.',
    channelCategory: 'sinhala',
  ),
  StationModel(
    channelId: 'af71b01e34634affacdbf3d3be5bb81d',
    channelName: 'Sirasa FM',
    channelWebsite: 'http://sirasafm.lk/',
    channelUrl: 'http://198.38.92.217:1170/',
    channelImage: 'https://i.ibb.co/FxXD6gz/sirasa.png',
    channelDiscription:
        'Sirasa FM is one of the leading radio stations in the Sri Lankan radio arena. Launched the test transmission in December 1993, and the official launch took place on 2 March 1994.',
    channelCategory: 'sinhala',
  ),
  StationModel(
    channelId: 'c98802631f914b47bff233ab56a0363a',
    channelName: 'Hiru FM',
    channelWebsite: 'http://www.hirufm.lk/',
    channelUrl: 'http://209.133.216.3:7018/stream/1/',
    channelImage: 'https://i.ibb.co/p4QCDw1/hiru.png',
    channelDiscription:
        'Hiru FM is a radio station in Sri Lanka, which is a privately owned Sinhala radio station in Sri Lanka by ABC Radio Networks started in 1998. It covers the whole island. The network currently runs sister stations Sooriyan FM in Tamil and Gold FM and Sun FM in English.',
    channelCategory: 'sinhala',
  ),
  StationModel(
    channelId: 'fbed976695e440ada229bfe068680d78',
    channelName: 'Y FM',
    channelWebsite: 'http://yfm.lk/',
    channelUrl: 'http://198.38.92.217:1180/',
    channelImage: 'https://i.ibb.co/w02NPbD/y.png',
    channelDiscription:
        'A lifestyle channel with an Attitude!! It is the original youth channel. The station has based its programs and promotions on creating a trend in Global Youth Life Style with a Sri Lankan flavor.',
    channelCategory: 'sinhala',
  ),
];
