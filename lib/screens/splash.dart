import 'package:flutter/material.dart';
import 'package:pdf_manager/Screens/Home/Home.dart';
import 'package:pdf_manager/components/navigation.dart';
import 'package:pdf_manager/controller/ad_controller.dart';
import 'dart:typed_data';
class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    AdsProvider.instance.showInterstitialAd();
    Future.delayed(Duration(seconds: 2), () {
      pushAndRemoveUntil(Home());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset('assets/bg.jpg', fit: BoxFit.cover),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // loading
                Center(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50)),
                    child: SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.red),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Powered by Dcodax Pvt. Ltd.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey[300]),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
