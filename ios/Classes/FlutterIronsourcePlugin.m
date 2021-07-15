#import "FlutterIronsourcePlugin.h"
#if __has_include(<flutter_ironsource/flutter_ironsource-Swift.h>)
#import <flutter_ironsource/flutter_ironsource-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_ironsource-Swift.h"
#endif

#import <IronSource/IronSource.h>
#import "Constants.m"
#import "Units/Interstitial.m"
#import "Units/Reward.m"
#import "Units/OfferWall.m"
 
NSString *const _TAG = @"AdEasyIronSource > ";


#pragma mark Banner Integration Interfaces

@interface AdEasyBannerViewFactory: NSObject<FlutterPlatformViewFactory>
-(instancetype)initWithMensseger:(NSObject<FlutterBinaryMessenger>*)messenger;
-(NSObject<FlutterMethodCodec>*) createArgsCodec;

@end



@interface AdEasyBannerView: NSObject<FlutterPlatformView,ISBannerDelegate>

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

- (UIView*)view;
- (FlutterMethodChannel*)channel;
- (void)dispose;
- (void) prepareBannerView;
@end








#pragma mark Banner Integration Implementations

@implementation AdEasyBannerViewFactory{
    NSObject<FlutterBinaryMessenger>* _messenger;
}

-(instancetype)initWithMensseger:(NSObject<FlutterBinaryMessenger> *)messenger{
    
    self = [super init];
    if(self){
        _messenger = messenger;
        
    }
    return self;
}


- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(NSDictionary* _Nullable)args {
    
    
    if(viewId == nil) viewId = 0;
  return [[AdEasyBannerView alloc] initWithFrame:frame
                              viewIdentifier:viewId
                                   arguments:args
                             binaryMessenger:_messenger];
    
}

-(NSObject<FlutterMessageCodec> *)createArgsCodec{
    return [FlutterStandardMessageCodec sharedInstance];
}

@end

@implementation AdEasyBannerView {
    UIView *_view;
    FlutterMethodChannel *_channel;
    NSDictionary *_args;
    int64_t *_viewId;
    ISBannerView* bannerView;
    ISBannerSize* _size;
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    
  
    if (self = [super init]) {
 
        
        

        _size = [self getSize:[args[@"height"] integerValue]];

        _channel = [FlutterMethodChannel methodChannelWithName: [NSString stringWithFormat:(@"%@%i"), CHANNEL_BANNER,viewId]
                                               binaryMessenger:messenger
                                                         codec:[FlutterStandardMethodCodec sharedInstance]];
        _view = [[UIView alloc] init];
        _view.frame = CGRectMake(0, 0, _size.width, _size.height);
        _args = args;
        _viewId = viewId;
        
  }
    
  return self;
    
}

- (UIView*)view {
    
    [self prepareBannerView];
    return _view;
    
}

-(ISBannerSize*)getSize:(NSInteger*)height{
    
    if(height >= ISBannerSize_RECTANGLE.height){
        return ISBannerSize_RECTANGLE;
    }else if(height >= ISBannerSize_LARGE.height){
        return ISBannerSize_LARGE;
    }else if(height >= ISBannerSize_BANNER.height){
        return ISBannerSize_BANNER;
    }
    
    return ISBannerSize_SMART;
}

- (void)prepareBannerView{
    
    

    
        NSString* placement = [_args[@"placement_id"] length] == 0 ? nil : _args[@"placement_id"];
    
       [IronSource setBannerDelegate:self];
       [IronSource loadBannerWithViewController:UIApplication.sharedApplication.keyWindow.rootViewController
                                           size:_size
                                           placement:placement
        ];
    
 
 
    [_channel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        
        
        if([@"dispose" isEqual:call.method]){
            [self dispose];
        }
        
    }];
 
}

- (void)bannerDidDismissScreen {
    [self sendEvent:EVENT_CLOSE error:nil];
}

- (void)bannerDidFailToLoadWithError:(NSError *)error {
    
    [self sendEvent:EVENT_FAIL error:error.description];

}

