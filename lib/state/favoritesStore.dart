import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:radio_app/models/station_model.dart';
import 'package:radio_app/services/user_service.dart';
part 'favoritesStore.g.dart';

class FavoriteStore extends _FavoriteStoreBase with _$FavoriteStore {
  FavoriteStore(UserService userService) : super(userService);
}

enum StoreState { initial, loading, loaded }

abstract class _FavoriteStoreBase extends ChangeNotifier with Store {
  final UserService _userService;

  _FavoriteStoreBase(this._userService);

  @observable
  ObservableFuture<List<StationModel>> favoriteStationsFuture;

  @observable
  List<StationModel> favoriteStations;

  @observable
  String errorMessage;

  @computed
  StoreState get state {
    if (favoriteStationsFuture == null || favoriteStationsFuture.status == FutureStatus.rejected) {
      return StoreState.initial;
    }

    return favoriteStationsFuture.status == FutureStatus.pending ? StoreState.loading : StoreState.loaded;
  }

  @action
  Future getFavoriteStations() async {
    try {
      errorMessage = null;
      favoriteStationsFuture = ObservableFuture(_userService.readfromeFile());
      favoriteStations = await favoriteStationsFuture;
    } catch (error) {
      errorMessage = error;
    }
  }

  @action
  Future addToFavorite(StationModel station) async {
    try {
      errorMessage = null;
      bool result = await _userService.addToFavorite(station);
      if (result) {
        favoriteStations.add(station);
        notifyListeners();
      } else {
        errorMessage = "Faild to add favorite";
      }
    } catch (error) {
      errorMessage = error;
    }
  }

  @action
  Future deleteFromFavorite(StationModel station) async {
    try {
      errorMessage = null;
      bool result = await _userService.deleteFromFavorite(station);
      if (result) {
        if (favoriteStations != null && favoriteStations.isNotEmpty) {
          favoriteStations.removeWhere((item) => item.channelId == station.channelId);
          notifyListeners();
        }
      } else {
        errorMessage = "Faild to delete from favorite";
      }
    } catch (error) {
      errorMessage = error;
    }
  }
}