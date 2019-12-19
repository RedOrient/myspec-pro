//
//  Session.m
//  IntlSDK
//
//  Created by macmini-compiler on 2019/12/9.
//  Copyright © 2019 macmini-compiler. All rights reserved.
//

#import "Session.h"

@implementation Session
static Session *_instance=nil;
+ (Session *)instance{
    if (_instance == nil) {
        _instance = [[Session alloc] init];
    }
    return _instance;
}
- (instancetype)initWithChannel:(NSString *)channel
                       AuthCode:(NSString *)authcode
                    RequestType:(NSString *)request_type{
    self =[super init];
    if (self) {
        _channel= channel;
        _authcode = authcode;
        _request_type = request_type;
    }
    return self;
}

- (instancetype)initWithChannel:(NSString *)channel
                    AccessToken:(NSString *)access_token{
    self =[super init];
    if (self) {
        _channel= channel;
        _access_token = access_token;
        _request_type = @"token";
    }
    return self;
}
@end
