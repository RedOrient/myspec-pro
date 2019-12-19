//
//  IntlSDKToolKit.m
//  IntlSDK
//
//  Created by Jeol Yu on 2019/11/25.
//  Copyright © 2019年 ycgame. All rights reserved.
//

#import "IntlSDKToolkit.h"
#import "IntlSDKCommonDefine.h"

@implementation IntlErrorBuilder



+ (NSError *)buildJSONError:(NSError *)jsonError
                 DomainCode:(NSUInteger)domainCode
                 ModuleCode:(NSUInteger)moduleCode
{
    NSInteger errCode = domainCode | moduleCode | YC_SDK_JSON_INCORRECT;
    if (jsonError)
    {
        NSError *error = [[NSError alloc] initWithDomain:[IntlErrorBuilder getDomainNameByErrorCode:errCode]
                                                    code:errCode
                                                userInfo:@{@"ErrorCode":@(errCode),
                                                           @"Domain":[IntlErrorBuilder getDomainNameByErrorCode:errCode],
                                                           @"Error":jsonError
                                                           }];
        return error;
    } else
    {
        NSError *error = [[NSError alloc] initWithDomain:[IntlErrorBuilder getDomainNameByErrorCode:errCode]
                                                    code:errCode
                                                userInfo:@{@"ErrorCode":@(errCode),
                                                           @"Domain":[IntlErrorBuilder getDomainNameByErrorCode:errCode]                                                           }];
        return error;
    }
}

+ (NSError *)buildJSONError:(NSError *)jsonError
                 DomainCode:(NSUInteger)domainCode
                 ModuleCode:(NSUInteger)moduleCode
                 JSONString:(NSString *)jsonString
{
    NSInteger errCode = domainCode | moduleCode | YC_SDK_JSON_INCORRECT;
    if (jsonError)
    {
        NSError *error = [[NSError alloc] initWithDomain:[IntlErrorBuilder getDomainNameByErrorCode:errCode]
                                                    code:errCode
                                                userInfo:@{@"ErrorCode":@(errCode),
                                                           @"Domain":[IntlErrorBuilder getDomainNameByErrorCode:errCode],
                                                           @"Error":jsonError,
                                                           @"JSONString":jsonError ? jsonError : EMPTY_NSSTRING
                                                           }];
        return error;
    } else
    {
        NSError *error = [[NSError alloc] initWithDomain:[IntlErrorBuilder getDomainNameByErrorCode:errCode]
                                                    code:errCode
                                                userInfo:@{@"ErrorCode":@(errCode),
                                                           @"Domain":[IntlErrorBuilder getDomainNameByErrorCode:errCode],
                                                           @"JSONString":jsonError ? jsonError : EMPTY_NSSTRING
                                                           }];
        return error;
    }
}

+ (NSError *)buildHttpResponseIncorrectWithHttpCode:(NSUInteger)httpCode
                                         DomainCode:(NSUInteger)domainCode
                                         ModuleCode:(NSUInteger)moduleCode
{
    NSInteger errCode = domainCode | moduleCode | YC_SDK_HTTP_RESPONSE_INCORRECT;
    NSError *error = [[NSError alloc] initWithDomain:[IntlErrorBuilder getDomainNameByErrorCode:errCode]
                                                code:errCode
                                            userInfo:@{@"ErrorCode":@(errCode),
                                                       @"Domain":[IntlErrorBuilder getDomainNameByErrorCode:errCode],
                                                       @"HttpCode":@(httpCode)
                                                       }];
    return error;
}

+ (NSError *)buildHttpFailError:(NSError *)httpError
                        DomainCode:(NSUInteger)domainCode
                     ModuleCode:(NSUInteger)moduleCode
{
    NSInteger errCode =domainCode | moduleCode | YC_SDK_HTTP_FAIL;
    if (httpError)
    {
        NSError *error = [[NSError alloc] initWithDomain:[IntlErrorBuilder getDomainNameByErrorCode:errCode]
                                                    code:errCode
                                                userInfo:@{@"ErrorCode":@(errCode),
                                                           @"Domain":[IntlErrorBuilder getDomainNameByErrorCode:errCode],
                                                           @"Error":httpError
                                                           }];
        return error;
    } else
    {
        NSError *error = [[NSError alloc] initWithDomain:[IntlErrorBuilder getDomainNameByErrorCode:errCode]
                                                    code:errCode
                                                userInfo:@{@"ErrorCode":@(errCode),
                                                           @"Domain":[IntlErrorBuilder getDomainNameByErrorCode:errCode]\
                                                           }];
        return error;
    }
}


+ (NSError *)buildBusyErrorWithDomainCode:(NSUInteger)domainCode
                               ModuleCode:(NSUInteger)modulCode
{
    NSInteger errCode = domainCode| modulCode | YC_SDK_BUSY;
    NSError *error = [[NSError alloc] initWithDomain:[IntlErrorBuilder getDomainNameByErrorCode:errCode]
                                                code:errCode
                                            userInfo:@{@"ErrorCode":@(errCode),
                                                       @"Domain":[IntlErrorBuilder getDomainNameByErrorCode:errCode],
                                                       @"NSDebugDescription":@"SDK is busy."
                                                       }];
    return error;
}

+ (NSError *)buildError:(NSUInteger)errCode
                Message:(NSString *)message
                  Error:(NSError *)originalError
{
    if (originalError)
    {
        NSError *error = [[NSError alloc] initWithDomain:[IntlErrorBuilder getDomainNameByErrorCode:errCode]
                                                    code:errCode
                                                userInfo:@{@"ErrorCode":@(errCode),
                                                           @"Domain":[IntlErrorBuilder getDomainNameByErrorCode:errCode],
                                                           @"Error":originalError,
                                                           @"NSDebugDescription":message ? message : EMPTY_NSSTRING
                                                           }];
        return error;
    } else
    {
        NSError *error = [[NSError alloc] initWithDomain:[IntlErrorBuilder getDomainNameByErrorCode:errCode]
                                                    code:errCode
                                                userInfo:@{@"ErrorCode":@(errCode),
                                                           @"Domain":[IntlErrorBuilder getDomainNameByErrorCode:errCode],
                                                           @"NSDebugDescription":message ? message : EMPTY_NSSTRING
                                                           }];
        return error;
    }

}




+ (NSString *)getDomainNameByErrorCode:(NSUInteger)errorCode
{
    NSUInteger domainCode = errorCode & YC_SDK_DOMAIN_MASK;
    switch (domainCode) {
        case YC_SDK_SDK_DOMAIN:
            return YCSDKDomain;
            break;
        case YC_SDK_NOTIFICATION_DOMAIN:
            return YCSDKNotificationDomain;
            break;
        case YC_SDK_IAP_DOMAIN:
            return YCSDKIAPDomain;
            break;
        case YC_SDK_SHARE_DOMAIN:
            return YCSDKShareDomain;
        case YC_SDK_MEDIA_LIBRARY_DOMAIN:
            return YCSDKMeidaLibraryDomain;
        default:
            return YCUnknowDomain;
            break;
    }
}

@end
