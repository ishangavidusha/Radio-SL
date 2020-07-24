import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_app/models/station_model.dart';
import 'package:radio_app/services/audioBackgroundService.dart';
import 'package:radio_app/state/favoritesStore.dart';
import 'package:radio_app/utils/constancs.dart';
import 'package:rxdart/rxdart.dart';

class AllStations extends StatefulWidget {
  @override
  _AllStationsState createState() => _AllStationsState();
}

void _audioPlayerTaskEntrypoint() async {
  AudioServiceBackground.run(() => AudioPlayerTask());
}

class _AllStationsState extends State<AllStations> {
  bool playButtonState = true;
  Stream<ScreenState> get _screenStateStream =>
      Rx.combineLatest3<List<MediaItem>, MediaItem, PlaybackState, ScreenState>(
          AudioService.queueStream,
          AudioService.currentMediaItemStream,
          AudioService.playbackStateStream,
          (queue, mediaItem, playbackState) =>
              ScreenState(queue, mediaItem, playbackState));

  Future<bool> justStartPlayer(StationModel station) async {
    List<dynamic> qList = List();
    var mediaItem = {
      "id": station.channelUrl,
      "album": station.channelWebsite,
      "title": station.channelName,
      "artUri": station.channelImage,
    };
    qList.add(mediaItem);
    var params = {"data": qList};
    await AudioService.start(
      backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
      androidNotificationChannelName: 'Audio Service Demo',
      androidNotificationColor: 0xFF2196f3,
      androidNotificationIcon: 'mipmap/ic_launcher',
      androidEnableQueue: true,
      params: params,
    );
    return true;
  }

  bool isContain(List<StationModel> list, StationModel station) {
    bool result = false;
    if (list != null) {
      list.forEach((element) {
        if (element.channelId == station.channelId) {
          result = true;
        }
      });
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.of(context).size.width;
    final FavoriteStore favoriteStore = Provider.of<FavoriteStore>(context);
    return ListView.builder(
      padding: EdgeInsets.only(top: 5),
      shrinkWrap: true,
      itemCount: tempAllStations.length,
      itemBuilder: (context, index) {
        return StreamBuilder<ScreenState>(
            stream: _screenStateStream,
            builder: (BuildContext context,
                AsyncSnapshot<ScreenState> asyncSnapshot) {
              ScreenState screenState = asyncSnapshot.data;
              MediaItem mediaItem = screenState?.mediaItem;
              PlaybackState playbackState = screenState?.playbackState;
              AudioProcessingState audioProcessingState =
                  playbackState?.processingState ?? AudioProcessingState.none;
              bool playing = playbackState?.playing ?? false;
              return GestureDetector(
                onTap: playButtonState
                    ? () async {
                        if (audioProcessingState == AudioProcessingState.none) {
                          justStartPlayer(tempAllStations[index]);
                        } else if (playing &&
                            mediaItem?.id ==
                                tempAllStations[index].channelUrl) {
                          await AudioService.stop();
                        } else {
                          setState(() {
                            playButtonState = false;
                          });
                          await AudioService.stop();
                          await Future.delayed(Duration(seconds: 1));
                          await justStartPlayer(tempAllStations[index]);
                          setState(() {
                            playButtonState = true;
                          });
                        }
                      }
                    : null,
                child: Container(
                  width: devWidth,
                  height: 60,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: devWidth,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: mediaItem?.id == tempAllStations[index].channelUrl
                          ? Colors.blue.withOpacity(0.8)
                          : Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                          child: Image.network(
                            tempAllStations[index].channelImage,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        Text(
                          tempAllStations[index].channelName,
                          style: AppColors.mainTextstyle.copyWith(
                            fontSize: 18,
                          ),
                        ),
                        isContain(favoriteStore.favoriteStations, tempAllStations[index]) ?
                        IconButton(
                          icon: Icon(
                            Icons.favorite,
                            size: 26,
                            color: Colors.pinkAccent,
                          ),
                          onPressed: () {
                            favoriteStore.deleteFromFavorite(tempAllStations[index]);
                          },
                        ): IconButton(
                          icon: Icon(
                            Icons.favorite,
                            size: 26,
                            color: AppColors.mainTextColor,
                          ),
                          onPressed: () {
                            favoriteStore.addToFavorite(tempAllStations[index]);
                          },
                        )
                      ],
                    ),
                  ),
                ),
              );
            });
      },
    );
  }
}
