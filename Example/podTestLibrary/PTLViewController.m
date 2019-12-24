//
//  PTLViewController.m
//  podTestLibrary
//
//  Created by yujingliang on 12/18/2019.
//  Copyright (c) 2019 yujingliang. All rights reserved.
//

#import "PTLViewController.h"
#import "IntlUserCenter.h"
#import "IntlAccount.h"
#import "AccountCache.h"
#import "HttpUtil.h"

@interface PTLViewController ()

@end

@implementation PTLViewController
//登录回调
- (void)onLoginSuccess:(NSString *)openid
           AccessToken:(NSString *)access_token{
    NSLog(@"login success");
    NSLog(@"openid is: %@", openid);
    NSLog(@"access token is: %@", access_token);
    [self UpdateUI:@"登录成功"];
}

- (void)onLoginError:(NSNumber *)errorCode
    errorDescription:(NSString *)errorDes{
    NSLog(@"login error");
    NSLog(@"error code is : %@", errorCode);
    NSLog(@"error description is : %@", errorDes);
    NSString *message = [NSString stringWithFormat:@"登录失败 Cd:%@ Msg:%@",errorCode,errorDes];
    [self UpdateUI:message];
}

- (void)onLoginCancel{
    NSLog(@"Login Cancelled");
    [self UpdateUI:@"登录取消"];
    
}

//用户中心回调
- (void)onBindSuccess{
    [self UpdateUI:@"绑定成功"];
}

- (void)onBindCancel{
    [self UpdateUI:@"绑定取消"];
}

- (void)onBindError:(NSNumber *)errorCode
   errorDescription:(NSString *)errorDes{
    NSLog(@"error code is : %@", errorCode);
    NSLog(@"error description is : %@", errorDes);
    NSString *message = [NSString stringWithFormat:@"绑定失败 Cd:%@ Msg:%@",errorCode,errorDes];
    [self UpdateUI:message];
}

- (void)onSwitchAccount{
    [self UpdateUI:@"切换账号，之后游戏需要调用logot并且再次login"];
    //登出
    [[IntlUserCenter defaultUserCenter] logout];
    //重新登入
    [[IntlUserCenter defaultUserCenter] LoginCenter:self];
}

- (void)afterLogin:(NSString *)uid SID:(NSString *)sid {
    NSString *message = [NSString stringWithFormat:@"进入游戏:%@",sid];
    [self UpdateUI:message];
}

- (void)afterLogout {
    [self UpdateUI:@"登出成功"];
    
    NSLog(@"Logout success");
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.UI = [[UILabel alloc] init];
    self.UI.text = @"";
    self.UI.textAlignment = NSTextAlignmentLeft;
    self.UI.frame = CGRectMake(0, 170, 350, 160);
    [self.view addSubview:self.UI];
}

- (IBAction)initClick:(id)sender {
    [self UpdateUI:@"初始化成功"];
    
    NSURL *url = [[NSURL alloc] initWithString:@"https://gather-auth.ycgame.com"];
    [IntlUserCenter initWithAppID:@"sdfsfd"
                           AppVer:@"11"
                         DeviceID:@""
                         Language:@"zh-cn"
                 UIViewController:self
                 FacebookClientID:@"490540961555046"
                       GPClientID:@"7453817292517158"
                         GPSecret:@"EVWHPXxGEOXzbjfWxhUp4yOYgTMSJDNA"
                      LoginWebURL:url
                       DialogSize:CGSizeMake(520, 319)];
    [IntlUserCenter defaultUserCenter].delegate = self;
    [IntlUserCenter defaultUserCenter].loginDelegate = self;
    [IntlUserCenter defaultUserCenter].userCenterDelegate = self;
}

- (IBAction)fbLoginClick:(id)sender {
    [[IntlUserCenter defaultUserCenter] LoginCenter:self];
}

- (IBAction)logout:(id)sender {
    [[IntlUserCenter defaultUserCenter] logout];
}

- (IBAction)usercenter:(id)sender {
    [[IntlUserCenter defaultUserCenter] UserCenter:self];
}
- (IBAction)enterGame:(id)sender {
    IntlAccount *account = [AccountCache loadAccount];
    if (!account) {
        return;
    }
    NSLog(@"enter game account is--%@",account);
    NSDictionary *diction = [NSDictionary dictionaryWithObjectsAndKeys:
                             account.openid,@"openid",
                             account.access_token,@"access_token",
                             nil];
    NSString *url = @"http://pss-i.ycgame.com/member.ashx?q=3auth_n&ch=agl&did=99000736614286";
    //登录验证
    [[HttpUtil instance] POSTWithURL:url
                          parameters:diction
                     successCallback:^(NSDictionary *data){
                         NSLog(@"enter game success--%@",data);
                         [[[IntlUserCenter defaultUserCenter] delegate] afterLogin:@"" SID:data];
                     } failureCallBack:^(NSNumber *errorCode, NSString *errorMessage){
                         NSLog(@"enter game failed--%@", errorMessage);
                         [[[IntlUserCenter defaultUserCenter] delegate] afterLogin:@"" SID:errorMessage];
                     }];
}

-(void)UpdateUI:(NSString *)msg{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.UI.text = msg;
        });
    });
}
@end
