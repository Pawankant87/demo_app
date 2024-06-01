import 'dart:async';
import 'package:demo_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    whereToGo();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Splash Screen"),
      ),
    );
  }

  Future<void> whereToGo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic email = prefs.getString('email');

    Timer(
      const Duration(seconds: 2),
      () {
        if (email != 'null' && email != null) {
          Get.offAllNamed(RoutesClass.getCustomerListPageRoute());
        } else {
          Get.offAllNamed(RoutesClass.getLoginScreenRoute());
        }
      },
    );
  }
}
