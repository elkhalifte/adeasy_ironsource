package com.zenozaga.flutter_ironsource

class Constants {

    companion object{

        const val CHANNEL = "com.zenozaga/flutter_ironsource"
        const val CHANNEL_BANNER = "com.zenozaga/flutter_ironsource/banner"

        //// Ad Types
        const val AD_TYPE_INERSTITIAL = "interstitial"
        const val AD_TYPE_REWARD = "reward"
        const val AD_TYPE_BANNER = "banner"
        const val AD_TYPE_OFFERWALL = "offerwall"

        //// Ad Events
        const val EVENT_FAIL = "failed"
        const val EVENT_LOAD = "loaded"
        const val EVENT_OPEN = "opened"
        const val EVENT_CLOSE = "closed"
        const val EVENT_CLICK = "clicked"
        const val EVENT_REWARDE = "rewarded"
        const val EVENT_COMPLETE = "completed"
        const val EVENT_START = "start"
        const val EVENT_LEAVE = "leaved"
        const val EVENT_IMPRESSION = "impression"
        const val EVENT_END = "ended"

        //// Ad methods

        const val METHOD_INIT = "init";
        const val METHOD_PAUSE = "pause";
        const val METHOD_RESUME = "resume";
        const val METHOD_SET_USER = "setUser";
        const val METHOD_SET_CONCENT = "setConsent";
        const val METHOD_SET_TEST_MODE = "testMode";
        const val METHOD_SET_DEBUG_MODE = "debugMode";
        const val METHOD_SET_TRACK_NETWORK = "trackNetwork";
        const val METHOD_GET_ADVERTISER_ID = "getAdvertiserId"


        const val METHOD_LOAD_REWARD = "loadReward";
        const val METHOD_SHOW_REWARD = "showReward";

        const val METHOD_LOAD_OFFERSWALL = "loadOffersWall";
        const val METHOD_SHOW_OFFERSWALL = "showOffersWall";

        const val METHOD_LOAD_INTERSTITIAL = "loadInterstitial";
        const val METHOD_SHOW_INTERSTITIAL = "showInterstitial";

    }

}