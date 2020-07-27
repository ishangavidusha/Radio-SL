import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_app/models/station_model.dart';
import 'package:radio_app/services/audioBackgroundService.dart';
import 'package:radio_app/state/favoritesStore.dart';
import 'package:rxdart/rxdart.dart';

class MediterranesnDietView extends StatefulWidget {
  final AnimationController animationController;
  final Animation animation;

  const MediterranesnDietView(
      {Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  _MediterranesnDietViewState createState() => _MediterranesnDietViewState();
}

void _audioPlayerTaskEntrypoint() async {
  AudioServiceBackground.run(() => AudioPlayerTask());
}

class _MediterranesnDietViewState extends State<MediterranesnDietView> {
  bool playButtonState = true;

  Stream<ScreenState> get _screenStateStream => Rx.combineLatest3<List<MediaItem>, MediaItem, PlaybackState, ScreenState>(
    AudioService.queueStream,
    AudioService.currentMediaItemStream,
    AudioService.playbackStateStream,
    (queue, mediaItem, playbackState) => ScreenState(queue, mediaItem, playbackState)
  );

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

  @override
  Widget build(BuildContext context) {
    final FavoriteStore favoriteStore = Provider.of<FavoriteStore>(context);
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.animation,
          child: Transform(
            transform: Matrix4.translationValues(
              0.0,
              30 * (1.0 - widget.animation.value),
              0.0,
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 16,
                bottom: 18,
              ),
              child: Container(
                height: 160,
                child: ListView.builder(
                  padding: EdgeInsets.only(left: 15),
                  scrollDirection: Axis.horizontal,
                  itemCount: favoriteStore.favoriteStations == null ? 0 : favoriteStore.favoriteStations.length,
                  itemBuilder: (BuildContext context, int index) {
                    return StreamBuilder<ScreenState>(
                      stream: _screenStateStream,
                      builder: (BuildContext context, AsyncSnapshot<ScreenState> asyncSnapshot) {
                        ScreenState screenState = asyncSnapshot.data;
                        MediaItem mediaItem = screenState?.mediaItem;
                        PlaybackState playbackState = screenState?.playbackState;
                        AudioProcessingState audioProcessingState = playbackState?.processingState ?? AudioProcessingState.none;
                        bool playing = playbackState?.playing ?? false;
                        return GestureDetector(
                          onTap: playButtonState ? () async {
                            if (audioProcessingState == AudioProcessingState.none) {
                              justStartPlayer(favoriteStore.favoriteStations[index]);
                            } else if (playing && mediaItem?.id == favoriteStore.favoriteStations[index].channelUrl) {
                              await AudioService.stop();
                            } else {
                              setState(() {
                                playButtonState = false;
                              });
                              await AudioService.stop();
                              await Future.delayed(Duration(seconds: 1));
                              await justStartPlayer(favoriteStore.favoriteStations[index]);
                              setState(() {
                                playButtonState = true;
                              });
                            }
                          } : null,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            width: 120,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                            child: Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    favoriteStore.favoriteStations[index].channelImage,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                          colors: [
                                            Colors.black.withOpacity(0.5),
                                            Colors.transparent,
                                          ],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          stops: [0.0, 0.3])),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    child: Text(
                                      favoriteStore.favoriteStations[index].channelName,
                                      style: AppColors.mainTextstyle.copyWith(fontSize: 16, color: Colors.white),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
