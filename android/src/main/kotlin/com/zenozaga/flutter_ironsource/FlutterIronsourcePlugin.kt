package com.zenozaga.flutter_ironsource

import FlutterIronSourcePluginBanner
import android.app.Activity
import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import com.ironsource.adapters.supersonicads.SupersonicConfig
import com.ironsource.mediationsdk.IronSource
import com.ironsource.mediationsdk.integration.IntegrationHelper
import com.ironsource.mediationsdk.logger.IronSourceError

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterIronsourcePlugin */
class FlutterIronsourcePlugin: FlutterPlugin, MethodCallHandler, ActivityAware {

  ////
  ////
  ////  Required
  //////////////////////////////////
  private lateinit var channel:MethodChannel
  private lateinit var mContext: Context
  private  var activity: Activity? = null;
  lateinit var pluginBinding:FlutterPlugin.FlutterPluginBinding;
  private  val TAG:String = "IronSourcePlugin > "



  //
  //
  //
  //  Initialization Methods
  //////////////////////////
  private fun Initialization(call: MethodCall, result: Result) {



    val appKey = call.argument<Any>("appKey") as String?
    val userID = call.argument<String>("userID")
    val consent = call.argument<Any?>("consent") != null
    val testMode = call.argument<Any?>("testMode") != null


    IntegrationHelper.validateIntegration(activity!!)

    IronSource.setUserId(userID ?: "")

    SupersonicConfig.getConfigObj().clientSideCallbacks = true
    SupersonicConfig.getConfigObj().setDebugMode(1)

    if (testMode) IronSource.setAdaptersDebug(true)
    if (consent) IronSource.setConsent(true)

    IronSource.init(activity!!, appKey)
    result.success(true)


  }

  private fun setConcent(call: MethodCall, result: Result?) {
    val enabled = call.argument<Boolean>("enable")
    IronSource.setConsent(enabled == true)
  }





  //
  //
  //
  //  Interstitial Methods
  //////////////////////////




  private fun loadInterstitial(call: MethodCall?, result: Result) {

    if (IronSource.isInterstitialReady()) {

      sendEvent(Constants.EVENT_LOAD, Constants.AD_TYPE_INERSTITIAL, null)
      result.success(true)

    } else {

      IronSource.setInterstitialListener(object : FlutterIronSourceListener(){
        override fun onLoad() {
          sendEvent(Constants.EVENT_LOAD, Constants.AD_TYPE_INERSTITIAL, null)
          result.success(true)
          IronSource.removeInterstitialListener()

        }

        override fun onFail(exception: IronSourceError?) {
          IronSource.removeInterstitialListener()
          result.error(exception?.errorCode.toString(), exception?.errorMessage, exception?.errorMessage)
        }
      })

      IronSource.loadInterstitial()

    }

  }

  private fun showInterstitial(call: MethodCall?, result: Result) {

    val placement_name:String? = call?.argument<String>("placement_name");

    if (IronSource.isInterstitialReady()) {

      IronSource.setInterstitialListener(object : FlutterIronSourceListener(){

        override fun onOpen() {

          sendEvent(Constants.EVENT_OPEN, Constants.AD_TYPE_INERSTITIAL,null);
          result.success(true)

        }

        override fun onFail(exception: IronSourceError?) {

          IronSource.removeInterstitialListener()
          sendEvent(Constants.EVENT_FAIL, Constants.AD_TYPE_INERSTITIAL, exception?.errorMessage);
          result.error(exception?.errorCode.toString(),exception?.errorMessage,"");

        }

        override fun onClosed() {

          IronSource.removeInterstitialListener()
          sendEvent(Constants.EVENT_CLOSE, Constants.AD_TYPE_INERSTITIAL, null);
          IronSource.removeInterstitialListener()

        }

        override fun onClick() {

          sendEvent(Constants.EVENT_CLICK, Constants.AD_TYPE_INERSTITIAL, null);

        }



      })

      IronSource.showInterstitial(placement_name);

    } else {

      IronSource.removeInterstitialListener()
      result.error("0001","${Constants.AD_TYPE_INERSTITIAL} is not loaded","");

    }

  }







