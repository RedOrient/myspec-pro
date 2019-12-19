//
//  Guest.h
//  IntlSDKDemo
//
//  Created by macmini-compiler on 2019/12/9.
//  Copyright © 2019 macmini-compiler. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Guest : NSObject

+ (Guest *)instance;

- (void)signin;

- (void)signout;

@property (nonatomic, strong) UIViewController *current_view;

@end

NS_ASSUME_NONNULL_END
