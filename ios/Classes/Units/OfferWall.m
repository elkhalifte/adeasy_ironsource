//
//  Interstitial.m
//  flutter_ironsource
//
//  Created by Randy Stiven Valentin on 7/13/21.
//

#import <Foundation/Foundation.h>
#import <IronSource/IronSource.h>
#import <Flutter/Flutter.h>
#import "../Constants.m"

#pragma mark - ISInterstitialDelegate

@interface AdEasyOfferWall: NSObject<ISOfferwallDelegate>

@property (strong, nonatomic) FlutterMethodChannel *channel;
 
@end


@implementation AdEasyOfferWall

FlutterMethodChannel* channel;
NSString* TAG_OFFERWALL = @"AdEasyIronSource > OfferWall > ";
FlutterResult result;

- (instancetype)initWithMethodChannel:(FlutterMethodChannel*)channel {
 
    self = [self init];
    
    if(self){
        _channel = channel;
    }
    
    return self;
    
}

 


- (void)didFailToReceiveOfferwallCreditsWithError:(NSError *)error {
    [self sendEvent:EVENT_FAIL error:error.description data:nil];
}

- (BOOL)didReceiveOfferwallCredits:(NSDictionary *)creditInfo {
    
    [self sendEvent:EVENT_REWARDE error:nil data:creditInfo];
    return true;
    
}



- (void)offerwallDidClose {
    [self sendEvent:EVENT_CLOSE error:nil data:nil];
}

- (void)offerwallDidFailToShowWithError:(NSError *)error {
    [self sendEvent:EVENT_FAIL error:error.description data:nil];
}

- (void)offerwallDidShow {
    [self sendEvent:EVENT_OPEN error:nil data:nil];
}

- (void)offerwallHasChangedAvailability:(BOOL)available {
    [self sendEvent:EVENT_LOAD error:nil data:nil];

}




- (void) sendEvent:(NSString*)event error:(NSString*)error data:(NSObject*)data  {
    
    if(!error){
        error = @"";
    }
    
    if(!data){
        data = @{};
    }
    
    NSLog(@"%@ event > %@ > error > %@", TAG_OFFERWALL, event, error);
 
    
    [channel invokeMethod:event arguments:@{
        @"event": event,
        @"type": AD_TYPE_OFFERWALL,
        @"error": error,
        @"data":data
    }];
     
    
}

@end
