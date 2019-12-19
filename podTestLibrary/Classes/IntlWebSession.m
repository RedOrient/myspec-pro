//
//  IntlWebSession.m
//  IntlSDK
//
//  Created by Jeol Yu on 2019/11/25.
//  Copyright © 2019年 ycgame. All rights reserved.
//

#import "IntlWebSession.h"
#import "IntlWebSession_Internal.h"
#import "IntlWebDialogNavigationController.h"
#import "IntlWebDialogViewController.h"
#import "IntlSDKCommonDefine.h"
#import "IntlSDKToolkit.h"
#import "IntlWebCommandSender_Internal.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "IntlUserCenter.h"



@interface IntlWebSession () <UIAlertViewDelegate> {
    IntlWebPageLoadFailedHandler _loadFailedHandler;
    IntlWebSessionClosedHandler _sessionClosedHandler;
    IntlGoogleClickHandler _googleClickHandler;
    IntlFacebookClickHandler _facebookClickHandler;
    IntlGuestClickHandler _guestClickHandler;

}



@property (nonatomic, weak) id<IntlWebPageProtocal> webDialog;

@property (nonatomic, weak) id<IntlWebPageProtocal> webPage;


@end

@implementation IntlWebSession


static IntlWebSession *_currentSession = nil;
+ (instancetype)getCurrentWebSession
{
    return _currentSession;
}

+ (void)setCurrentWebSession:(IntlWebSession *)webSession {
    _currentSession = webSession;
}

+ (BOOL)isShowWebPage {
    return (_currentSession != nil);
}

+ (void)cleanCache {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        NSSet *websiteDataTypes
        = [NSSet setWithArray:@[
                                WKWebsiteDataTypeDiskCache,
                                //WKWebsiteDataTypeOfflineWebApplicationCache,
                                WKWebsiteDataTypeMemoryCache,
                                //WKWebsiteDataTypeLocalStorage,
                                //WKWebsiteDataTypeCookies,
                                //WKWebsiteDataTypeSessionStorage,
                                //WKWebsiteDataTypeIndexedDBDatabases,
                                //WKWebsiteDataTypeWebSQLDatabases
                                ]];
        //// All kinds of data
        //NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        //// Date from
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        //// Execute
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            //            [commandSender onCommandResponseWithCode:(YC_SDK_WEB_VIEW_DOMAIN | YC_SDK_GENERAL_WEB_COMMAND_MODULE | YC_SDK_MSG )
            //                                             Message:@"success" Result:nil];
        }];
    } else {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
        //        [commandSender onCommandResponseWithCode:(YC_SDK_WEB_VIEW_DOMAIN | YC_SDK_GENERAL_WEB_COMMAND_MODULE | YC_SDK_MSG )
        //                                         Message:@"success" Result:nil];
    }
    
}
///================================================================


- (instancetype)init {
    self = [super init];
    if (self) {
        _registedCommandDomain = [[NSMutableDictionary alloc] initWithCapacity:1];
        [self registCloseCommand];
        [self registPersonCenterCloseCommand];
        [self registRefreshCommand];
        [self registCloseAllCommand];
        [self registGoogleCommand];
        [self registPersonCenterGoogleCommand];
        [self registFacebookCommand];
        [self registPersonCenterFacebookCommand];
        [self registGuestCommand];
        [self registPersonCenterSwitchCommand];
    }
    return self;
}

- (void)showDialogForViewController:(UIViewController *)parent
                               Size:(CGSize)size
                                URL:(NSURL *)url {
    if ([IntlWebSession isShowWebPage] && self != _currentSession) {
        return;
    }
    if (self.webPage || self.webDialog) {
        return;
    }
    [IntlWebSession setCurrentWebSession:self];
    IntlWebDialogViewController *webDialogVC = [[IntlWebDialogViewController alloc] initWithWebViewSize:size
                                                                                                WithURL:url
                                                                                             WebSession:self];
    UINavigationController *rootVC = [[UINavigationController alloc] initWithRootViewController:webDialogVC];
    rootVC.navigationBarHidden = YES;
    
    
    [parent addChildViewController:rootVC];
    [parent.view addSubview:rootVC.view];
}

- (void)showDialogForViewController:(UIViewController *)parent
                                URL:(NSURL *)url {
    if ([IntlWebSession isShowWebPage] && self != _currentSession) {
        return;
    }
    if (self.webPage|| self.webDialog) {
        return;
    }
    [IntlWebSession setCurrentWebSession:self];
    IntlWebDialogViewController *webDialogVC = [[IntlWebDialogViewController alloc] initFullScreenWithURL:url WebSession:self];
    UINavigationController *rootVC = [[UINavigationController alloc] initWithRootViewController:webDialogVC];
    rootVC.navigationBarHidden = YES;
    
    [parent addChildViewController:rootVC];
    [parent.view addSubview:rootVC.view];
}



