//
//  IntlAccount.m
//  IntlSDK
//
//  Created by Jeol Yu on 2019/11/25.
//  Copyright © 2019年 ycgame. All rights reserved.
//

#import "IntlAccount.h"

@implementation IntlAccount

static IntlAccount *_instance=nil;
+ (IntlAccount *)instance{
    if (_instance == nil) {
        _instance = [[IntlAccount alloc] init];
    }
    return _instance;
}

- (instancetype)initWithUID:(NSString *)uid
                    Channel:(NSString *)channel
                AccessToken:(NSString *)access_token
          AccessTokenExpire:(NSNumber *)access_token_expire
               RefreshToken:(NSString *)refresh_token
         RefreshTokenExpire:(NSNumber *)refresh_token_expire
            FirstAuthorized:(NSNumber *)first_authorize{
    self =[super init];
    if (self) {
        _openid = uid;
        _channel= channel;
        _access_token = access_token;
        _access_token_expire = access_token_expire;
        _refresh_token = refresh_token;
        _refresh_token_expire = refresh_token_expire;
        _first_authorize = first_authorize;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)accountDic {
    self =[super init];
    if (self) {
        _openid = [accountDic valueForKey:@"openid"];
        _channel= [accountDic valueForKey:@"channel"];
        _access_token = [accountDic valueForKey:@"access_token"];
        _access_token_expire = [accountDic valueForKey:@"access_token_expire"];
        _refresh_token = [accountDic valueForKey:@"refresh_token"];
        _refresh_token_expire = [accountDic valueForKey:@"refresh_token_expire"];
        _first_authorize = [accountDic valueForKey:@"first_authorize"];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSString *)channel
                        Dictionary:(NSDictionary *)accountDic {
    self =[super init];
    if (self) {
        _channel= channel;

        _openid = [accountDic valueForKey:@"openid"];
        _access_token = [accountDic valueForKey:@"access_token"];
        _access_token_expire = [accountDic valueForKey:@"access_token_expire"];
        _refresh_token = [accountDic valueForKey:@"refresh_token"];
        _refresh_token_expire = [accountDic valueForKey:@"refresh_token_expire"];
        _first_authorize = [accountDic valueForKey:@"first_authorize"];
    }
    return self;
}

- (NSDictionary *)getDictionary {
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithCapacity:4];
    [dic setValue:self.openid forKey:@"openid"];
    [dic setValue:self.channel forKey:@"channel"];
    [dic setValue:self.access_token forKey:@"access_token"];
    [dic setValue:self.access_token_expire forKey:@"access_token_expire"];
    [dic setValue:self.refresh_token forKey:@"refresh_token"];
    [dic setValue:self.refresh_token_expire forKey:@"refresh_token_expire"];
    [dic setValue:self.first_authorize forKey:@"first_authorize"];
//    [dic setValue:@(self.lastActiveDate.timeIntervalSince1970) forKey:@"activedate"];
    return [[NSDictionary alloc] initWithDictionary:dic];
}
@end

