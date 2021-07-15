package com.zenozaga.flutter_ironsource

import com.ironsource.mediationsdk.impressionData.ImpressionData
import com.ironsource.mediationsdk.impressionData.ImpressionDataListener
import com.ironsource.mediationsdk.logger.IronSourceError
import com.ironsource.mediationsdk.logger.IronSourceLogger
import com.ironsource.mediationsdk.logger.LogListener
import com.ironsource.mediationsdk.model.Placement
import com.ironsource.mediationsdk.sdk.InterstitialListener
import com.ironsource.mediationsdk.sdk.OfferwallListener
import com.ironsource.mediationsdk.sdk.RewardedVideoListener

abstract class FlutterIronSourceListener  : RewardedVideoListener, OfferwallListener, InterstitialListener,
    ImpressionDataListener, LogListener {

    private var data:Any? = null;

    fun getData(): Any? {
        return data;
    }


    ////
    ////
    ////  Methods to use
    ///////////////////////////////


    open fun onOpen() {}
    open fun onClosed() {}
    open fun onLoad() {}
    open fun onFail(exception: IronSourceError?) {}
    open fun onReward() {}
    open fun onClick() {}
    open fun onStart() {}
    open fun onComplete() {}
    open fun onImpression() {}




    ////
    ////
    ////  Overrides methods
    ///////////////////////////////

    override fun onLog(p0: IronSourceLogger.IronSourceTag?, p1: String?, p2: Int) {

    }

    override fun onImpressionSuccess(impressionData: ImpressionData) {
        onImpression();
    }
    override fun onInterstitialAdReady() {
        onLoad()
    }
    override fun onInterstitialAdLoadFailed(ironSourceError: IronSourceError) {
        onFail(ironSourceError)
    }
    override fun onInterstitialAdOpened() {}
    override fun onInterstitialAdClosed() {
        onClosed()
    }
    override fun onInterstitialAdShowSucceeded() {
        onOpen()
    }
    override fun onInterstitialAdShowFailed(ironSourceError: IronSourceError) {
        onFail(ironSourceError)
    }
    override fun onInterstitialAdClicked() {
        onClick()
    }
    override fun onOfferwallAvailable(b: Boolean) {
        if(b) onLoad()
    }
    override fun onOfferwallOpened() {
        onOpen()
    }
    override fun onOfferwallShowFailed(ironSourceError: IronSourceError) {
        onFail(ironSourceError)
    }
    override fun onOfferwallAdCredited(i: Int, i1: Int, b: Boolean): Boolean {

        data = MapUtil()
            .put("credits", i)
            .put("totalCredits", i1)
            .put("totalCreditsFlag", b)
            .map();


        onReward()
        data = null;


        return true
    }
    override fun onGetOfferwallCreditsFailed(ironSourceError: IronSourceError) {
        onFail(ironSourceError)
    }
    override fun onOfferwallClosed() {
        onClosed()
    }
    override fun onRewardedVideoAdOpened() {
        onOpen()
    }
    override fun onRewardedVideoAdClosed() {
        onClosed()
    }
    override fun onRewardedVideoAvailabilityChanged(b: Boolean) {
        if(b) onLoad()
    }
    override fun onRewardedVideoAdStarted() {
        onStart()
    }
    override fun onRewardedVideoAdEnded() {
        onComplete()
    }
    override fun onRewardedVideoAdRewarded(placement: Placement) {


        data = MapUtil()
            .put("placementId", placement.placementId)
            .put("placementName", placement.placementName)
            .put("rewardAmount", placement.rewardAmount)
            .put("rewardName", placement.rewardName)
            .put("isDefault", placement.isDefault)
            .put("placementSettings", MapUtil()
                .put("cappingValue", placement.placementAvailabilitySettings.cappingValue)
                .put("isCappingEnabled", placement.placementAvailabilitySettings.isCappingEnabled)
                .put("isDeliveryEnabled", placement.placementAvailabilitySettings.isDeliveryEnabled)
                .put("pacingValue", placement.placementAvailabilitySettings.pacingValue)
                .put("cappingName", placement.placementAvailabilitySettings.cappingType.name)
                .map()
            )
            .map();

        onReward()

        data = null;
    }
    override fun onRewardedVideoAdShowFailed(ironSourceError: IronSourceError) {
        onFail(ironSourceError)
    }
    override fun onRewardedVideoAdClicked(placement: Placement) {
        onClick()
    }

}