- (void)forceCloseSession {
    if (self.webPage) {
        [self.webPage close];
    }
    if (self.webDialog) {
        [self.webDialog close];
    }
}


- (void)sendEvent:(NSString *)event
              Arg:(NSString *)arg {
    if (self.webDialog) {
        [self.webDialog sendEvent:event Arg:arg];
    }
    if (self.webPage) {
        [self.webPage sendEvent:event Arg:arg];
    }
}

- (void)onWebDialogOpend:(id<IntlWebPageProtocal>)webDialog {
    self.webDialog = webDialog;
    [IntlWebSession setCurrentWebSession:self];
}

- (void)onWebPageOpend:(id<IntlWebPageProtocal>)webPage {
    self.webPage = webPage;
    [IntlWebSession setCurrentWebSession:self];
}

- (void)onWebDialogClosed {
    self.webDialog = nil;
    if (!self.webPage && ! self.webDialog) {
        [IntlWebSession setCurrentWebSession:nil];
        if (_sessionClosedHandler) {
            _sessionClosedHandler();
        }
    }
}

- (void)onWebPageClosed {
    self.webPage = nil;
    if (!self.webPage && ! self.webDialog) {
        [IntlWebSession setCurrentWebSession:nil];
        if (_sessionClosedHandler) {
            _sessionClosedHandler();
        }
    }
}

- (void)setLoadPageFaildHandler:(IntlWebPageLoadFailedHandler)handler {
    _loadFailedHandler = handler;
}

- (void)setSessionClosedHandler:(IntlWebSessionClosedHandler)handler {
    _sessionClosedHandler = handler;
}

- (void)setGoogleClickHandler:(IntlGoogleClickHandler)handler {
    _googleClickHandler = handler;
}

- (void)setFacebookClickHandler:(IntlFacebookClickHandler)handler {
    _facebookClickHandler = handler;
}

- (void)setGuestClickHandler:(IntlGuestClickHandler)handler {
    _guestClickHandler = handler;
}

#pragma mark - Reg General Command


- (void)registForCommandDomain:(NSString *)commandDomain
                       Command:(NSString *)command
                       Handler:(IntlWebCommandHandler)handler  {
    if (commandDomain && command && handler) {
        if (handler) {
            NSMutableDictionary *commands = nil;
            if (![self.registedCommandDomain.allKeys containsObject:commandDomain]) {
                commands = [[NSMutableDictionary alloc] initWithCapacity:1];
                [self.registedCommandDomain setValue:commands forKey:commandDomain];
            } else {
                commands = [self.registedCommandDomain valueForKey:commandDomain];
            }
            [commands setValue:handler forKey:command];
            
        } else {
            if ([self.registedCommandDomain.allKeys containsObject:commandDomain]) {
                NSMutableDictionary *commands = [self.registedCommandDomain valueForKey:commandDomain];
                if ([commands.allKeys containsObject:commandDomain]) {
                    [commands removeObjectForKey:commands];
                }
                if (commands.count == 0) {
                    [self.registedCommandDomain removeObjectForKey:commandDomain];
                }
            }
        }
        
    }
}


- (void)registCloseCommand {
    __weak IntlWebSession *weakSelf = self;
    [self registForCommandDomain:LOGIN_CENTER_WEB_COMMAND_DOMAIN
                         Command:@"close"
                         Handler:^(IntlWebCommandSender *commandSender, NSString *commandDomain, NSString *command, NSDictionary *args) {
                             [commandSender.senderWebPage close];
                             [[IntlUserCenter defaultUserCenter].loginDelegate onLoginCancel];

                             weakSelf.webPage = nil;
                             NSLog(@"close");
                         }];
}

- (void)registPersonCenterCloseCommand {
    __weak IntlWebSession *weakSelf = self;
    [self registForCommandDomain:PERSON_CENTER_WEB_COMMAND_DOMAIN
                         Command:@"close"
                         Handler:^(IntlWebCommandSender *commandSender, NSString *commandDomain, NSString *command, NSDictionary *args) {
                             [commandSender.senderWebPage close];
                             [[IntlUserCenter defaultUserCenter].userCenterDelegate onBindCancel];
                             weakSelf.webPage = nil;
                             NSLog(@"personcenter close");
                         }];
}

