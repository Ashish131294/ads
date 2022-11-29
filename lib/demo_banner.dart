import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class demo_banner extends StatefulWidget {
  const demo_banner ({Key? key}) : super(key: key);

  @override
  State<demo_banner> createState() => _demo_bannerState();
}

class _demo_bannerState extends State<demo_banner > {

  BannerAd? _bannerAd;
  bool _bannerAdIsLoaded = false;

  @override
  Widget build(BuildContext context) {

       return Scaffold(appBar: AppBar(title: Text("Banner Ads"),),

       body: (_bannerAdIsLoaded)? Container(
           height: _bannerAd!.size.height.toDouble(),
           width: _bannerAd!.size.width.toDouble(),
           child: AdWidget(ad: _bannerAd!)):Container(height: 320,width: 50,),
       );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/6300978111'
            : 'ca-app-pub-3940256099942544/2934735716',
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {
            print('$BannerAd loaded.');
            setState(() {
              _bannerAdIsLoaded = true;
            });
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            print('$BannerAd failedToLoad: $error');
            ad.dispose();
          },
          onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
          onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
        ),
        request: AdRequest())
      ..load();

  }
}
