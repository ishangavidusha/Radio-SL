import 'dart:ui';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:radio_app/models/station_model.dart';
import 'package:radio_app/services/audioBackgroundService.dart';
import 'package:radio_app/state/favoritesStore.dart';
import 'package:radio_app/utils/constancs.dart';
import 'package:radio_app/views/allStations.dart';
import 'package:radio_app/views/favoritesView.dart';
import 'package:rxdart/rxdart.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

void _audioPlayerTaskEntrypoint() async {
  AudioServiceBackground.run(() => AudioPlayerTask());
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
  FavoriteStore _favoriteStore;
  AnimationController _animationController;
  Animation _animationCurve;
  Animation<double> _heightFactorAnimation;
  Animation<double> _widthFactor;
  Animation<double> _opacityFactor;
  double collapsedHeightFactor = 0.85;
  double expandedHeightFactor = 0.20;
  bool tapFrowerdEnable = true;
  double devHeight;
  double devWidth;
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _favoriteStore ??= Provider.of<FavoriteStore>(context, listen: false);
  }

  @override
  void initState() {
    super.initState();
    _favoriteStore ??= Provider.of<FavoriteStore>(context, listen: false);
    _favoriteStore.getFavoriteStations();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500)
    );
    _animationCurve = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _heightFactorAnimation = Tween<double>(begin: collapsedHeightFactor, end: expandedHeightFactor).animate(_animationCurve);
    _widthFactor= Tween<double>(begin: 0.2, end: 0.8).animate(_animationCurve);
    _opacityFactor = Tween<double>(begin: 0.0, end: 1.0).animate(_animationCurve);
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        print('Completed');
        tapFrowerdEnable = false;
      } else if (status == AnimationStatus.dismissed) {
        tapFrowerdEnable = true;
      }
    });
  }

  onBottomSheetTap() {
    if (tapFrowerdEnable) {
      _animationController.forward();
    }
  }

  _handleVerticalUpdate(DragUpdateDetails updateDetails) {
    double fractionChange = updateDetails.primaryDelta / devHeight;
    _animationController.value = _animationController.value - 3 * fractionChange;
  }

  _handleVerticalEnd(DragEndDetails endDetails) {
    if (_animationController.value >= 0.5) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }
  StationModel getCurrentStation(List<StationModel> stations, MediaItem mediaItem) {
    StationModel currentStation;
    stations.forEach((element) {
      if (element.channelUrl == mediaItem?.id) {
        currentStation = element;
      }
    });
    return currentStation;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.of(context).size.width;
    devHeight = MediaQuery.of(context).size.height;
    final FavoriteStore favoriteStore = Provider.of<FavoriteStore>(context);
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, animationWidget) {
          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(color: AppColors.backgroundColor),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.bottomCenter,
                      height: devHeight * 0.15,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        height: devHeight * 0.1,
                        width: devWidth,
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Sri Cast Radio',
                              style: AppColors.mainTextstyle.copyWith(fontSize: 26),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // ignore: missing_return
                    Observer(builder: (_) {
                      switch (_favoriteStore.state) {
                        case StoreState.initial:
                          return Container();
                        case StoreState.loading:
                          return buildLoadingFavorite();
                        case StoreState.loaded:
                          if (favoriteStore.favoriteStations != null) {
                            if (favoriteStore.favoriteStations.isNotEmpty) {
                              return FavoritesView();
                            }
                          }
                          return Container();
                        }
                      }),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        width: devWidth,
                        child: Row(
                          children: <Widget>[
                            Text(
                              'All Stations',
                              style: AppColors.mainTextstyle.copyWith(fontSize: 22),
                            ),
                          ],
                        ),
                      ),
                      Container(width: devWidth, child: AllStations()),
                    ],
                  ),
                ),
                StreamBuilder<ScreenState>(
                  stream: _screenStateStream,
                  builder: (BuildContext context, AsyncSnapshot<ScreenState> asyncSnapshot) {
                    ScreenState screenState = asyncSnapshot.data;
                    MediaItem mediaItem = screenState?.mediaItem;
                    PlaybackState playbackState = screenState?.playbackState;
                    AudioProcessingState audioProcessingState = playbackState?.processingState ?? AudioProcessingState.none;
                    bool playing = playbackState?.playing ?? false;
                    StationModel currentStation = getCurrentStation(tempAllStations, mediaItem);
                    return audioProcessingState != AudioProcessingState.none ? GestureDetector(
                      onTap: () {
                        // onBottomSheetTap();
                      },
                      onVerticalDragUpdate: _handleVerticalUpdate,
                      onVerticalDragEnd: _handleVerticalEnd,
                      child: FractionallySizedBox(
                        alignment: Alignment.bottomCenter,
                        heightFactor: 1 - _heightFactorAnimation.value,
                        widthFactor: 1,
                        child: ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                color: Colors.white.withOpacity(_widthFactor.value)
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    top: devHeight * 0.4,
                                    left: devWidth * 0.1,
                                    width: devWidth * 0.8,
                                    child: Container(
                                      child: Opacity(
                                        opacity: _opacityFactor.value,
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              currentStation?.channelName != null ? currentStation.channelName : 'Not Selected',
                                              style: AppColors.mainTextstyle.copyWith(
                                                fontSize: 22
                                              ),
                                            ),
                                            Text(
                                              'Now Playing',
                                              style: AppColors.mainTextstyle.copyWith(
                                                fontSize: 16,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(10),
                                              child: InkWell(
                                                onTap: () {
                                                  if (playing) {
                                                    AudioService.pause();
                                                  } else {
                                                    AudioService.play();
                                                  }
                                                },
                                                child: Container(
                                                  height: devHeight * 0.08,
                                                  width: devWidth * 0.2,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                    color: Colors.white,
                                                  ),
                                                  child: Icon(
                                                    playing ? Icons.stop : Icons.play_circle_filled,
                                                    size: devWidth * 0.15,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              currentStation?.channelDiscription != null ? currentStation.channelDiscription : 'Not Selected',
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    left: devWidth * 0.45,
                                    child: Container(
                                      margin: EdgeInsets.only(top: 8),
                                      height: 5,
                                      width: devWidth * 0.1,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: AppColors.mainTextColor,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: devWidth * 0.1,
                                    top: devHeight * 0.03,
                                    child: Opacity(
                                      opacity: 1 - _opacityFactor.value,
                                      child: InkWell(
                                        onTap: () {
                                          if (playing) {
                                            AudioService.pause();
                                          } else {
                                            AudioService.play();
                                          }
                                        },
                                        child: Container(
                                          height: devHeight * 0.08,
                                          width: devWidth * 0.2,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Colors.white,
                                          ),
                                          child: Icon(
                                            playing ? Icons.stop : Icons.play_circle_filled,
                                            size: devWidth * 0.15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: devHeight * 0.03,
                                    left: devWidth * 0.25,
                                    right: devWidth * 0.25,
                                    child: Opacity(
                                      opacity: 1 - _opacityFactor.value,
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        height: devHeight * 0.08,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              currentStation?.channelName != null ? currentStation.channelName : 'Not Selected',
                                              style: AppColors.mainTextstyle.copyWith(
                                                fontSize: 12
                                              ),
                                            ),
                                            Text(
                                              'Now Playing',
                                              style: AppColors.mainTextstyle.copyWith(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: devWidth * 0.1,
                                    top: devHeight * 0.03,
                                    child: Container(
                                      height: devHeight * _widthFactor.value * 0.4,
                                      width: devWidth * _widthFactor.value,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: audioProcessingState == AudioProcessingState.ready ? Image.network(
                                          currentStation?.channelImage != null ? currentStation?.channelImage : 'https://i.ibb.co/cy0b6mb/placeholder-images-image-large.png',
                                          fit: BoxFit.cover,
                                        ) : Center(
                                          child: CircularProgressIndicator(
                                            backgroundColor: Colors.white,
                                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.mainTextColor),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ),
                    ) : Container();
                  }
                ),
              ],
            );
          }
        ),
      );
    }
  
    Widget buildLoadingFavorite() {
      return Container(
        width: devWidth,
        child: LinearProgressIndicator(
          backgroundColor: AppColors.mainTextColor,
        ),
      );
    }
}
