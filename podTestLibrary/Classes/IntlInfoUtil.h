//
//  IntlInfoUtil.h
//  IntlSDK
//
//  Created by macmini-compiler on 2019/12/9.
//  Copyright © 2019 macmini-compiler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AdSupport/AdSupport.h>

NS_ASSUME_NONNULL_BEGIN

@interface IntlInfoUtil : NSObject
+ (NSString *) getIDFAIdentifier;

+ (long) getUTCTimeStmp;

@end

NS_ASSUME_NONNULL_END