  //
  //
  //
  //  RewardVideo Methods
  //////////////////////////

  private fun setDefaultRewardAdtListener(){
    IronSource.setRewardedVideoListener(object : FlutterIronSourceListener(){
      override fun onLoad() {

        sendEvent(Constants.EVENT_LOAD, Constants.AD_TYPE_REWARD,null);

      }
    })
  }

  private fun loadRewardedVideo(call: MethodCall?, result: Result) {

    if (IronSource.isRewardedVideoAvailable()) {

      sendEvent(Constants.EVENT_LOAD, Constants.AD_TYPE_INERSTITIAL, null)
      result.success(true)

    } else {

      setDefaultRewardAdtListener()
      result.success(false)

    }

  }

  private fun showRewardedVideo(call: MethodCall?, result: Result) {


    if (IronSource.isRewardedVideoAvailable()) {

      IronSource.setRewardedVideoListener(object : FlutterIronSourceListener(){
        override fun onClosed() {

          setDefaultRewardAdtListener()
          sendEvent(Constants.EVENT_CLOSE, Constants.AD_TYPE_REWARD,null);

        }
        override fun onClick() {
          sendEvent(Constants.EVENT_CLICK, Constants.AD_TYPE_REWARD,null);
        }

        override fun onOpen() {

          sendEvent(Constants.EVENT_OPEN, Constants.AD_TYPE_REWARD,null);
          result.success(true)

        }

        override fun onFail(exception: IronSourceError?) {

          setDefaultRewardAdtListener()
          sendEvent(Constants.EVENT_FAIL, Constants.AD_TYPE_REWARD, exception?.errorMessage);
          result.error(exception?.errorCode.toString(),exception?.errorMessage,"");


        }

        override fun onReward() {
          sendEvent(Constants.EVENT_REWARDE, Constants.AD_TYPE_REWARD,null, getData());
        }

        override fun onStart() {
          sendEvent(Constants.EVENT_START, Constants.AD_TYPE_REWARD,null);
        }

        override fun onComplete() {
          sendEvent(Constants.EVENT_START, Constants.AD_TYPE_REWARD,null);
        }

      })

      IronSource.showRewardedVideo();

    } else {

      setDefaultRewardAdtListener()
      result.error("0001","${Constants.AD_TYPE_REWARD} is not loaded","");

    }

  }







  //
  //
  //
  //  OfferWall Methods
  //////////////////////////

  private fun setDefaulOfferWallAdtListener(){
    IronSource.setOfferwallListener(object : FlutterIronSourceListener(){
      override fun onLoad() {

        sendEvent(Constants.EVENT_LOAD, Constants.AD_TYPE_OFFERWALL,null);

      }
    })
  }

  private fun loadOfferWall(call: MethodCall?, result: Result) {

    if (IronSource.isOfferwallAvailable()) {

      sendEvent(Constants.EVENT_LOAD, Constants.AD_TYPE_OFFERWALL, null)
      activity?.runOnUiThread{
        result.success(true)
      }

    } else {

      setDefaultRewardAdtListener()
      activity?.runOnUiThread{
        result.success(false)
      }
    }

  }

  private fun showOfferWall(call: MethodCall?, result: Result) {


    if (IronSource.isOfferwallAvailable()) {

      IronSource.setOfferwallListener(object : FlutterIronSourceListener(){
        override fun onClosed() {

          setDefaultRewardAdtListener()
          sendEvent(Constants.EVENT_CLOSE, Constants.AD_TYPE_OFFERWALL,null);

        }
        override fun onClick() {
          sendEvent(Constants.EVENT_CLICK, Constants.AD_TYPE_OFFERWALL,null);
        }

        override fun onOpen() {

          sendEvent(Constants.EVENT_OPEN, Constants.AD_TYPE_OFFERWALL,null);
          activity?.runOnUiThread{
            result.success(true)
          }

        }

        override fun onFail(exception: IronSourceError?) {

          setDefaultRewardAdtListener()
          sendEvent(Constants.EVENT_FAIL, Constants.AD_TYPE_OFFERWALL, exception?.errorMessage);
          activity?.runOnUiThread{
            result.error(exception?.errorCode.toString(),exception?.errorMessage,"");
          }

        }

        override fun onReward() {
          sendEvent(Constants.EVENT_REWARDE, Constants.AD_TYPE_OFFERWALL,null, getData());
        }

        override fun onStart() {
          sendEvent(Constants.EVENT_START, Constants.AD_TYPE_OFFERWALL,null);
        }

        override fun onComplete() {
          sendEvent(Constants.EVENT_START, Constants.AD_TYPE_OFFERWALL,null);
        }

      })

      IronSource.showOfferwall();

    } else {

      setDefaulOfferWallAdtListener()
      result.error("0001","${Constants.AD_TYPE_OFFERWALL} is not loaded","");

    }

  }






