//
//  PTLViewController.m
//  podTestLibrary
//
//  Created by yujingliang on 12/18/2019.
//  Copyright (c) 2019 yujingliang. All rights reserved.
//

#import "PTLViewController.h"

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

-(IBAction)init:(id)sender{
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
                       DialogSize:CGSizeMake(414, 319)
          WebSessionClosedHandler:^() {
              NSLog(@"Forceclosed");
          }
               GoogleClickHandler:^() {
                   NSLog(@"Google Click");
                   [[googleplay instance] signin];
               }
             FacebookClickHandler:^(BOOL isBind) {
                 NSLog(@"Facebook Click");
                 [[facebook instance] signin:isBind];
             }
                GuestClickHandler:^() {
                    [[Guest instance] signin];
                }];
    [[googleplay instance] init:self];
    [IntlUserCenter defaultUserCenter].delegate = self;
    [IntlUserCenter defaultUserCenter].loginDelegate = self;
    [IntlUserCenter defaultUserCenter].userCenterDelegate = self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)initClick:(id)sender {
}
- (IBAction)fbLoginClick:(id)sender {
}

@end
