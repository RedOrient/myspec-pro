//
//  IntlWebViewDelegate.h
//  IntlSDK
//
//  Created by Jeol Yu on 2019/11/25.
//  Copyright © 2019年 ycgame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface IntlWebViewDelegate : NSObject <WKNavigationDelegate>

@property (nonatomic, assign) BOOL isLoading;

- (instancetype)initWithViewController:(UIViewController *)viewController;


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation;
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation;
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error;

@end
