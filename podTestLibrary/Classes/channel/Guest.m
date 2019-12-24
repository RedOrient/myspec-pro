//
//  Guest.m
//  IntlSDKDemo
//
//  Created by macmini-compiler on 2019/12/9.
//  Copyright © 2019 macmini-compiler. All rights reserved.
//

#import "Guest.h"
#import "HttpUtil.h"
#import "IntlAccount.h"
#import "IntlUserCenterPersistent.h"
#import "AccountCache.h"
#import "IntlDefine.h"
#import "IntlInfoUtil.h"
#import "IntlUserCenter.h"

@implementation Guest
static Guest *_instance;

+ (Guest *)instance{
    if (_instance == NULL) {
        _instance = [[Guest alloc]init];
    }
    return _instance;
}

- (void)signin{    
    NSString *adId = [IntlInfoUtil getIDFAIdentifier];
    long timeStamp = [IntlInfoUtil getUTCTimeStmp];
    NSDictionary *diction = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"guest",@"request_type",
                             adId,@"unique_id",
                             nil];
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@",IntlDefine.GetUrlHost,@"/api/auth/authorize/?client_id=", IntlDefine.GetGPClient];
    [[HttpUtil instance] POSTWithURL:url
                          parameters:diction
                     successCallback:^(NSDictionary *data){
                         NSLog(@"guest login success--%@",data);
                         NSString *openId = [data valueForKey:@"openid"];
                         NSString *accessToken = [data valueForKey:@"access_token"];
                         NSString *refresh_token = [data valueForKey:@"refresh_token"];
                         long expire1 = [[data valueForKey:@"access_token_expire"] longValue];
                         NSNumber *access_token_expire = [NSNumber numberWithInt:expire1];
                         NSLog(@"access_token_expire is--%ld",expire1);
                         NSLog(@"access_token_expire is--%@",access_token_expire);

                         long expire2 = [[data valueForKey:@"refresh_token_expire"] longValue];
                         NSNumber *refresh_token_expire = [NSNumber numberWithInt:expire2];
                         BOOL boolNum = [[data valueForKey:@"first_authorize"] boolValue];
                         NSNumber* first_authorize = [NSNumber numberWithBool:boolNum];
                         NSLog(@"firstauthorize1 is--%@",first_authorize);
                         NSLog(@"firstauthorize2 is--%d",boolNum);
                         IntlAccount *account = [[IntlAccount instance] initWithUID:openId
                                                                            Channel:@"guest"
                                                                        AccessToken:accessToken
                                                                  AccessTokenExpire:access_token_expire
                                                                       RefreshToken:refresh_token
                                                                 RefreshTokenExpire:refresh_token_expire
                                                                    FirstAuthorized:first_authorize];
                         [AccountCache saveAccount:account];
                         [IntlUserCenterPersistent setIsAutoLogin:true];
                         [IntlUserCenter SetFirstLogin:false];
                         [[[IntlUserCenter defaultUserCenter] loginDelegate] onLoginSuccess:openId AccessToken:accessToken];
                     } failureCallBack:^(NSNumber *errorCode, NSString *errorMessage){
                         NSLog(@"guest login failed--%@", errorMessage);
                         [[[IntlUserCenter defaultUserCenter] loginDelegate] onLoginError:errorCode errorDescription:errorMessage];
                     }];
}

- (void)signout{
    NSLog(@"Guest Logout");
}

- (void) OpenUserCenter:(NSDictionary *)parameter{
    NSString *url = [NSString stringWithFormat:@"%@%@%@",IntlDefine.GetUrlHost,@"/api/auth/authorize/?client_id=", IntlDefine.GetGPClient];
    
    NSURL *authUrl = [[NSURL alloc] initWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:authUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json"forHTTPHeaderField:@"Content-Type"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameter options:NSJSONWritingPrettyPrinted error:nil];
    //设置请求报文
    [request setHTTPBody:jsonData];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // Do sth to process returend data
        
        if(!error)
        {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSDictionary *data = [dict valueForKey:@"Data"];
//            NSString *uid = [data valueForKey:@"openid"];
//            NSString *token = [data valueForKey:@"access_token"];
//            long expire = [data valueForKey:@"access_token_expire"];
//            NSNumber *access_expire = [NSNumber numberWithInt:expire];
//            IntlAccount *newaccount = [[IntlAccount alloc] initWithUID:uid
//                                                                 Token:token AcitiveDate:nil
//                                                           TokenExpire:access_expire];
            
            [IntlUserCenterPersistent setAccountsJONS:data];
            [IntlUserCenterPersistent setIsAutoLogin:true];
            NSLog(@"success--%@",data);
        }
        else
        {
            NSLog(@"failed--%@", error.localizedDescription);
        }
    }];
    [dataTask resume];
}


@end
