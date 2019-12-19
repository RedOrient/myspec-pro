//
//  Intlgameloading.h
//  IntlSDK
//
//  Created by macmini-compiler on 2019/12/17.
//  Copyright © 2019 macmini-compiler. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
#define kWidth 375

#define KHeight 667

#define MYCOLOR [UIColor blackColor]

@interface Intlgameloading : UIActivityIndicatorView

+ (Intlgameloading *)instance;

- (void)Show:(UIViewController *)current_view;

- (void)Hide;

@property (nonatomic, strong) UIViewController *current_view;

@end

NS_ASSUME_NONNULL_END
