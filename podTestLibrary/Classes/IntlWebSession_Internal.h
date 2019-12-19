//
//  IntlWebSession_Internal.h
//  IntlSDK
//
//  Created by Jeol Yu on 2019/11/25.
//  Copyright © 2019年 ycgame. All rights reserved.
//

#import "IntlWebSession.h"

@interface IntlWebSession ()

@property (nonatomic, strong, readonly) NSMutableDictionary *registedCommandDomain;

+ (void)setCurrentWebSession:(IntlWebSession *)webSession;

- (void)onLoadPageFailed:(IntlWebCommandSender *)sender Error:(NSError *)error;

- (void)onWebDialogOpend:(id<IntlWebPageProtocal>)webDialog;

- (void)onWebPageOpend:(id<IntlWebPageProtocal>)webPage;

- (void)onWebDialogClosed;

- (void)onWebPageClosed;

@end
