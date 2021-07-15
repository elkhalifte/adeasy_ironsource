//
//  Reward.m
//  flutter_ironsource
//
//  Created by Randy Stiven Valentin on 7/13/21.
//

#import <Foundation/Foundation.h>
#import <IronSource/IronSource.h>
#import <Flutter/Flutter.h>
#import "../Constants.m"


@interface AdEasyReward: NSObject<ISRewardedVideoDelegate>

@property (strong, nonatomic) FlutterMethodChannel *channel;
 
@end


@implementation AdEasyReward

    FlutterMethodChannel* channel;
    NSString* TAGG = @"AdEasyIronSource > Interstitial > ";
    FlutterResult result;

- (instancetype)initWithMethodChannel:(FlutterMethodChannel*)channel {
 
    self = [self init];
    
    if(self){
        _channel = channel;
    }
    
    return self;
    
}

 

- (void)didClickRewardedVideo:(ISPlacementInfo *)placementInfo { 
    [self sendEvent:EVENT_CLICK error:nil data:nil];
}

- (void)didReceiveRewardForPlacement:(ISPlacementInfo *)placementInfo { 
    [self sendEvent:EVENT_REWARDE error:nil data:@{
        @"rewardAmount":placementInfo.rewardAmount,
        @"isDefault":@YES,
        @"placementName":placementInfo.placementName,
    }];
}

- (void)rewardedVideoDidClose { 
    [self sendEvent:EVENT_CLOSE error:nil data:nil];
}

- (void)rewardedVideoDidEnd { 
    [self sendEvent:EVENT_END error:nil data:nil];
}

- (void)rewardedVideoDidFailToShowWithError:(NSError *)error { 
    [self sendEvent:EVENT_FAIL error:error.description data:nil];
}

- (void)rewardedVideoDidOpen { 
    [self sendEvent:EVENT_OPEN error:nil data:nil];
}

- (void)rewardedVideoDidStart { 
    [self sendEvent:EVENT_START error:nil data:nil];
}

- (void)rewardedVideoHasChangedAvailability:(BOOL)available { 
    [self sendEvent:EVENT_LOAD error:nil data:nil];
}


- (void) sendEvent:(NSString*)event error:(NSString*)error data:(NSObject*)data  {
    
    if(!error){
        error = @"";
    }
    
    if(!data){
        data = @{};
    }
    
    NSLog(@"%@ event > %@ > error > %@", TAGG, event, error);
 
    
    [channel invokeMethod:event arguments:@{
        @"event": event,
        @"type": AD_TYPE_REWARD,
        @"error": error,
        @"data":data
    }];
     
    
}


@end
