//
//  AFManager.h
//  IntlSDKDemo
//
//  Created by macmini-compiler on 2019/12/17.
//  Copyright © 2019 macmini-compiler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppsFlyerLib/AppsFlyerTracker.h>

NS_ASSUME_NONNULL_BEGIN

@interface AFManager : NSObject
/**
*   AFManager单例
*/
+ (AFManager *)instance;
/**
 * trackApplaunch           AppsFlyers追踪应用启动方法
 */
- (void)trackApplaunch;
/**
 * ApplicationInit          AppsFlyers初始化方法
 *
 * @param DevKey            AppsFlyers开发者密钥
 * @param AppID             Tunes Connect获得的 app ID
 */
- (void)ApplicationInit:(NSString *)DevKey
             appleAppID:(NSString *)AppID;

/**
 * trackEvent               AppsFlyers追踪事件
 *
 * @param eventName         事件名称
 * @param params            携带参数
 */
- (void)trackEvent:(NSString *)eventName
     eventParamDic:(NSDictionary *)params;
@end

NS_ASSUME_NONNULL_END
