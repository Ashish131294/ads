import 'dart:io';

import 'package:ads/demo_banner.dart';
import 'package:ads/demo_native.dart';
import 'package:ads/demo_rewarded.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'app_open_ad_manager.dart';
import 'app_lifecycle_reactor.dart';
import 'main.dart';

class demo_interstitial extends StatefulWidget {
  const demo_interstitial({Key? key}) : super(key: key);

  @override
  State<demo_interstitial> createState() => _demo_interstitialState();
}

class _demo_interstitialState extends State<demo_interstitial> {
  static final AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  int inter = 0;
  late AppLifecycleReactor _appLifecycleReactor;

  @override
  void initState() {
    super.initState();
    AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd();
    _appLifecycleReactor =
        AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
    _appLifecycleReactor.listenToAppStateChanges();
    _createInterstitialAd();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/1033173712'
            : 'ca-app-pub-3940256099942544/4411468910',
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      if (inter == 1) {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return demo_banner();
          },
        ));
      } else if (inter == 2) {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return demo_native();
          },
        ));
      } else if (inter == 2) {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return demo_rewarded();
          },
        ));
      }
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        if (inter == 1) {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return demo_banner();
            },
          ));
        } else if (inter == 2) {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return demo_native();
            },
          ));
        } else if (inter == 3) {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return demo_rewarded();
            },
          ));
        }
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Interstitial ads"),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    inter=1;
                    _showInterstitialAd();
                  },
                  child: Text("Banner ADS")),
              ElevatedButton(
                  onPressed: () {
                    inter=2;
                    _showInterstitialAd();

                  },
                  child: Text("Native ADS")),
              ElevatedButton(
                  onPressed: () {
                    inter=3;
                    _showInterstitialAd();

                  },
                  child: Text("Rewarded ADS"))
            ],
          ),
        ));
  }
}
