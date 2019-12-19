//
//  IntlSDKToolKit.h
//  IntlSDK
//
//  Created by Jeol Yu on 2019/11/25.
//  Copyright © 2019年 ycgame. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IntlErrorBuilder : NSObject

+ (NSError *)buildJSONError:(NSError *)jsonError
                 DomainCode:(NSUInteger)domainCode
                 ModuleCode:(NSUInteger)moduleCode;

+ (NSError *)buildJSONError:(NSError *)jsonError
                 DomainCode:(NSUInteger)domainCode
                 ModuleCode:(NSUInteger)moduleCode
                 JSONString:(NSString *)jsonString;

+ (NSError *)buildHttpResponseIncorrectWithHttpCode:(NSUInteger)httpCode
                                         DomainCode:(NSUInteger)domainCode
                                         ModuleCode:(NSUInteger)moduleCode;

+ (NSError *)buildHttpFailError:(NSError *)httpError
                     DomainCode:(NSUInteger)domainCode
                     ModuleCode:(NSUInteger)moduleCode;

+ (NSError *)buildBusyErrorWithDomainCode:(NSUInteger)domainCode
                               ModuleCode:(NSUInteger)modulCodesh;

+ (NSError *)buildError:(NSUInteger)errCode
                Message:(NSString *)message
                  Error:(NSError *)originalError;


+ (NSString *)getDomainNameByErrorCode:(NSUInteger)errorCode;


@end
