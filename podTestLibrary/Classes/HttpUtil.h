//
//  HttpUtil.h
//  IntlSDK
//
//  Created by macmini-compiler on 2019/12/9.
//  Copyright © 2019 macmini-compiler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IntlAccount.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^SuccessCallback)(NSDictionary *responseObject);
typedef void(^FailureCallBack)(NSNumber *errorCode, NSString *errorMessage);

@interface HttpUtil : NSObject
/**
 * 网络请求工具类的单例
 */
+ (HttpUtil *)instance;
/**
 * GET 请求方法
 *
 * @param URLString         请求 URL
 * @param parameters        请求参数
 * @param successCallback   请求成功回调
 * @param failureCallBack   请求失败回调
 */
- (void) GETWithURL: (NSString *)URLString
         parameters: (NSDictionary *)parameters
    successCallback: (SuccessCallback)successCallback
    failureCallBack: (FailureCallBack)failureCallBack;
/**
 * POST 请求方法
 *
 * @param URLString         请求 URL
 * @param parameters        请求参数
 * @param successCallback   请求成功回调
 * @param failureCallBack   请求失败回调
 */
- (void)POSTWithURL: (NSString *)URLString
         parameters: (NSDictionary *)parameters
    successCallback: (SuccessCallback)successCallback
    failureCallBack: (FailureCallBack)failureCallBack;
/**
 * POST 请求方法
 *
 * @param URLString         请求 URL
 * @param header            请求头参数
 * @param parameter         请求参数
 * @param successCallback   请求成功回调
 * @param failureCallBack   请求失败回调
 */
- (void) POSTWithURL: (NSString *)URLString
              Header: (NSDictionary *)header
          parameters: (NSDictionary *)parameter
     successCallback: (SuccessCallback)successCallback
     failureCallBack: (FailureCallBack)failureCallBack;
/**
 * POST 请求方法
 *
 * @param URLString         请求 URL
 * @param account           根据account，增加请求头参数
 * @param parameter         请求参数
 * @param successCallback   请求成功回调
 * @param failureCallBack   请求失败回调
 */
- (void) POSTWithURL: (NSString *)URLString
         IntlAccount: (IntlAccount *)account
          parameters: (NSDictionary *)parameter
     successCallback: (SuccessCallback)successCallback
     failureCallBack: (FailureCallBack)failureCallBack;
@end
NS_ASSUME_NONNULL_END
