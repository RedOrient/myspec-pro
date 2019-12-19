//
//  IntlSDKGameTool.m
//  IntlSDK
//
//  Created by macmini-compiler on 2019/12/10.
//  Copyright © 2019 macmini-compiler. All rights reserved.
//

#import "IntlSDKGameTool.h"

@implementation IntlSDKGameTool
+ (void)showNotification:(NSString *)Msg {
    UIAlertView *box= [[UIAlertView alloc] initWithTitle:@"提示" message:Msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [box show];
}
@end
