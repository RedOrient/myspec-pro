//
//  IntlUserCenter.h
//  IntlSDK
//
//  Created by Jeol Yu on 2019/11/25.
//  Copyright © 2019年 ycgame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IntlWebSession.h"

@protocol IntlUserCenterDelegate <NSObject>

@optional

- (void)afterLogin:(NSString *)uid SID:(NSString *)sid;
- (void)afterLogout;
//typedef void(^IntlWebPageLoadFailedHandler)(IntlWebCommandSender *commandSender, NSError *error);


@end

//登录回调接口
@protocol LoginListenerDelegate <NSObject>

- (void)onLoginSuccess:(NSString *)openid
           AccessToken:(NSString *)access_token;

- (void)onLoginCancel;

- (void)onLoginError:(NSUInteger )errorCode
    errorDescription:(NSString *)errorDes;
@end

//绑定回调接口
@protocol UserListenerDelegate <NSObject>

- (void)onBindSuccess;

- (void)onBindCancel;

- (void)onBindError:(NSUInteger )errorCode
    errorDescription:(NSString *)errorDes;

- (void)onSwitchAccount;
@end

@interface IntlUserCenter : NSObject

@property (nonatomic, weak) id<IntlUserCenterDelegate> delegate;
@property (nonatomic, weak) id<LoginListenerDelegate> loginDelegate;
@property (nonatomic, weak) id<UserListenerDelegate> userCenterDelegate;
@property (nonatomic, strong) UIViewController *current_view;


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
WebSessionClosedHandler:(IntlWebSessionClosedHandler)coledHandler
GoogleClickHandler:(IntlGoogleClickHandler)googleHandler
FacebookClickHandler:(IntlFacebookClickHandler)facebookHandler
GuestClickHandler:(IntlGuestClickHandler)guestHandler;


+ (IntlUserCenter *)defaultUserCenter;

- (void)LoginCenter:(UIViewController *)viewController;

- (void)UserCenter:(UIViewController *)viewController;

- (void)autoLoginWithViewController:(UIViewController *)viewController;

- (void)showLoginWebPageForViewController:(UIViewController *)viewController;

- (void)logout;
@end
