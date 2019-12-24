//
//  IntlUserCenter.m
//  IntlSDK
//
//  Created by Jeol Yu on 2019/11/25.
//  Copyright © 2019年 ycgame. All rights reserved.
//

#import "IntlUserCenter.h"
#import "IntlSDKToolkit.h"
#import "IntlWebSession_Internal.h"
#import "IntlSDKCommonDefine.h"
#import "IntlUserCenterPersistent.h"
#import "IntlInfoUtil.h"
#import "HttpUtil.h"
#import "channel/facebook.h"
#import "channel/Guest.h"
#import "AccountCache.h"
#import "IntlDefine.h"
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>

#define INTL_USER_CENTER_PERSISTENT_PATCH      @"/Documents/IntlUserCenter/"
@interface IntlUserCenter()

@property(nonatomic,strong) NSDictionary *appInfo;
@property(nonatomic,strong) NSURL *loginWebURL;
@property(nonatomic,strong) NSURL *userCnenterWebURL;
@property (nonatomic, strong) IntlAccount *currentAccount;
@property(nonatomic,strong) NSString *sessionID;
@property (nonatomic, strong) NSMutableArray *accounts;

@property(nonatomic,assign) CGSize dialogSize;
@property(nonatomic,strong) IntlWebSession *webSession;

@end
@implementation IntlUserCenter

static bool isFirstLogin = true;

+ (void)SetFirstLogin:(bool)is_first_login{
    isFirstLogin = is_first_login;
}

- (instancetype)initWithAppID:(NSString *)appID
                       AppVer:(NSString *)appVersion
                     DeviceID:(NSString *)deviceID
                     Language:(NSString *)language
             UIViewController:(UIViewController *)controller
             FacebookClientID:(NSString *)facebook_clienid
                   GPClientID:(NSString *)gp_clientid
                     GPSecret:(NSString *)gp_secret
                  LoginWebURL:(NSURL *)url
                   DialogSize:(CGSize)dialogSize
{
    NSLog(@"login center init--1");
    self = [super init];
    if(self){
        self.appInfo = @{
                         @"appid":appID,
                         @"appver":appVersion,
                         @"deviceid":deviceID,
                         @"lang":language,
                         @"packagename":[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
                         };
        [IntlDefine SetUrlHost:url];
        [IntlDefine SetGPClient:gp_clientid];
        [IntlDefine SetGPSecretid:gp_secret];
        [IntlDefine SetFacebookClientid:facebook_clienid];
        
        NSString *login_web_url = [NSString stringWithFormat:@"%@%@",url.absoluteString,@"/index.html"];
        self.loginWebURL = [[NSURL alloc] initWithString:login_web_url];
        self.accounts= [[NSMutableArray alloc] initWithCapacity:1];
        self.dialogSize = dialogSize;
        self.current_view = controller;
        self.webSession = [[IntlWebSession alloc] init];

        [self.webSession setSessionClosedHandler:^() {
            NSLog(@"Forceclosed");
        }];
        [self.webSession setGameCenterClickHandler:nil];
        [self.webSession setFacebookClickHandler:^(BOOL isBind) {
            NSLog(@"Facebook Click");
            [[facebook instance] signin:isBind];
        }];
        [self.webSession setGuestClickHandler:^() {
            [[Guest instance] signin];
        }];
        [self registWebCommand];
    }
    return self;
}

static IntlUserCenter *_instance;

+ (void)initWithAppID:(NSString *)appID
               AppVer:(NSString *)appVersion
             DeviceID:(NSString *)deviceID
             Language:(NSString *)language
     UIViewController:(UIViewController *)controller
     FacebookClientID:(NSString *)facebook_clienid
           GPClientID:(NSString *)gp_clientid
             GPSecret:(NSString *)gp_secret
          LoginWebURL:(NSURL *)url
           DialogSize:(CGSize)dialogSize
{
    NSLog(@"login center init --2");
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[IntlUserCenter alloc] initWithAppID:appID
                                                   AppVer:appVersion
                                                 DeviceID:deviceID
                                                 Language:language
                                         UIViewController:controller
                                         FacebookClientID:facebook_clienid
                                               GPClientID:gp_clientid
                                                 GPSecret:gp_secret
                                              LoginWebURL:url
                                               DialogSize:dialogSize];
    });
}

