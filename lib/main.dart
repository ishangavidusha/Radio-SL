import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:radio_app/services/user_service.dart';
import 'package:radio_app/state/favoritesStore.dart';
import 'package:radio_app/views/homeScreen.dart';
import 'package:radio_app/views/homeView.dart';
import 'package:audio_service/audio_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SL Radio',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChangeNotifierProvider(
        create: (context) => FavoriteStore(UserService()),
        child: AudioServiceWidget(
          child: HomeScreen()
        )
      ),
    );
  }
}
