//
//  facebook.h
//  GoogleFacebookTest
//
//  Created by macmini-compiler on 2019/11/27.
//  Copyright © 2019 macmini-compiler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface facebook : NSObject
+ (facebook *)instance;
- (void)ApplicationInit:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (BOOL)handleURL:(UIApplication *)application
          openURL:(NSURL *)url
          options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options;

- (BOOL)handleURL:(UIApplication *)application
          openURL:(NSURL *)url
sourceApplication:(NSString *)sourceApplication
       annotation:(id)annotation;

- (void)signin:(BOOL)isBind;

- (void)signout;

@property (nonatomic, strong) UIViewController *current_view;
@end

NS_ASSUME_NONNULL_END