+ (IntlUserCenter *)defaultUserCenter
{
    return _instance;
}

- (void)UserCenter:(UIViewController *)viewController{
    IntlAccount *account = [AccountCache loadAccount];
    NSDictionary *data1 = [account getDictionary];
    NSLog(@"usercenter account is---%@", data1);
    if(!account)
    {
        return;
    }
    NSString *usercenter_web_url = [NSString stringWithFormat:@"%@%@%@%@%@",IntlDefine.GetUrlHost,@"/usercenter.html?openid=",account.openid,@"&access_token=",account.access_token];
    self.userCnenterWebURL = [[NSURL alloc] initWithString:usercenter_web_url];
    [self showUserCenterWebPageForViewController:viewController];
}

- (void)LoginCenterExtension:(UIViewController *)viewController{
    if (IntlWebSession.isShowWebPage) {
        return;
    }
    IntlAccount *account = [AccountCache loadAccount];
    if(account)
    {
        [self ChannelLogout];
    }
    [self showLoginWebPageForViewController:viewController];
}

- (void)LoginCenter:(UIViewController *)viewController{
    if (IntlWebSession.isShowWebPage) {
        return;
    }
//    NSDictionary *data = [IntlUserCenterPersistent getAccountsJSON];
    IntlAccount *account = [AccountCache loadAccount];
    NSDictionary *data1 = [account getDictionary];
    NSLog(@"logincenter account is---%@", data1);
    if(!account)
    {
        [self showLoginWebPageForViewController:viewController];
        return;
    }
    NSString *accessToken = account.access_token;
    NSString *openId = account.openid;
    NSNumber *accessTokenExpire = account.access_token_expire;
    long access_token_expire = [accessTokenExpire longValue];
    long UtcTime = [IntlInfoUtil getUTCTimeStmp];
    NSLog(@"expire is --%ld", access_token_expire);
    NSLog(@"utc time is --%ld", UtcTime);
    NSLog(@"openId is --%@", openId);
    NSLog(@"accessToken is --%@", accessToken);
    if (access_token_expire > UtcTime) {
        NSDictionary *diction = [NSDictionary dictionaryWithObjectsAndKeys:
                                 openId,@"openid",
                                 accessToken,@"access_token",
                                 nil];
        NSString *url = [NSString stringWithFormat:@"%@%@%@%@",IntlDefine.GetUrlHost,@"/api/auth/check/?client_id=",IntlDefine.GetGPClient,@"&debug=true"];
        [[HttpUtil instance] POSTWithURL:url//@"https://gather-auth.ycgame.com/api/auth/check/?client_id=7453817292517158&debug=true"
                              parameters:diction
                         successCallback:^(NSDictionary *data){
                             NSLog(@"check success--%@",data);
                             NSString *_accessToken = [data valueForKey:@"access_token"];
                             NSNumber *_accessTokenExpire = [data valueForKey:@"access_token_expire"];
                             NSString *_openId = [data valueForKey:@"openid"];
                             account.openid = _openId;
                             account.access_token = _accessToken;
                             account.access_token_expire = _accessTokenExpire;
                             BOOL first_authorize = [[data valueForKey:@"first_authorize"] boolValue];
                             if (first_authorize) {
                                 account.first_authorize = [data valueForKey:@"first_authorize"];
                                 //AF打点
                             }
                             [IntlUserCenter SetFirstLogin:false];
                             [[self loginDelegate] onLoginSuccess:_openId AccessToken:_accessToken];
                             [AccountCache saveAccount:account];
                             [IntlUserCenterPersistent setIsAutoLogin:true];
                         } failureCallBack:^(NSNumber *errorCode, NSString *errorMessage){
                             NSLog(@"check failed--%@", errorMessage);
                             [[self loginDelegate] onLoginError:errorCode errorDescription:errorMessage];
                         }];
    }
    else
    {
                NSLog(@"access token is expired");
                long utc_time = [IntlInfoUtil getUTCTimeStmp];
                NSNumber *utc_timestamp = [NSNumber numberWithInt:utc_time];
                NSString *utc_timestamp_str = [utc_timestamp stringValue];
                NSDictionary *diction = [NSDictionary dictionaryWithObjectsAndKeys:
                                         openId,@"openid",
                                         account.refresh_token,@"refresh_token",
                                         utc_timestamp_str,@"tm",
                                         nil];
        
                NSArray *keys = [diction allKeys];
                NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id a,id b) {
                    NSString *first = [diction objectForKey:a];
                    NSString *second = [diction objectForKey:b];
                    return [second compare:first];
                }];
                NSString *str = [self GetStringFromSortDictionary:diction SortedArray:sortedKeys];
                NSString *signStr = [self Sign:str];
                NSDictionary *header = [NSDictionary dictionaryWithObjectsAndKeys:
                                         signStr,@"Authorization",
                                         utc_timestamp_str,@"Timestamp",
                                         nil];
                NSLog(@"str is --%@", str);
                NSLog(@"str is --%@", signStr);

                NSString *url = [NSString stringWithFormat:@"%@%@%@",IntlDefine.GetUrlHost,@"/api/auth/refresh/?client_id=",IntlDefine.GetGPClient];
                [[HttpUtil instance] POSTWithURL:url
                                          Header:header
                                      parameters:diction
                                 successCallback:^(NSDictionary *data){
                                     NSLog(@"refresh success--%@",data);
                                     NSString *openId = [data valueForKey:@"openid"];
                                     NSString *accessToken = [data valueForKey:@"access_token"];
                                     NSString *refresh_token = [data valueForKey:@"refresh_token"];
                                     long expire1 = [[data valueForKey:@"access_token_expire"] longValue];
                                     NSNumber *access_token_expire = [NSNumber numberWithInt:expire1];
                                     
                                     long expire2 = [[data valueForKey:@"refresh_token_expire"] longValue];
                                     NSNumber *refresh_token_expire = [NSNumber numberWithInt:expire2];
                                     BOOL boolNum = [[data valueForKey:@"first_authorize"] boolValue];
                                     NSNumber* first_authorize = [NSNumber numberWithBool:boolNum];

                                     account.openid = openId;
                                     account.access_token = accessToken;
                                     account.access_token_expire = access_token_expire;
                                     account.refresh_token = refresh_token;
                                     account.refresh_token_expire = refresh_token_expire;
                                     account.first_authorize = first_authorize;
                                     [AccountCache saveAccount:account];
                                     [IntlUserCenter SetFirstLogin:false];
                                     [[self loginDelegate] onLoginSuccess:openId AccessToken:accessToken];
                                 } failureCallBack:^(NSNumber *errorCode, NSString *errorMessage){
                                     NSLog(@"refresh failed--%@", errorMessage);
                                     [[self loginDelegate] onLoginError:errorCode errorDescription:errorMessage];
                                 }];
    }
}

