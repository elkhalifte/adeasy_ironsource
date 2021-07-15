

import android.app.Activity
import android.content.Context
import android.util.Log
import android.view.View
import android.widget.FrameLayout
import com.ironsource.mediationsdk.ISBannerSize
import com.ironsource.mediationsdk.IronSource
import com.ironsource.mediationsdk.IronSourceBannerLayout
import com.ironsource.mediationsdk.logger.IronSourceError
import com.ironsource.mediationsdk.sdk.BannerListener
import com.zenozaga.flutter_ironsource.Constants
import com.zenozaga.flutter_ironsource.MapUtil
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class FlutterIronSourcePluginBanner internal constructor(
    private val messenger: BinaryMessenger,
    val mActivity: Activity
) :
    PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, id: Int, args: Any): PlatformView {
        return IronSourcePluginBannerView(context, id, args, messenger, mActivity)
    }

}


internal class IronSourcePluginBannerView(
    context: Context,
    id: Int,
    args: Any,
    messenger: BinaryMessenger?,
    activity: Activity
) :
    PlatformView, BannerListener {

    private val adView: FrameLayout
    private val TAG = "IronSourcePlugin > Banner > "
    private val channel: MethodChannel
    private val args: Any
    private val context: Context
    private val activity: Activity
    private val mIronSourceBannerLayout: IronSourceBannerLayout



    private fun getBannerSize(args: Any): ISBannerSize {

        var height:Int = ISBannerSize.BANNER.height;

        if(args != null && MapUtil.isMap(args) ){
           var _h =  MapUtil.getIn(args,"height");
            if(_h != null){
                height = _h as Int;
            }
        }




        Log.e(TAG, "Banner > height > $height")

        if (height >= ISBannerSize.RECTANGLE.height) {
            return ISBannerSize.RECTANGLE
        } else if (height >= ISBannerSize.LARGE.height) {
            return ISBannerSize.LARGE
        } else if (height >= ISBannerSize.BANNER.height) {
            return ISBannerSize.BANNER
        }

        return ISBannerSize.SMART;

    }









    init {

        channel = MethodChannel(messenger, Constants.CHANNEL_BANNER + id)

        this.args = args
        this.context = context
        this.activity = activity

        adView = FrameLayout(activity)

        val size:ISBannerSize = getBannerSize(args)

        mIronSourceBannerLayout = IronSource.createBanner(activity, size)
        mIronSourceBannerLayout.bannerListener = this
        loadBanner()

    }





    private fun loadBanner() {
        if (adView.childCount > 0) adView.removeAllViews()

        val layoutParams = FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.MATCH_PARENT,
            FrameLayout.LayoutParams.MATCH_PARENT
        );

        adView.addView(
            mIronSourceBannerLayout, 0, layoutParams
        )
        adView.visibility = View.VISIBLE
        IronSource.loadBanner(mIronSourceBannerLayout)


    }

    override fun getView(): View {
        return adView
    }

    override fun dispose() {
        adView.visibility = View.INVISIBLE
        mIronSourceBannerLayout.removeBannerListener()
        IronSource.destroyBanner(mIronSourceBannerLayout)
        channel.setMethodCallHandler(null)
    }

    override fun onBannerAdLoaded() {
        sendEvent(Constants.EVENT_LOAD, null);
    }

    override fun onBannerAdLoadFailed(ironSourceError: IronSourceError) {
        sendEvent(Constants.EVENT_FAIL, ironSourceError?.errorMessage);
    }

    override fun onBannerAdClicked() {
        sendEvent(Constants.EVENT_CLICK, null);
    }

    override fun onBannerAdScreenPresented() {
        sendEvent(Constants.EVENT_OPEN, null);
    }

    override fun onBannerAdScreenDismissed() {
        sendEvent(Constants.EVENT_CLOSE, null);
    }

    override fun onBannerAdLeftApplication() {
        sendEvent(Constants.EVENT_LEAVE, null);
    }


    //sendEvent to client
    fun sendEvent(event: String?,  errorMessage: String?, data: Any? = null ) {

        val message = MapUtil.getInstance();
        if (errorMessage != null && !errorMessage.isEmpty()) message.put("error", errorMessage)

        if(data != null){
            message.put("data", data);
        }


        if(event != null) activity?.runOnUiThread{
            channel.invokeMethod(Constants.AD_TYPE_BANNER, message.map())
        }

    }



}

