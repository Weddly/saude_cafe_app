import 'package:saude_cafe_app/core/app_images.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AppBarWidget extends PreferredSize {
  AppBarWidget()
      : super(
            preferredSize: Size.fromHeight(120),
            child: Container(
                height: 120,
                child: Stack(
                  children: [
                    Container(
                      height: 120,
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(color: HexColor("#00C2CB"),),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                                AppImages.logo2,
                                height: 60,
                                width: 60,
                                alignment: Alignment.center,),

                           Text(
                             "Bem-vindo",
                             style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold ),
                           ),
                          Container(
                            decoration: BoxDecoration(color: HexColor("#00C2CB"),),
                            child: ElevatedButton(
                              child: Icon(Icons.help_outline_rounded, color: Colors.white, size: 40,),
                            )),
                        ],
                      ),
                    ),
                  ],
                )));
}