- (NSString *)GetStringFromSortDictionary:(NSDictionary *)diction
                                SortedArray:(NSArray *)sortedKeys{
    
    NSMutableString *sum = [NSMutableString stringWithCapacity:100];
    [sum appendString:IntlDefine.GetGPSecretid];
    for (int i = 0; i < sortedKeys.count; ++i) {
        NSString *key = sortedKeys[i];
        for
            (id akey in [diction allKeys]) {
                if ([akey isEqual:key]) {
                    [sum appendString:akey];
                    NSLog(@"value is --%@", [diction objectForKey:akey]);
                    [sum appendString:[diction objectForKey:akey]];
                }
            }
    }
    
    return sum;
}

- (NSString *)Sign:(NSString *)string{
    
    const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:string.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH *2];
    
    for(int i =0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return [result uppercaseString];
}

- (void)registWebCommand {
    
}

- (void)autoLoginWithViewController:(UIViewController *)viewController{
    
}

- (void)showLoginWebPageForViewController:(UIViewController *)viewController{
    [self.webSession showDialogForViewController:viewController
                                            Size:self.dialogSize
                                             URL:self.loginWebURL];
}

- (void)showUserCenterWebPageForViewController:(UIViewController *)viewController{
    [self.webSession showDialogForViewController:viewController
                                            Size:self.dialogSize
                                             URL:self.userCnenterWebURL];
}

