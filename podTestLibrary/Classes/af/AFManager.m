//
//  AFManager.m
//  IntlSDKDemo
//
//  Created by macmini-compiler on 2019/12/17.
//  Copyright © 2019 macmini-compiler. All rights reserved.
//

#import "AFManager.h"

@implementation AFManager

static AFManager *_instance;

+ (AFManager *)instance{
    if (_instance == nil) {
        _instance = [[AFManager alloc]init];
    }
    return _instance;
}

- (void)ApplicationInit:(NSString *)DevKey
             appleAppID:(NSString *)AppID{
    [AppsFlyerTracker sharedTracker].appsFlyerDevKey= DevKey;//;
    [AppsFlyerTracker sharedTracker].appleAppID= AppID;//;
    [AppsFlyerTracker sharedTracker].delegate= self;
    
#ifdef DEBUG [AppsFlyerTracker sharedTracker].isDebug= true;
#endif
}

- (void)trackApplaunch{
    // Track Installs, updates & sessions(app opens) (You must include this API to enable tracking)
    [[AppsFlyerTracker sharedTracker] trackAppLaunch];
    // your other code here.... }
}

- (void)trackEvent:(NSString *)eventName
     eventParamDic:(NSDictionary *)params{
//    [[AppsFlyerTracker sharedTracker] trackEvent:AFEventPurchase
//                                      withValues: @{
//                                                    AFEventParamRevenue: @200,
//                                                    AFEventParamCurrency: @"USD",
//                                                    AFEventParamQuantity: @2,
//                                                    AFEventParamContentId: @"092",
//                                                    AFEventParamReceiptId: @"9277"
//                                                    }];
    
    [[AppsFlyerTracker sharedTracker] trackEvent:eventName
                                      withValues:params];
}

@end
