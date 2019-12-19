//
//  IntlWebCommandSender.h
//  IntlSDK
//
//  Created by Jeol Yu on 2019/11/25.
//  Copyright © 2019年 ycgame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "IntlWebSession.h"

@interface IntlWebCommandSender()

- (void)redirect:(NSURL *)url;

@property (nonatomic, weak) id<IntlWebPageProtocal> senderWebPage;

@property (nonatomic, weak) WKWebView *webView;

@property (nonatomic, strong) NSString *identity;

@end
