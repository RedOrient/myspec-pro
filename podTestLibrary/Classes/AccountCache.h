//
//  AccountCache.h
//  IntlSDK
//
//  Created by macmini-compiler on 2019/12/11.
//  Copyright © 2019 macmini-compiler. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "IntlAccount.h"
NS_ASSUME_NONNULL_BEGIN

@interface AccountCache : NSObject
+(IntlAccount *)loadAccount;
+(void)saveAccount:(IntlAccount *)account;
+(void)clearAccount;
@end

NS_ASSUME_NONNULL_END