- (void)bannerDidLoad:(ISBannerView *)bv {
    
    bannerView = bv;
    
    if (@available(iOS 11.0, *)) {
             [bannerView setCenter:CGPointMake(_view.center.x,_view.frame.size.height - (bannerView.frame.size.height/2.0) - _view.safeAreaInsets.bottom)]; // safeAreaInsets is available from iOS 11.0
         } else {
             [bannerView setCenter:CGPointMake(_view.center.x,_view.frame.size.height - (bannerView.frame.size.height/2.0))];
         }

 
    [_view addSubview:bannerView];

    [self sendEvent:EVENT_LOAD error:nil];

}

- (void)bannerDidShow {
    [self sendEvent:EVENT_OPEN error:nil];
}

- (void)bannerWillLeaveApplication {
    [self sendEvent:EVENT_LEAVE error:nil];
}

- (void)bannerWillPresentScreen {
    [self sendEvent:EVENT_IMPRESSION error:nil];
}

- (void)didClickBanner {
    [self sendEvent:EVENT_CLICK error:nil];

}

- (void)dispose{
    
    if(bannerView != nil){
        [IronSource destroyBanner:bannerView];
    }
    [_channel setMethodCallHandler:nil];
}

- (void) sendEvent:(NSString*)event error:(NSString*)error {
    
    if(!error){
        error = @"";
    }
    
    NSLog(@"%@ event > %@ > error > %@", _TAG, event, error);

    
    [channel invokeMethod:event arguments:@{
        @"event": event,
        @"type": AD_TYPE_BANNER,
        @"error": error
    }];
    
}

@end


#pragma mark FlutterIronsourcePlugin Implementations


