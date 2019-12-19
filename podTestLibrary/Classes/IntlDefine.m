//
//  IntlDefine.m
//  IntlSDK
//
//  Created by macmini-compiler on 2019/12/11.
//  Copyright © 2019 macmini-compiler. All rights reserved.
//

#import "IntlDefine.h"

@implementation IntlDefine

static NSString *GPlientid;

static NSString *GPSecretid;

static NSString *FacebookClientid;

static NSURL *urlHost;

+(void)SetGPClient:(NSString *)gpclientid{
    GPlientid = gpclientid;
}

+(void)SetGPSecretid:(NSString *)gpsecretid{
    GPSecretid = gpsecretid;
}

+(void)SetFacebookClientid:(NSString *)facebookclientid{
    FacebookClientid = facebookclientid;
}

+(void)SetUrlHost:(NSURL *)urlhost{
    urlHost = urlhost;
}

+(NSString *)GetGPClient{
    return GPlientid;
}

+(NSString *)GetGPSecretid{
    return GPSecretid;
}

+(NSString *)GetFacebookClientid{
    return FacebookClientid;
}

+(NSURL *)GetUrlHost{
    return urlHost;
}
@end
