import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class demo_native extends StatefulWidget {
  const demo_native({Key? key}) : super(key: key);

  @override
  State<demo_native> createState() => _demo_nativeState();
}

class _demo_nativeState extends State<demo_native> {

  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _nativeAd = NativeAd(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/2247696110'
          : 'ca-app-pub-3940256099942544/3986624511',
      request: AdRequest(),
      factoryId: 'adFactoryExample',
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          print('$NativeAd loaded.');
          setState(() {
            _nativeAdIsLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$NativeAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$NativeAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$NativeAd onAdClosed.'),
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Native Ads"),),
    body: (_nativeAdIsLoaded)?Container(
        width: 250, height: 350, child: AdWidget(ad: _nativeAd!)):Container(),
    );
  }
}