@implementation FlutterIronsourcePlugin


    FlutterMethodChannel* channel;

    AdEasyInterstitial* mInterstitial;
    AdEasyReward* mReward;
    AdEasyOfferWall* mOfferwall;

    NSString * USERID = @"guest";
    UIViewController * viewController;


    ////
    ////
    ////
    //// iron Source Initialization

    + (void)Initialization: (FlutterMethodCall*) call second:(FlutterResult) result
    {
        
        
        NSString *appKey = call.arguments[@"appKey"];
        NSString *userId = call.arguments[@"userID"];
        Boolean *consent = [@(YES) isEqual:call.arguments[@"consent"]];
        Boolean *debugMode = [@(YES) isEqual:call.arguments[@"debugMode"]];

        [IronSource offerwallCredits];
        [ISIntegrationHelper validateIntegration];
        [ISSupersonicAdsConfiguration configurations].useClientSideCallbacks = [NSNumber numberWithInt:1];

        
        
        if([userId length] == 0){
             //If we couldn't get the advertiser id, we will use a default one.
            userId = [IronSource advertiserId];
        }
        
        if([userId length] == 0){
             //If we couldn't get the advertiser id, we will use a default one.
             userId = USERID;
        }
         
         // After setting the delegates you can go ahead and initialize the SDK.
        
        if(consent) [IronSource setConsent:(YES)];
        
        if(debugMode) {
            [[ISSupersonicAdsConfiguration configurations] setDebugMode:(YES)];
            [IronSource setAdaptersDebug:(YES)];
        }
        
        [IronSource setUserId:userId];
        [IronSource initWithAppKey:appKey];
        
        result(@YES);

    }


    ////
    ////
    ////
    //// Set User

    + (void)setUser: (FlutterMethodCall*) call second:(FlutterResult) result
    {
        
        NSString *userID = call.arguments[@"userID"];
        [IronSource setUserId:userID];
        result(@YES);

    }

    ////
    ////
    ////
    //// Get Adverstise ID

    + (void)adverstiseID: (FlutterMethodCall*) call second:(FlutterResult) result
    {
                
        result([IronSource advertiserId]);

    }

 
    ////
    ////
    ////
    //// setConsent

    + (void)setConsent: (FlutterMethodCall*) call second:(FlutterResult) result
    {
                
        Boolean *consent = [@(YES) isEqual:call.arguments[@"consent"]];
        [IronSource setConsent:consent];
        result(@YES);

    }



 



   ////
   ////
   ////
   //// set Track Network

   + (void)setTrackNwtwork: (FlutterMethodCall*) call second:(FlutterResult) result
   {
               
       Boolean *state = [@(YES) isEqual:call.arguments[@"state"]];
       [IronSource shouldTrackReachability:state];
       result(@YES);

   }


     
    + (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
        
        
        viewController = UIApplication.sharedApplication.keyWindow.rootViewController;

        channel = [FlutterMethodChannel  methodChannelWithName:CHANNEL
                                                binaryMessenger:registrar.messenger];
        
        
        mInterstitial = [[AdEasyInterstitial alloc] initWithMethodChannel:channel];
        mReward = [[AdEasyReward alloc] initWithMethodChannel:channel];
        mOfferwall = [[AdEasyOfferWall alloc] initWithMethodChannel:channel];
        
        [IronSource setInterstitialDelegate:mInterstitial];
        [IronSource setRewardedVideoDelegate:mReward];
        [IronSource setOfferwallDelegate:mOfferwall];
 
        
        AdEasyBannerViewFactory* factory = [[AdEasyBannerViewFactory alloc] initWithMensseger:registrar.messenger];
        [registrar registerViewFactory:factory withId:CHANNEL_BANNER];
         
        

        [channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
            
            
            if([METHOD_INIT isEqualToString:call.method]){
            
                [self Initialization:call second:result];
            
            }else if([METHOD_PAUSE isEqualToString:call.method] || [METHOD_RESUME isEqualToString:call.method]){
                
                result(@YES);
                
            }else if([METHOD_SET_USER isEqualToString:call.method]){
                
                [self setUser:call second:result];
                
            }else if([METHOD_SET_USER isEqualToString:call.method]){
                
                [self setUser:call second:result];
                
            }else if([METHOD_GET_ADVERTISER_ID isEqualToString:call.method]){
                
                [self adverstiseID:call second:result];
                
            }else if([METHOD_SET_TRACK_NETWORK isEqualToString:call.method]){
                
                [self setTrackNwtwork:call second:result];
                
            }else if([METHOD_SET_CONCENT isEqualToString:call.method]){
                
                [self setConsent:call second:result];
                
            }else if([METHOD_LOAD_INTERSTITIAL isEqualToString:call.method]){
                
                [IronSource loadInterstitial];
 
            }else if([METHOD_SHOW_INTERSTITIAL isEqualToString:call.method]){
                
                [IronSource showInterstitialWithViewController:viewController];

                
            }else if([METHOD_LOAD_REWARD isEqualToString:call.method]){
                
                if([IronSource hasRewardedVideo]){
                
                    result(@YES);
                    [self sendEvent:EVENT_LOAD type:AD_TYPE_REWARD error:nil];
                
                }else{
                    
                    result(@NO);
                    
                }

            }else if([METHOD_SHOW_REWARD isEqualToString:call.method]){
                
                [IronSource showRewardedVideoWithViewController:viewController];

            }else if([METHOD_LOAD_OFFERSWALL isEqualToString:call.method]){
                
                if([IronSource hasOfferwall]){
                
                    result(@YES);
                    [self sendEvent:EVENT_LOAD type:AD_TYPE_OFFERWALL error:nil];
                
                }else{
                    
                    result(@NO);
                    
                }
                
            }else if([METHOD_SHOW_OFFERSWALL isEqualToString:call.method]){
                
                [IronSource showOfferwallWithViewController:viewController];
                     // [self setConsent:call second:result];
                
            }else{
            
                result(FlutterMethodNotImplemented);
            
            }
            
          }];
        
        
        
        
      //[SwiftFlutterIronsourcePlugin registerWithRegistrar:registrar];
        
       
    }

+ (void) sendEvent:(NSString*)event type:(NSString*)type error:(NSString*)error {
    
    if(!error){
        error = @"";
    }
    
    NSLog(@"%@ event > %@ > error > %@", _TAG, event, error);

    
    [channel invokeMethod:event arguments:@{
        @"event": event,
        @"type": type,
        @"error": error
    }];
    
}

@end

