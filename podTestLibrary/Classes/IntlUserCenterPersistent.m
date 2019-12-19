//
//  IntlUserCenterPersistent.h
//  IntlSDK
//
//  Created by Jeol Yu on 2019/11/25.
//  Copyright © 2017年 ycgame. All rights reserved.
//

#import "IntlUserCenterPersistent.h"
#import "IntlSDKToolkit.h"
#import "IntlSDKCommonDefine.h"

#define YC_CURRENT_MODULE_CODE  YC_SDK_USER_CENTER_PRESISTENT_MODULE
#define YC_CURRENT_DOMAIN_CODE  YC_SDK_USER_CENTER_DOMAIN

#define YC_USER_CENTER_DATA_VERSION     1

@interface IntlUserCenterPersistent ()

@property (nonatomic, strong) NSString *filePath;

@property (nonatomic, assign) NSUInteger dataVersion;

@end

@implementation IntlUserCenterPersistent


+ (NSInteger)getDataVersion {
    return [[[NSUserDefaults standardUserDefaults] valueForKeyPath:@"INTL_USERCENTER_DATA/version"] integerValue];
}

+ (BOOL)getIsAutoLogin {
    return [[[NSUserDefaults standardUserDefaults] valueForKeyPath:@"INTL_USERCENTER_DATA/isautologin"] boolValue];
}

+ (void)setIsAutoLogin:(BOOL)isAutoLogin {
    [[NSUserDefaults standardUserDefaults] setBool:isAutoLogin forKey:@"INTL_USERCENTER_DATA/isautologin"];
}

+ (NSDictionary *)getAccountsJSON {
    NSString *jsonString = [[NSUserDefaults standardUserDefaults] valueForKey:@"INTL_USERCENTER_DATA/accounts"];
    NSError * error = nil;
    if (jsonString) {
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
        if (error) {
        }
        return jsonDic;
    } else {
        return nil;
    }
}

+ (void)setAccountsJONS:(NSDictionary *)jsonObj {
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonObj options:0 error:&error];
    if (error) {

        return;
    }
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [[NSUserDefaults standardUserDefaults] setValue:jsonStr forKey:@"INTL_USERCENTER_DATA/accounts"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)clearAccount{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"INTL_USERCENTER_DATA/accounts"];
    [userDefaults synchronize];
}
@end
