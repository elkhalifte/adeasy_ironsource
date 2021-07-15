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

@interface AdEasyInterstitial: NSObject<ISInterstitialDelegate>

@property (strong, nonatomic) FlutterMethodChannel *channel;
 
@end


@implementation AdEasyInterstitial

FlutterMethodChannel* channel;
NSString* TAG = @"AdEasyIronSource > Interstitial > ";
FlutterResult result;

- (instancetype)initWithMethodChannel:(FlutterMethodChannel*)channel {
 
    self = [self init];
    
    if(self){
        _channel = channel;
        [IronSource setInterstitialDelegate:self];
    }
    
    return self;
    
}

 
 


- (void)didClickInterstitial {
    [self sendEvent:EVENT_CLICK error:nil];
}

- (void)interstitialDidClose {
    
    [self sendEvent:EVENT_CLOSE error:nil];
}

- (void)interstitialDidFailToLoadWithError:(NSError *)error {
    [self sendEvent:EVENT_FAIL error:error.description];
}

- (void)interstitialDidFailToShowWithError:(NSError *)error {
    [self sendEvent:EVENT_FAIL error:error.description];
}

- (void)interstitialDidLoad {
        
    [self sendEvent:EVENT_LOAD error:nil];
    
}

- (void)interstitialDidOpen {
    
 
    [self sendEvent:EVENT_OPEN error:nil];
    
}

- (void)interstitialDidShow {

}

- (void) sendEvent:(NSString*)event error:(NSString*)error {
    
    if(!error){
        error = @"";
    }
    
    NSLog(@"%@ event > %@ > error > %@", TAG, event, error);
 
    
    [channel invokeMethod:event arguments:@{
        @"event": event,
        @"type": AD_TYPE_INERSTITIAL,
        @"error": error
    }];
     
    
}

@end
