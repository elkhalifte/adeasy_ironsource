class Constants {
  static const String CHANNEL = "com.zenozaga/adeasy_ironsource";
  static const String CHANNEL_BANNER = "com.zenozaga/adeasy_ironsource/banner";

  //// Ad Types
  static const String AD_TYPE_INERSTITIAL = "interstitial";
  static const String AD_TYPE_REWARD = "reward";
  static const String AD_TYPE_BANNER = "banner";
  static const String AD_TYPE_OFFERWALL = "offerwall";

  //// Ad Events
  static const String EVENT_FAIL = "failed";
  static const String EVENT_LOAD = "loaded";
  static const String EVENT_OPEN = "opened";
  static const String EVENT_CLOSE = "closed";
  static const String EVENT_CLICK = "clicked";
  static const String EVENT_REWARDE = "rewarded";
  static const String EVENT_COMPLETE = "completed";
  static const String EVENT_START = "start";
  static const String EVENT_LEAVE = "leaved";
  static const String EVENT_IMPRESSION = "impression";
  static const String EVENT_END = "ended";

  //// Ad methods

  static const String METHOD_INIT = "init";
  static const String METHOD_PAUSE = "pause";
  static const String METHOD_RESUME = "resume";
  static const String METHOD_SET_USER = "setUser";
  static const String METHOD_SET_CONCENT = "setConsent";
  static const String METHOD_SET_TEST_MODE = "testMode";
  static const String METHOD_SET_DEBUG_MODE = "debugMode";
  static const String METHOD_SET_TRACK_NETWORK = "trackNetwork";
  static const String METHOD_GET_ADVERTISER_ID = "getAdvertiserId";

  static const String METHOD_LOAD_REWARD = "loadReward";
  static const String METHOD_SHOW_REWARD = "showReward";

  static const String METHOD_LOAD_OFFERSWALL = "loadOffersWall";
  static const String METHOD_SHOW_OFFERSWALL = "showOffersWall";

  static const String METHOD_LOAD_INTERSTITIAL = "loadInterstitial";
  static const String METHOD_SHOW_INTERSTITIAL = "showInterstitial";
}
