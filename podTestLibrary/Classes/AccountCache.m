//
//  AccountCache.m
//  IntlSDK
//
//  Created by macmini-compiler on 2019/12/11.
//  Copyright © 2019 macmini-compiler. All rights reserved.
//

#import "AccountCache.h"
#import "IntlUserCenterPersistent.h"

@implementation AccountCache
+(IntlAccount *)loadAccount{
    NSDictionary *jsonObj = [IntlUserCenterPersistent getAccountsJSON];
    if (!jsonObj) {
        return nil;
    }
    IntlAccount *account = [[IntlAccount alloc] initWithDictionary:jsonObj];
    return account;
}

+(void)saveAccount:(IntlAccount *)account{
    if (!account) {
        return;
    }
    NSDictionary *jsonObj = [account getDictionary];
    [IntlUserCenterPersistent setAccountsJONS:jsonObj];
}

+(void)clearAccount{
    [IntlUserCenterPersistent clearAccount];
}
@end
