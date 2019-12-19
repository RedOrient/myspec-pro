//
//  googleplay.h
//  GoogleFacebookTest
//
//  Created by macmini-compiler on 2019/11/27.
//  Copyright © 2019 macmini-compiler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@import GoogleSignIn;

NS_ASSUME_NONNULL_BEGIN

@interface googleplay : NSObject

//@property(nonatomic, weak) id<GIDSignInDelegate> GidDelegate;

+ (googleplay *)instance;
- (void)init:(UIViewController *)viewController;
- (BOOL)handleURL:(NSURL *)url;
- (void)ApplicationInit;
- (void)signin;
- (void)signout;
@end

NS_ASSUME_NONNULL_END
