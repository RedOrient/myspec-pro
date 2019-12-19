//
//  IntlWebViewDelegate.m
//  IntlSDK
//
//  Created by Jeol Yu on 2019/11/25.
//  Copyright © 2019年 ycgame. All rights reserved.
//

#import "IntlWebViewDelegate.h"
#import "IntlWebSession_Internal.h"
#import "IntlWebCommandSender_Internal.h"
#import "IntlWebDialogViewController.h"
#import "IntlSDKCommonDefine.h"
#import "IntlSDKToolkit.h"

@interface IntlWebViewDelegate ()

@property (nonatomic, weak) id<IntlWebPageProtocal> webPage;
@end

@implementation IntlWebViewDelegate

- (instancetype)initWithViewController:(id<IntlWebPageProtocal>)webPage {
    self = [super init];
    if (self) {
        self.webPage = webPage;
    }
    return self;
}

- (void)webView:(WKWebView *)webView
decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    NSURL *url = navigationAction.request.URL;
    if ([url.scheme isEqualToString:@"ycwebcommand"]) {
        NSString *commandDomain = url.host;
        NSString *command = url.lastPathComponent;
        
        if (commandDomain && command) {
            if ([[self.webPage getWebSession].registedCommandDomain.allKeys containsObject:commandDomain]) {
                NSDictionary *commands = [[self.webPage getWebSession].registedCommandDomain valueForKey:commandDomain];
                if ([commands.allKeys containsObject:command]) {
                    IntlWebCommandHandler handler = [commands valueForKey:command];
                    if (handler) {
                        NSDictionary *qurayDic = [IntlWebViewDelegate dictionaryFromQuery:url.query usingEncoding:NSUTF8StringEncoding];
                        NSString *identify = [qurayDic valueForKey:@"identity"];
                        IntlWebCommandSender *sender = [[IntlWebCommandSender alloc] initWithSenderWebPage:self.webPage
                                                                                               WebView:webView
                                                                                              Identity:identify];
                        handler(sender, commandDomain, command, qurayDic);
                        
                    }
                }
            }
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.isLoading = YES;
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.isLoading = NO;
    // Disable user selection
    [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';" completionHandler:nil];
    // Disable callout
    [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];

    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [webView stopLoading];
    IntlWebCommandSender *sender = [[IntlWebCommandSender alloc] initWithSenderWebPage:self.webPage
                                                                           WebView:webView
                                                                          Identity:nil];
    
    NSString *url = [error.userInfo valueForKey:@"NSErrorFailingURLStringKey"];
    
    [[self.webPage getWebSession] onLoadPageFailed:sender Error:error];

    self.isLoading = NO;
}


#pragma mark - URL quary string

+ (NSDictionary*)dictionaryFromQuery:(NSString*)query
                       usingEncoding:(NSStringEncoding)encoding {
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[NSScanner alloc] initWithString:query];
    while (![scanner isAtEnd]) {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 2) {
            NSString* key = [[kvPair objectAtIndex:0]
                             stringByReplacingPercentEscapesUsingEncoding:encoding];
            NSString* value = [[kvPair objectAtIndex:1]
                               stringByReplacingPercentEscapesUsingEncoding:encoding];
            [pairs setObject:value forKey:key];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:pairs];
}

+ (NSError *)buildWebViewLoadError:(NSError *)webViewError
                               URL:(NSURL *) url {
    NSString *urlStr = [url absoluteString];
    if (webViewError) {
        NSError *error = [[NSError alloc] initWithDomain:[IntlErrorBuilder getDomainNameByErrorCode:(YC_WEB_PAGE_LOAD_FAILED)]
                                                    code:(YC_WEB_PAGE_LOAD_FAILED)
                                                userInfo:@{@"ErrorCode":@(YC_WEB_PAGE_LOAD_FAILED),
                                                           @"Domain":[IntlErrorBuilder getDomainNameByErrorCode:YC_WEB_PAGE_LOAD_FAILED],
                                                           @"Error":webViewError,
                                                           @"URL":urlStr ? urlStr : EMPTY_NSSTRING
                                                           }];
        return error;
    } else {
        NSError *error = [[NSError alloc] initWithDomain:[IntlErrorBuilder getDomainNameByErrorCode:(YC_WEB_PAGE_LOAD_FAILED)]
                                                    code:(YC_WEB_PAGE_LOAD_FAILED)
                                                userInfo:@{@"ErrorCode":@(YC_WEB_PAGE_LOAD_FAILED),
                                                           @"Domain":[IntlErrorBuilder getDomainNameByErrorCode:YC_WEB_PAGE_LOAD_FAILED],
                                                           @"URL":urlStr ? urlStr : EMPTY_NSSTRING
                                                           }];
        return error;
    }
    
}

- (void)dealloc {
    
}

@end