  //sendEvent to client
  fun sendEvent(event: String?, type: String, errorMessage: String?, data: Any? = null ) {

    val message = MapUtil();
    if (errorMessage != null && !errorMessage.isEmpty()) message.put("error", errorMessage)

    if(data != null){
      message.put("data", data);
    }

    Log.d(TAG, "Event: $event   Error: $errorMessage");

    if(event != null) activity?.runOnUiThread{
      channel.invokeMethod(event, message.map())
    }

  }









  ////
  ////
  //// Register Banner units
  ///////////////////////////
  private fun registerunits(){

    if(activity != null &&  pluginBinding != null){

      Log.e(TAG,"REGISTERING BANNERS")

      pluginBinding.platformViewRegistry.registerViewFactory(
        Constants.CHANNEL_BANNER,
        FlutterIronSourcePluginBanner( pluginBinding.binaryMessenger, activity!!)
      );

    }

  }







  ////
  ////
  ////  FLutter Plugin Methods
  //////////////////////////////////


  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {

    channel = MethodChannel(flutterPluginBinding.binaryMessenger, Constants.CHANNEL)
    channel.setMethodCallHandler(this)
    pluginBinding = flutterPluginBinding;

    registerunits();

  }


  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }





  ////
  ////
  ////  ActivityAware Methods
  //////////////////////////////////


  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    Log.e(TAG,"onAttachedToActivity")
    this.activity = binding.activity;
    registerunits();
  }

  override fun onDetachedFromActivity() {
    activity = null;
  }


  override fun onDetachedFromActivityForConfigChanges() {  }
  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) { this.activity = binding.activity  }







  ////
  ////
  ////  MethodCallHandler Methods
  //////////////////////////////////

  // Call method handler
  override fun onMethodCall(call: MethodCall, result: Result) {

    val method = call.method

    Log.d(TAG, "method: $method")

    when (method) {
      Constants.METHOD_INIT -> {

        Initialization(call, result)

      }
      Constants.METHOD_RESUME -> {

        IronSource.onResume(activity)
        result.success(true)

      }
      Constants.METHOD_PAUSE -> {

        IronSource.onPause(activity)
        result.success(true)

      }
      Constants.METHOD_SET_TRACK_NETWORK -> {

        IronSource.shouldTrackNetworkState(activity, call.argument<Boolean>("state")!!);
        result.success(true)

      }
      Constants.METHOD_SET_CONCENT -> {

        setConcent(call, result)

      }

      Constants.METHOD_SET_USER -> {

        IronSource.setUserId(call.argument<String>("userID"))
        result.success(true)

      }

      Constants.METHOD_GET_ADVERTISER_ID -> {

        result.success(IronSource.getAdvertiserId(activity))

      }

      Constants.METHOD_SHOW_INTERSTITIAL -> {

        showInterstitial(call, result)

      }
      Constants.METHOD_LOAD_INTERSTITIAL-> {

        loadInterstitial(call, result)

      }
      Constants.METHOD_LOAD_REWARD -> {

        loadRewardedVideo(call, result)

      }
      Constants.METHOD_SHOW_REWARD -> {

        showRewardedVideo(call, result)

      }
      Constants.METHOD_LOAD_OFFERSWALL -> {

        loadOfferWall(call, result)

      }
      Constants.METHOD_SHOW_OFFERSWALL -> {

        showOfferWall(call, result)

      }
      else -> {
        result.notImplemented()
      }
    }
  }
  


}

