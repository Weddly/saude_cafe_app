import 'package:saude_cafe_app/HomePage.dart';
import 'package:saude_cafe_app/core/app_images.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: HomePage(),
      backgroundColor: HexColor("#00C2CB"),
      image: new Image.asset(AppImages.logo3),
      photoSize: 150.0,
      useLoader: true,
      loaderColor: Colors.white,
      loadingText: Text("Carregando...", style: TextStyle(color: Colors.white),),
    );
  }
}
