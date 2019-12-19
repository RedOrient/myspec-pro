//
//  IntlDefine.h
//  IntlSDK
//
//  Created by macmini-compiler on 2019/12/11.
//  Copyright © 2019 macmini-compiler. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IntlDefine : NSObject

+(void)SetGPClient:(NSString *)gpclientid;

+(void)SetGPSecretid:(NSString *)gpsecretid;

+(void)SetFacebookClientid:(NSString *)facebookclientid;

+(void)SetUrlHost:(NSURL *)urlhost;

+(NSString *)GetGPClient;

+(NSString *)GetGPSecretid;

+(NSString *)GetFacebookClientid;

+(NSURL *)GetUrlHost;

@end

NS_ASSUME_NONNULL_END
