// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favoritesStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FavoriteStore on _FavoriteStoreBase, Store {
  Computed<StoreState> _$stateComputed;

  @override
  StoreState get state =>
      (_$stateComputed ??= Computed<StoreState>(() => super.state,
              name: '_FavoriteStoreBase.state'))
          .value;

  final _$favoriteStationsFutureAtom =
      Atom(name: '_FavoriteStoreBase.favoriteStationsFuture');

  @override
  ObservableFuture<List<StationModel>> get favoriteStationsFuture {
    _$favoriteStationsFutureAtom.reportRead();
    return super.favoriteStationsFuture;
  }

  @override
  set favoriteStationsFuture(ObservableFuture<List<StationModel>> value) {
    _$favoriteStationsFutureAtom
        .reportWrite(value, super.favoriteStationsFuture, () {
      super.favoriteStationsFuture = value;
    });
  }

  final _$favoriteStationsAtom =
      Atom(name: '_FavoriteStoreBase.favoriteStations');

  @override
  List<StationModel> get favoriteStations {
    _$favoriteStationsAtom.reportRead();
    return super.favoriteStations;
  }

  @override
  set favoriteStations(List<StationModel> value) {
    _$favoriteStationsAtom.reportWrite(value, super.favoriteStations, () {
      super.favoriteStations = value;
    });
  }

  final _$errorMessageAtom = Atom(name: '_FavoriteStoreBase.errorMessage');

  @override
  String get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  final _$getFavoriteStationsAsyncAction =
      AsyncAction('_FavoriteStoreBase.getFavoriteStations');

  @override
  Future<dynamic> getFavoriteStations() {
    return _$getFavoriteStationsAsyncAction
        .run(() => super.getFavoriteStations());
  }

  final _$addToFavoriteAsyncAction =
      AsyncAction('_FavoriteStoreBase.addToFavorite');

  @override
  Future<dynamic> addToFavorite(StationModel station) {
    return _$addToFavoriteAsyncAction.run(() => super.addToFavorite(station));
  }

  final _$deleteFromFavoriteAsyncAction =
      AsyncAction('_FavoriteStoreBase.deleteFromFavorite');

  @override
  Future<dynamic> deleteFromFavorite(StationModel station) {
    return _$deleteFromFavoriteAsyncAction
        .run(() => super.deleteFromFavorite(station));
  }

  @override
  String toString() {
    return '''
favoriteStationsFuture: ${favoriteStationsFuture},
favoriteStations: ${favoriteStations},
errorMessage: ${errorMessage},
state: ${state}
    ''';
  }
}