- (void)registCloseAllCommand {
    __weak IntlWebSession *weakSelf = self;
    [self registForCommandDomain:YC_WEB_GENERAL_COMMAND_DOMAIN
                         Command:@"closeall" Handler:^(IntlWebCommandSender *commandSender, NSString *commandDomain, NSString *command, NSDictionary *args) {
                             NSLog(@"closeall");
                             if (weakSelf.webDialog) {
                                 [weakSelf.webDialog close];
                             }
                         }];
}

- (void)registGoogleCommand {
    __weak IntlWebSession *weakSelf = self;
    [self registForCommandDomain:LOGIN_CENTER_WEB_COMMAND_DOMAIN
                         Command:@"Google" Handler:^(IntlWebCommandSender *commandSender, NSString *commandDomain, NSString *command, NSDictionary *args) {
                             if (weakSelf.webDialog) {
                                 [weakSelf.webDialog close];
                             }
                             if (_googleClickHandler != nil) {
                                 _googleClickHandler();
                             }

                         }];
}
- (void)registPersonCenterGoogleCommand {
    __weak IntlWebSession *weakSelf = self;
    [self registForCommandDomain:PERSON_CENTER_WEB_COMMAND_DOMAIN
                         Command:@"Google" Handler:^(IntlWebCommandSender *commandSender, NSString *commandDomain, NSString *command, NSDictionary *args) {
                             if (weakSelf.webDialog) {
                                 [weakSelf.webDialog close];
                             }
                             if (_googleClickHandler != nil) {
                                 _googleClickHandler();
                             }
                             NSLog(@"personcenter google");
                             
                         }];
}

- (void)registFacebookCommand {
    __weak IntlWebSession *weakSelf = self;
    [self registForCommandDomain:LOGIN_CENTER_WEB_COMMAND_DOMAIN
                         Command:@"Facebook" Handler:^(IntlWebCommandSender *commandSender, NSString *commandDomain, NSString *command, NSDictionary *args) {
                             if (weakSelf.webDialog) {
                                 [weakSelf.webDialog close];
                             }
                             if (_facebookClickHandler != nil) {
                                 _facebookClickHandler(NO);
                             }
                         }];
}
- (void)registPersonCenterFacebookCommand {
    __weak IntlWebSession *weakSelf = self;
    [self registForCommandDomain:PERSON_CENTER_WEB_COMMAND_DOMAIN
                         Command:@"Facebook" Handler:^(IntlWebCommandSender *commandSender, NSString *commandDomain, NSString *command, NSDictionary *args) {
                             if (weakSelf.webDialog) {
                                 [weakSelf.webDialog close];
                             }
                             if (_facebookClickHandler != nil) {
                                 _facebookClickHandler(YES);
                             }
                             NSLog(@"personcenter facebook");
                         }];
}

- (void)registGuestCommand {
    __weak IntlWebSession *weakSelf = self;
    [self registForCommandDomain:LOGIN_CENTER_WEB_COMMAND_DOMAIN
                         Command:@"Guest" Handler:^(IntlWebCommandSender *commandSender, NSString *commandDomain, NSString *command, NSDictionary *args) {
                             if (weakSelf.webDialog) {
                                 [weakSelf.webDialog close];
                             }
                             if (_guestClickHandler != nil) {
                                 _guestClickHandler();
                             }
                         }];
}

- (void)registPersonCenterSwitchCommand {
    __weak IntlWebSession *weakSelf = self;
    [self registForCommandDomain:PERSON_CENTER_WEB_COMMAND_DOMAIN
                         Command:@"Switch" Handler:^(IntlWebCommandSender *commandSender, NSString *commandDomain, NSString *command, NSDictionary *args) {
                             if (weakSelf.webDialog) {
                                 [weakSelf.webDialog close];
                             }
                             NSLog(@"Switch Account");
                             [[IntlUserCenter defaultUserCenter].userCenterDelegate onSwitchAccount];
                         }];
}


- (void)registRefreshCommand {
    [self registForCommandDomain:YC_WEB_GENERAL_COMMAND_DOMAIN
                         Command:@"refresh"
                         Handler:^(IntlWebCommandSender *commandSender, NSString *commandDomain, NSString *command, NSDictionary *args) {
                             
                             [commandSender.webView reload];
                             
                             
                         }];
}

- (void)onLoadPageFailed:(IntlWebCommandSender *)sender Error:(NSError *)error {
    if (_loadFailedHandler) {
        _loadFailedHandler(sender,error);
    }
}


#pragma mark -



@end
