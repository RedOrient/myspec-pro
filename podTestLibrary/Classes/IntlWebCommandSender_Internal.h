//
//  IntlWebCommandSender_Internal.h
//  IntlSDK
//
//  Created by Jeol Yu on 2019/11/25.
//  Copyright © 2019年 ycgame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IntlWebCommandSender.h"

@interface IntlWebCommandSender ()


- (instancetype)initWithSenderWebPage:(id<IntlWebPageProtocal>)senderWebPage
                              WebView:(WKWebView *)webView
                             Identity:(NSString *)identity;

@end
