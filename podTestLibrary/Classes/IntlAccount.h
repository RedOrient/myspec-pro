//
//  IntlAccount
//  IntlSDK
//
//  Created by Jeol Yu on 2019/11/25.
//  Copyright © 2019年 ycgame. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IntlAccount : NSObject
+ (IntlAccount *)instance;

- (instancetype)initWithUID:(NSString *)uid
                    Channel:(NSString *)channel
                AccessToken:(NSString *)access_token
          AccessTokenExpire:(NSNumber *)access_token_expire
               RefreshToken:(NSString *)refresh_token
         RefreshTokenExpire:(NSNumber *)refresh_token_expire
            FirstAuthorized:(NSNumber *)first_authorize;
- (instancetype)initWithDictionary:(NSDictionary *)accountDic;

- (NSDictionary *)getDictionary;

@property (nonatomic, strong) NSString *channel;
@property (nonatomic, strong) NSString *refresh_token;
@property (nonatomic, strong) NSNumber *refresh_token_expire;
@property (nonatomic, strong) NSString *openid;
@property (nonatomic, strong) NSString *access_token;
@property (nonatomic, strong) NSNumber *access_token_expire;
@property (nonatomic, strong) NSNumber *first_authorize;

@end
