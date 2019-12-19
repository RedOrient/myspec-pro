//
//  facebook.m
//  GoogleFacebookTest
//
//  Created by macmini-compiler on 2019/11/27.
//  Copyright © 2019 macmini-compiler. All rights reserved.
//

#import "facebook.h"
#import "IntlSDK/IntlSDK.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
@implementation facebook
static facebook *_instance;
static FBSDKLoginManager *loginmanager=nil;

+ (facebook *)instance{
    if (_instance == nil) {
        _instance = [[facebook alloc]init];
    }
    return _instance;
}

+ (FBSDKLoginManager *)LoginManager{
    if (loginmanager == nil) {
        loginmanager = [[FBSDKLoginManager alloc] init];
    }
    return loginmanager;
}

- (void)ApplicationInit:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
}
- (BOOL)handleURL:(UIApplication *)application
          openURL:(NSURL *)url
          options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                   openURL:url
                                         sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}

- (BOOL)handleURL:(UIApplication *)application
          openURL:(NSURL *)url
sourceApplication:(NSString *)sourceApplication
       annotation:(id)annotation{
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                   openURL:url
                                         sourceApplication:sourceApplication
                                                annotation:annotation];
}

- (void)signin:(BOOL)isBind
{
    FBSDKLoginManager *login = [facebook LoginManager];
    [login logInWithPermissions:@[@"public_profile"] fromViewController:self
        handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            if(isBind){
                [[[IntlUserCenter defaultUserCenter] userCenterDelegate] onBindError:error.code errorDescription:error.description];
            }else{
                [[[IntlUserCenter defaultUserCenter] loginDelegate] onLoginError:error.code errorDescription:error.description];
            }
        } else if (result.isCancelled) {
            if(isBind){
                [[IntlUserCenter defaultUserCenter].userCenterDelegate onBindCancel];
            }else{
                [[IntlUserCenter defaultUserCenter].loginDelegate onLoginCancel];
            }
        } else {
            [FBSDKProfile loadCurrentProfileWithCompletion:
             ^(FBSDKProfile *profile, NSError *error) {
                 if ([FBSDKAccessToken currentAccessToken]) {
                     NSString *token = [FBSDKAccessToken currentAccessToken].tokenString;
                     FBSDKAccessToken *accessToken = [FBSDKAccessToken currentAccessToken];
                     // User is logged in, do work such as go to next view controller.
                     //                     [[[IntlUserCenter defaultUserCenter] loginDelegate] onLoginSuccess:token];
                     long timeSmp = (long)[accessToken.dataAccessExpirationDate timeIntervalSince1970];
                     NSNumber *access_expire = [NSNumber numberWithInt:timeSmp];
                     NSNumber *refresh_expire = [NSNumber numberWithInt:0];
                     NSLog(@"account_id is : %@", accessToken.userID);
                     NSLog(@"access_token is : %@", accessToken.tokenString);
                     NSLog(@"access_expire is : %@", access_expire);
                     NSDictionary *diction = [NSDictionary dictionaryWithObjectsAndKeys:
                                              @"token",@"request_type",
                                              accessToken.userID,@"account_id",
                                              accessToken.tokenString,@"access_token",
                                              access_expire, @"access_token_expire",
                                              @"", @"refresh_token",
                                              refresh_expire, @"refresh_token_expire",
                                              nil];
                     if (isBind) {
                         NSLog(@"Bind complete");
                         IntlAccount *account = [AccountCache loadAccount];
                         NSString *url = [NSString stringWithFormat:@"%@%@%@",IntlDefine.GetUrlHost,@"/api/sources/guestbind/facebook?client_id=", IntlDefine.GetGPClient];
                         [[HttpUtil instance] POSTWithURL:url
                                            IntlAccount:account
                                               parameters:diction
                                          successCallback:^(NSDictionary *data){
                                              NSLog(@"facebook bind success--%@",data);
                                              [[[IntlUserCenter defaultUserCenter] userCenterDelegate] onBindSuccess];
                                          } failureCallBack:^(NSNumber *errorCode, NSString *errorMessage){
                                              NSLog(@"guest bind failed--%@", errorMessage);
                                              [[[IntlUserCenter defaultUserCenter] userCenterDelegate] onBindError:errorCode errorDescription:errorMessage];
                                          }];
                     }
                     else
                     {
                         NSLog(@"Logged in");
                         NSString *url = [NSString stringWithFormat:@"%@%@%@",IntlDefine.GetUrlHost,@"/api/auth/authorize/facebook?client_id=", IntlDefine.GetGPClient];
                         //登录验证
                         [[HttpUtil instance] POSTWithURL:url
                                               parameters:diction
                                          successCallback:^(NSDictionary *data){
                                              NSLog(@"facebook login success--%@",data);
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
                                                                                                 Channel:@"facebook"
                                                                                             AccessToken:accessToken
                                                                                       AccessTokenExpire:access_token_expire
                                                                                            RefreshToken:refresh_token
                                                                                      RefreshTokenExpire:refresh_token_expire
                                                                                         FirstAuthorized:first_authorize];
                                              [AccountCache saveAccount:account];
                                              [IntlUserCenterPersistent setIsAutoLogin:true];
                                              [[[IntlUserCenter defaultUserCenter] loginDelegate] onLoginSuccess:openId AccessToken:accessToken];
                                          } failureCallBack:^(NSNumber *errorCode, NSString *errorMessage){
                                              NSLog(@"guest login failed--%@", error.localizedDescription);
                                              [[[IntlUserCenter defaultUserCenter] loginDelegate] onLoginError:errorCode errorDescription:errorMessage];
                                          }];
                     }
                    
//                    [self OpenUserCenter:diction];
                 }
             }];
        }
    }];
}
- (void)signout{
    FBSDKLoginManager *login = [facebook LoginManager];
    if ([FBSDKAccessToken currentAccessToken]) {
        NSLog(@"Facebook Log out");
        [login logOut];
    }
}

