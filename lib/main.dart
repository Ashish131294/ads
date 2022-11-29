import 'package:ads/demo_banner.dart';
import 'package:ads/demo_interstitial.dart';
import 'package:ads/demo_native.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MaterialApp(
    home: demo_interstitial(),
  ));
}


const int maxFailedLoadAttempts = 3;

