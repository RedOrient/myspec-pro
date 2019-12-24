//
//  Intlgameloading.m
//  IntlSDK
//
//  Created by macmini-compiler on 2019/12/17.
//  Copyright © 2019 macmini-compiler. All rights reserved.
//

#import "Intlgameloading.h"

@implementation Intlgameloading

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
static Intlgameloading *_instance;

+ (Intlgameloading *)instance{
    if (_instance == nil) {
        _instance = [[Intlgameloading alloc]init];
    }
    return _instance;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect rect = [[UIScreen mainScreen] bounds];
        // 菊花背景的大小
        self.frame = CGRectMake(kWidth/2-50, KHeight/2-50, rect.size.width/2+rect.origin.x, rect.size.height/2+rect.origin.y);
        // 菊花的背景色
        self.backgroundColor = MYCOLOR;
        self.layer.cornerRadius = 10;
        // 菊花的颜色和格式（白色、白色大、灰色）
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, 80, 40)];
         // 在菊花下面添加文字
        label.text = @"loading...";
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        [self addSubview:label];
    }
    return self;
}

- (void)Show:(UIViewController *)current_view{
    //设置当前界面不可点击
    self.current_view = current_view;
    self.current_view.view.userInteractionEnabled = NO;
    
    [self.current_view.view addSubview:_instance];
    [_instance startAnimating];
}

- (void)Hide{
    //恢复当前界面点击
    self.current_view.view.userInteractionEnabled = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [_instance stopAnimating];
            [_instance removeFromSuperview];        });
    });
}

@end