- (IntlAccount *)getCurrentAccount {
    return self.currentAccount;
}

- (void)logout {
    self.currentAccount = nil;
    self.sessionID = nil;
    
    [[facebook instance] signout];
    [AccountCache clearAccount];
    if (self.delegate) {
        [self.delegate afterLogout];
    }
}

- (void)ChannelLogout {
    [[Guest instance] signout];
    [[facebook instance] signout];
}

+ (void)ApplicationInit:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [[facebook instance] ApplicationInit:application didFinishLaunchingWithOptions:launchOptions];

}

+ (BOOL)handleURL:(UIApplication *)application
          openURL:(NSURL *)url
          options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    BOOL fbhandled = [[facebook instance] handleURL:application
                                            openURL:url
                                  sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                         annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    // Add any custom logic here.
    return fbhandled;
}

+ (BOOL)handleURL:(UIApplication *)application
          openURL:(NSURL *)url
sourceApplication:(NSString *)sourceApplication
       annotation:(id)annotation{
    BOOL fbhandled = [[facebook instance] handleURL:application
                                            openURL:url
                                  sourceApplication:sourceApplication
                                         annotation:annotation];
    return fbhandled;
}

+ (IntlAccount *)loadAccounts {
    IntlAccount *account = [AccountCache loadAccount];
    if(!account)
    {
        return nil;
    }
    return account;
}

- (void)loadAccounts {
    NSDictionary *jsonObj = [IntlUserCenterPersistent getAccountsJSON];
    if (!jsonObj) {
        return;
    }
    
    [self.accounts removeAllObjects];
    NSArray *jsonArray = [jsonObj valueForKey:@"accounts"];
    for (NSDictionary *dic in jsonArray) {
        [self.accounts addObject:[[IntlAccount alloc] initWithDictionary:dic]];
    }
    
//    [self.accounts sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//        return [obj1 lastActiveDate] < [obj2 lastActiveDate];
//    }];
}
- (void)saveAccount {
    NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc] initWithCapacity:2];
    
    NSMutableArray *jsonArray = [[NSMutableArray alloc] initWithCapacity:2];
    [jsonDic setValue:jsonArray forKey:@"accounts"];
    for (IntlAccount *account in self.accounts) {
        [jsonArray addObject:[account getDictionary]];
    }
    [IntlUserCenterPersistent setAccountsJONS:jsonDic];
}
- (void)setAccount:(IntlAccount *)account  {
    
    for (IntlAccount *tmpAccount in self.accounts) {
        if ([tmpAccount.openid isEqualToString:account.openid]) {
            [self.accounts removeObject:tmpAccount];
            break;
        }
    }
    [self.accounts insertObject:account atIndex:0];
    
    [self saveAccount];
}

- (void)removeAccount:(NSString *)uid {
    for (IntlAccount *tmpAccount in self.accounts) {
        if ([tmpAccount.openid isEqualToString:uid]) {
            [self.accounts removeObject:tmpAccount];
            break;
        }
    }
    [self saveAccount];
}
@end
