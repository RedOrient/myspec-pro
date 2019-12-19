//
//  IntlUserCenterPersistent.h
//  IntlSDK
//
//  Created by Jeol Yu on 2019/11/25.
//  Copyright © 2017年 ycgame. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IntlUserCenterPersistent : NSObject


+ (NSInteger)getDataVersion;

+ (BOOL)getIsAutoLogin;

+ (void)setIsAutoLogin:(BOOL)isAutoLogin;

+ (NSDictionary *)getAccountsJSON;

+ (void)setAccountsJONS:(NSDictionary *)jsonObj;

+ (void)clearAccount;
@end