- (void)removeAllStoredCredentials
{
    // Delete any cached URLrequests!
    NSURLCache *sharedCache = [NSURLCache sharedURLCache];
    [sharedCache removeAllCachedResponses];
    
    // Also delete all stored cookies!
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookieStorage cookies];
    id cookie;
    for (cookie in cookies) {
        [cookieStorage deleteCookie:cookie];
    }
    
    NSDictionary *credentialsDict = [[NSURLCredentialStorage sharedCredentialStorage] allCredentials];
    if ([credentialsDict count] > 0) {
        // the credentialsDict has NSURLProtectionSpace objs as keys and dicts of userName => NSURLCredential
        NSEnumerator *protectionSpaceEnumerator = [credentialsDict keyEnumerator];
        id urlProtectionSpace;
        // iterate over all NSURLProtectionSpaces
        while (urlProtectionSpace = [protectionSpaceEnumerator nextObject]) {
            NSEnumerator *userNameEnumerator = [[credentialsDict objectForKey:urlProtectionSpace] keyEnumerator];
            id userName;
            // iterate over all usernames for this protectionspace, which are the keys for the actual NSURLCredentials
            while (userName = [userNameEnumerator nextObject]) {
                NSURLCredential *cred = [[credentialsDict objectForKey:urlProtectionSpace] objectForKey:userName];
                //NSLog(@"credentials to be removed: %@", cred);
                [[NSURLCredentialStorage sharedCredentialStorage] removeCredential:cred forProtectionSpace:urlProtectionSpace];
            }
        }
    }
}

// 遍历文件夹获得文件夹大小，返回多少 M
- ( float ) folderSizeAtPath:( NSString *) folderPath{
    NSFileManager * manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject]) != nil ){
        //获取文件全路径
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
    }
    return folderSize/( 1024.0 * 1024.0);
}
// 计算 单个文件的大小
- ( long long ) fileSizeAtPath:( NSString *) filePath{
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath :filePath]){
        return [[manager attributesOfItemAtPath :filePath error : nil] fileSize];
    }
    return 0;
}

-( float )readCacheSize
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES) firstObject];
    return [ self folderSizeAtPath :cachePath];
}

- (void)clearFile
{
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES ) firstObject];
    NSArray * files = [[NSFileManager defaultManager ] subpathsAtPath :cachePath];
    //NSLog ( @"cachpath = %@" , cachePath);
    for ( NSString * p in files) {
        NSError * error = nil ;
        //获取文件全路径
        NSString * fileAbsolutePath = [cachePath stringByAppendingPathComponent :p];
        if ([[NSFileManager defaultManager ] fileExistsAtPath :fileAbsolutePath]) {
            [[NSFileManager defaultManager ] removeItemAtPath :fileAbsolutePath error :&error];
        }
    }
    //读取缓存大小
    float cacheSize = [self readCacheSize] *1024;
//    self.cacheSize.text = [NSString stringWithFormat:@"%.2fKB",cacheSize];
}

//https://kyfw.12306.cn/otn
- (void) OpenUserCenter:(NSDictionary *)parameter{
    NSURL *url = [NSURL URLWithString:@"https://gather-auth.ycgame.com/api/auth/authorize/facebook?client_id=7453817292517158"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
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
            NSDictionary*dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"success--%@",dict);
        }
        else
        {
            NSLog(@"failed--%@", error.localizedDescription);
        }
    }];
    [dataTask resume];
}
@end
