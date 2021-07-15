//
//  Constants.m
//  flutter_ironsource
//
//  Created by Randy Stiven Valentin on 7/14/21.
//

#import <Foundation/Foundation.h>
#import "./Headers/Constants.h"


// Constants.h
 
  //// Channels
  static NSString* const CHANNEL = @"com.zenozaga/adeasy_ironsource";
  static NSString* const CHANNEL_BANNER = @"com.zenozaga/adeasy_ironsource/banner";



  //// Ad Types
  static NSString* const AD_TYPE_INERSTITIAL = @"interstitial";
  static NSString* const AD_TYPE_REWARD = @"reward";
  static NSString* const AD_TYPE_BANNER = @"banner";
  static NSString* const AD_TYPE_OFFERWALL = @"offerwall";

  //// Ad Events
  static NSString* const EVENT_FAIL = @"failed";
  static NSString* const EVENT_LOAD = @"loaded";
  static NSString* const EVENT_OPEN = @"opened";
  static NSString* const EVENT_CLOSE = @"closed";
  static NSString* const EVENT_CLICK = @"clicked";
  static NSString* const EVENT_REWARDE = @"rewarded";
  static NSString* const EVENT_COMPLETE = @"completed";
  static NSString* const EVENT_START = @"start";
  static NSString* const EVENT_LEAVE = @"leaved";
  static NSString* const EVENT_IMPRESSION = @"impression";
  static NSString* const EVENT_END = @"ended";

  //// Ad methods

  static NSString* const METHOD_INIT = @"init";
  static NSString* const METHOD_PAUSE = @"pause";
  static NSString* const METHOD_RESUME = @"resume";
  static NSString* const METHOD_SET_USER = @"setUser";
  static NSString* const METHOD_SET_CONCENT = @"setConsent";
  static NSString* const METHOD_SET_TEST_MODE = @"testMode";
  static NSString* const METHOD_SET_DEBUG_MODE = @"debugMode";
  static NSString* const METHOD_SET_TRACK_NETWORK = @"trackNetwork";
  static NSString* const METHOD_GET_ADVERTISER_ID = @"getAdvertiserId";


  static NSString* const METHOD_LOAD_REWARD = @"loadReward";
  static NSString* const METHOD_SHOW_REWARD = @"showReward";

  static NSString* const METHOD_LOAD_OFFERSWALL = @"loadOffersWall";
  static NSString* const METHOD_SHOW_OFFERSWALL = @"showOffersWall";

  static NSString* const METHOD_LOAD_INTERSTITIAL = @"loadInterstitial";
  static NSString* const METHOD_SHOW_INTERSTITIAL = @"showInterstitial";
