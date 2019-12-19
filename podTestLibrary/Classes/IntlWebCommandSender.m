//
//  IntlWebCommandSender.m
//  IntlSDK
//
//  Created by Jeol Yu on 2019/11/25.
//  Copyright © 2019年 ycgame. All rights reserved.
//

#import "IntlWebCommandSender_Internal.h"

@implementation IntlWebCommandSender

- (instancetype)initWithSenderWebPage:(id<IntlWebPageProtocal>)senderWebPage
                              WebView:(WKWebView *)webView
                             Identity:(NSString *)identity {
    self = [super init];
    if (self) {
        self.senderWebPage = senderWebPage;
        self.webView = webView;
        self.identity = identity;
    }
    return self;
}



- (void)redirect:(NSURL *)url {
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
}

@end
