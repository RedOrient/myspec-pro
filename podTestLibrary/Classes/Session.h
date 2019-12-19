//
//  Session.h
//  IntlSDK
//
//  Created by macmini-compiler on 2019/12/9.
//  Copyright © 2019 macmini-compiler. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Session : NSObject

+ (Session *)instance;

- (instancetype)initWithChannel:(NSString *)channel
                AuthCode:(NSString *)authcode
                RequestType:(NSString *)request_type;

- (instancetype)initWithChannel:(NSString *)channel
                    AccessToken:(NSString *)access_token;

- (instancetype)initWithDictionary:(NSDictionary *)accountDic;

- (NSDictionary *)getDictionary;

@property (nonatomic, strong) NSString *channel;
@property (nonatomic, strong) NSString *authcode;
@property (nonatomic, strong) NSString *request_type;
@property (nonatomic, strong) NSString *account_id;
@property (nonatomic, strong) NSString *refresh_token;
@property (nonatomic, strong) NSNumber *refresh_token_expire;
@property (nonatomic, strong) NSString *access_token;
@property (nonatomic, strong) NSNumber *access_token_expire;
@end

NS_ASSUME_NONNULL_END
