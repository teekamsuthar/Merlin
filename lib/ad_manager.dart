import 'dart:io';

class AdManager {
  static String get appId {
    if (Platform.isAndroid) {
      // return "ca-app-pub-7232818117062807~4082355280";
      return "ca-app-pub-3940256099942544~4354546703"; //test id
    } else if (Platform.isIOS) {
      return "ca-app-pub-7232818117062807~5450782438";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      // return "ca-app-pub-7232818117062807/2357715232";
      return "ca-app-pub-3940256099942544/8865242552"; // test id
    } else if (Platform.isIOS) {
      return "ca-app-pub-7232818117062807/2365114781";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      // return "ca-app-pub-7232818117062807/9801357883";
      return "ca-app-pub-3940256099942544/7049598008"; //testid
    } else if (Platform.isIOS) {
      return "ca-app-pub-7232818117062807/9332592204";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "<YOUR_ANDROID_REWARDED_AD_UNIT_ID>";
    } else if (Platform.isIOS) {
      return "<YOUR_IOS_REWARDED_AD_UNIT_ID>";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
