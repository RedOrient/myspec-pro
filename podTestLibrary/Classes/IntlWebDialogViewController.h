//
//  IntlWebDialogViewController.h
//  IntlSDK
//
//  Created by Jeol Yu on 2019/11/25.
//  Copyright © 2019年 ycgame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "IntlWebSession.h"
@interface IntlWebDialogViewController : UIViewController <IntlWebPageProtocal>


- (instancetype)initFullScreenWithURL:(NSURL*)url
                           WebSession:(IntlWebSession *)webSession;

- (instancetype)initWithWebViewSize:(CGSize)size
                            WithURL:(NSURL*)url
                         WebSession:(IntlWebSession *)webSession;

- (void)setSize:(CGSize)size;

- (void)setFullScreen;


- (IntlWebSession *)getWebSession;

- (void)close;
@end
