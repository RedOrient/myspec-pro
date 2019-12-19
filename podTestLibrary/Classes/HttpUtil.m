//
//  HttpUtil.m
//  IntlSDK
//
//  Created by macmini-compiler on 2019/12/9.
//  Copyright © 2019 macmini-compiler. All rights reserved.
//

#import "HttpUtil.h"
#import "IntlUserCenterPersistent.h"
#import "Intlgameloading.h"
#import "IntlUserCenter.h"
@implementation HttpUtil
static HttpUtil* _instance = nil;

+ (HttpUtil *)instance{
    if (_instance == nil) {
        _instance = [[HttpUtil alloc]init];
    }
    return _instance;
}

- (void) POSTWithURL: (NSString *)URLString
          parameters: (NSDictionary *)parameter
     successCallback: (SuccessCallback)successCallback
     failureCallBack: (FailureCallBack)failureCallBack{
    [[Intlgameloading instance] Show:[IntlUserCenter defaultUserCenter].current_view];
    
    NSURL *url = [NSURL URLWithString:URLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json"forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"UTF-8"forHTTPHeaderField:@"Charset"];

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameter options:NSJSONWritingPrettyPrinted error:nil];
    //设置请求报文
    [request setHTTPBody:jsonData];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // Do sth to process returend data
        [[Intlgameloading instance] Hide];
        if(!error)
        {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSNumber *errorCode = [dict valueForKey:@"ErrorCode"];
            NSString *errorMessage = [dict valueForKey:@"ErrorMessage"];
            if([errorCode isEqualToNumber:@(0)] && [errorMessage isEqualToString:@"Successed"]){
                NSDictionary *userdata = [dict valueForKey:@"Data"];
                successCallback(userdata);
            }
            else{
                failureCallBack(errorCode, errorMessage);
            }
//            NSLog(@"dict is--%@",dict);
        }
        else
        {
            failureCallBack([NSNumber numberWithInt:error.code], error.localizedDescription);
        }
    }];
    [dataTask resume];
}

- (void) POSTWithURL: (NSString *)URLString
              Header: (NSDictionary *)header
          parameters: (NSDictionary *)parameter
     successCallback: (SuccessCallback)successCallback
     failureCallBack: (FailureCallBack)failureCallBack{
    [[Intlgameloading instance] Show:[IntlUserCenter defaultUserCenter].current_view];
    
    NSURL *url = [NSURL URLWithString:URLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json"forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"UTF-8"forHTTPHeaderField:@"Charset"];

    for
        (id akey in [header allKeys]) {
            [request setValue:[header objectForKey:akey] forHTTPHeaderField:akey];
            NSLog(@"value is --%@", [header objectForKey:akey]);
        }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameter options:NSJSONWritingPrettyPrinted error:nil];
    //设置请求报文
    [request setHTTPBody:jsonData];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // Do sth to process returend data
        [[Intlgameloading instance] Hide];
        if(!error)
        {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSNumber *errorCode = [dict valueForKey:@"ErrorCode"];
            NSString *errorMessage = [dict valueForKey:@"ErrorMessage"];
            if([errorCode isEqualToNumber:@(0)] && [errorMessage isEqualToString:@"Successed"]){
                NSDictionary *userdata = [dict valueForKey:@"Data"];
                successCallback(userdata);
            }
            else{
                failureCallBack(errorCode, errorMessage);
            }
            //            NSLog(@"dict is--%@",dict);
        }
        else
        {
            failureCallBack([NSNumber numberWithInt:error.code], error.localizedDescription);
        }
    }];
    [dataTask resume];
}

- (void) POSTWithURL: (NSString *)URLString
         IntlAccount: (IntlAccount *)account
          parameters: (NSDictionary *)parameter
     successCallback: (SuccessCallback)successCallback
     failureCallBack: (FailureCallBack)failureCallBack{
    [[Intlgameloading instance] Show:[IntlUserCenter defaultUserCenter].current_view];

    NSURL *url = [NSURL URLWithString:URLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json"forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"UTF-8"forHTTPHeaderField:@"Charset"];
    [request setValue:account.access_token forHTTPHeaderField:@"AccessToken"];
    [request setValue:account.openid forHTTPHeaderField:@"OpenId"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameter options:NSJSONWritingPrettyPrinted error:nil];
    //设置请求报文
    [request setHTTPBody:jsonData];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // Do sth to process returend data
        [[Intlgameloading instance] Hide];
        if(!error)
        {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSNumber *errorCode = [dict valueForKey:@"ErrorCode"];
            NSString *errorMessage = [dict valueForKey:@"ErrorMessage"];
            if([errorCode isEqualToNumber:@(0)] && [errorMessage isEqualToString:@"Successed"]){
                NSDictionary *userdata = [dict valueForKey:@"Data"];
                successCallback(userdata);
            }
            else{
                failureCallBack(errorCode, errorMessage);
            }
            //            NSLog(@"dict is--%@",dict);
        }
        else
        {
            failureCallBack([NSNumber numberWithInt:error.code], error.localizedDescription);
        }
    }];
    [dataTask resume];
}
@end
