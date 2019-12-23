//
//  IntlWebSession.h
//  IntlSDK
//
//  Created by Jeol Yu on 2019/11/25.
//  Copyright © 2019年 ycgame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface IntlWebCommandSender :NSObject
@end

typedef void(^IntlWebCommandHandler)(IntlWebCommandSender *commandSender, NSString* commandDomain, NSString *command, NSDictionary* args);
typedef void(^IntlWebPageLoadFailedHandler)(IntlWebCommandSender *commandSender, NSError *error);
typedef void(^IntlWebSessionClosedHandler)(void);
typedef void(^IntlFacebookClickHandler)(BOOL);
typedef void(^IntlGameCenterClickHandler)(void);
typedef void(^IntlGuestClickHandler)(void);

#define     YC_WEB_GENERAL_COMMAND_DOMAIN   @"yc.mobilesdk.web"
#define     LOGIN_CENTER_WEB_COMMAND_DOMAIN @"yc.mobilesdk.logincenter"
#define     PERSON_CENTER_WEB_COMMAND_DOMAIN    @"yc.mobilesdk.personcenter"


@interface IntlWebSession : NSObject


+ (instancetype)getCurrentWebSession;

+ (BOOL)isShowWebPage;

+ (void)cleanCache;

- (void)showDialogForViewController:(UIViewController *)parent
                                URL:(NSURL *)url;

- (void)showDialogForViewController:(UIViewController *)parent
                               Size:(CGSize)size
                                URL:(NSURL *)url;


- (void)sendEvent:(NSString *)event
              Arg:(NSString *)arg;
    
- (void)registForCommandDomain:(NSString *)commandDomain
                       Command:(NSString *)command
                       Handler:(IntlWebCommandHandler)handler;

- (void)setLoadPageFaildHandler:(IntlWebPageLoadFailedHandler)handler;
- (void)setSessionClosedHandler:(IntlWebSessionClosedHandler)handler;
- (void)setFacebookClickHandler:(IntlFacebookClickHandler)handler;
- (void)setGameCenterClickHandler:(IntlGameCenterClickHandler)handler;
- (void)setGuestClickHandler:(IntlGuestClickHandler)handler;


- (void)forceCloseSession;

@end

@protocol IntlWebPageProtocal <NSObject>

- (IntlWebSession *)getWebSession;

- (void)sendEvent:event Arg:arg;

- (void)setFullScreen;

- (void)setSize:(CGSize)size;

- (void)openNewWebScreenWithURL:(NSURL *)url OrientationMask:(UIInterfaceOrientationMask)orientationMask;

- (void)close;
@end
