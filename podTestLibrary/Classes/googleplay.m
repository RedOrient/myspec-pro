//
//  googleplay.m
//  GoogleFacebookTest
//
//  Created by macmini-compiler on 2019/11/27.
//  Copyright © 2019 macmini-compiler. All rights reserved.
//

#import "googleplay.h"
#import "IntlSDK.h"

@implementation googleplay

static googleplay *_instance;

+ (googleplay *)instance{
    if (_instance == NULL) {
        _instance = [[googleplay alloc]init];
    }
    return _instance;
}

- (void)ApplicationInit{
    [GIDSignIn sharedInstance].clientID = @"567033707984-5hc6eq3kf4crb8n8radc4oqsr7u5r6rk.apps.googleusercontent.com";
    [GIDSignIn sharedInstance].delegate = self;
}

- (BOOL)handleURL:(NSURL *)url{
    return [[GIDSignIn sharedInstance] handleURL:url];
}

- (void)init:(UIViewController *)viewController{
    [GIDSignIn sharedInstance].presentingViewController = viewController;
    
    // Automatically sign in the user.
    [[GIDSignIn sharedInstance] restorePreviousSignIn];
}

/*
 接收登录回调
 */
- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    if (error != nil) {
        if (error.code == kGIDSignInErrorCodeHasNoAuthInKeychain) {
            NSLog(@"The user has not signed in before or they have since signed out.");
            [[[IntlUserCenter defaultUserCenter] loginDelegate] onLoginError:error.code errorDescription:error.description];
        }
        else if(error.code == kGIDSignInErrorCodeCanceled){
            [[IntlUserCenter defaultUserCenter].loginDelegate onLoginCancel];
        }
        else {
            [[[IntlUserCenter defaultUserCenter] loginDelegate] onLoginError:error.code errorDescription:error.localizedDescription];
        }
        return;
    }
    // Perform any operations on signed in user here.
    NSString *userId = user.userID;                  // For client-side use only!
    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    NSString *fullName = user.profile.name;
    NSString *givenName = user.profile.givenName;
    NSString *familyName = user.profile.familyName;
    NSString *email = user.profile.email;
    // ...
    if(userId != NULL)
    {
        NSLog(@"user id is: ");
        NSLog(userId);
//        [[[IntlUserCenter defaultUserCenter] loginDelegate] onLoginSuccess:idToken];
    }
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
    if(error != nil)
    {
        NSLog(@"%@", error.localizedDescription);
    }
    else
    {
        NSLog(@"error is null");
    }
    NSLog(@"logout success");
}

- (void)signin{
    NSLog(@"google sign in");
    [[GIDSignIn sharedInstance] signIn];
}
- (void)signout{
    GIDGoogleUser *user = [GIDSignIn sharedInstance].currentUser;
    if (user.userID != NULL) {
        NSLog(@"google sign out");
        [[GIDSignIn sharedInstance] signOut];
    }
}
@end
