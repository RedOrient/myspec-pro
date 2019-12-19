//
//  IntlInfoUtil.m
//  IntlSDK
//
//  Created by macmini-compiler on 2019/12/9.
//  Copyright © 2019 macmini-compiler. All rights reserved.
//

#import "IntlInfoUtil.h"

@implementation IntlInfoUtil

+ (NSString *)getIDFAIdentifier{
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return adId;
}

+ (long) getUTCTimeStmp{
    NSInteger offset_time = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:[NSDate date]];
    NSDate *date = [NSDate date];
    long timeSmp = [date timeIntervalSince1970];
    timeSmp = timeSmp - offset_time;
    return timeSmp;
}
@end
