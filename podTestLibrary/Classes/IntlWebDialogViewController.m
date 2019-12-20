//
//  IntlWebDialogViewController.m
//  IntlSDK
//
//  Created by Jeol Yu on 2019/11/25.
//  Copyright © 2019年 ycgame. All rights reserved.
//

#import "IntlWebDialogViewController.h"
#import "IntlWebSession_Internal.h"
#import "IntlWebViewDelegate.h"

@interface IntlWebDialogViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *dialogView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicatorView;

@property (strong, nonatomic) WKWebView *wkWebView;

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) IntlWebViewDelegate *webViewDelegate;
@property (nonatomic, assign) BOOL isFullScreen;
@property (nonatomic, assign) CGSize webViewSize;

@property (nonatomic, weak) IntlWebSession *webSession;

@end

@implementation IntlWebDialogViewController

- (instancetype)initFullScreenWithURL:(NSURL*)url
                           WebSession:(IntlWebSession *)webSession {
    NSBundle *xib = [NSBundle bundleForClass:[self class]];
    self = [super initWithNibName:@"IntlWebDialogViewController" bundle:[NSBundle bundleForClass:xib]];
    if (self) {
        [super awakeFromNib];
        self.url = url;
        self.isFullScreen = true;
        self.webSession = webSession;
        [self.webSession onWebDialogOpend:self];
    }
    return self;

    
}

- (instancetype)initWithWebViewSize:(CGSize)size
                            WithURL:(NSURL*)url
                         WebSession:(IntlWebSession *)webSession {
    NSBundle *xib = [NSBundle bundleForClass:[self class]];
    self = [super initWithNibName:@"IntlWebDialogViewController" bundle:[NSBundle bundleForClass:xib]];

    if (self) {
        [super awakeFromNib];
        self.url = url;
        self.webViewSize = size;
        self.isFullScreen = false;
        self.webSession = webSession;
        [self.webSession onWebDialogOpend:self];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.loadingIndicatorView.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    self.wkWebView = [[WKWebView alloc] init];
    [self.dialogView insertSubview:self.wkWebView belowSubview:self.loadingIndicatorView];
    [self.wkWebView.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.wkWebView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.wkWebView.superview attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.wkWebView.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.wkWebView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.wkWebView.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self.wkWebView.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.wkWebView.superview attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.wkWebView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [self.wkWebView.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.wkWebView.superview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.wkWebView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    self.wkWebView.translatesAutoresizingMaskIntoConstraints = false;
    [self.view setNeedsUpdateConstraints];
    [self.wkWebView setNeedsUpdateConstraints];
    [self.view setNeedsLayout];
    [self.wkWebView setNeedsLayout];
    
    if (self.isFullScreen) {
        [self setFullScreen];
    } else {
        [self setSize:self.webViewSize];
    }
    
    self.wkWebView.scrollView.bouncesZoom = NO;
    [self.wkWebView.scrollView setScrollEnabled:YES];
    self.wkWebView.scrollView.bounces = NO;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    self.webViewDelegate = [[IntlWebViewDelegate alloc] initWithViewController:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceDidRotateSelector:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    [self.webViewDelegate addObserver:self forKeyPath:@"isLoading"
                              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                              context:nil];
    
    
    self.wkWebView.navigationDelegate = self.webViewDelegate;
    [self.wkWebView loadRequest:request];
}



- (void)setSize:(CGSize)size {
    self.webViewWidthConstraint.constant = size.width ;
    self.webViewHeightConstraint.constant = size.height ;
    
    [self.view layoutIfNeeded];
    self.isFullScreen = NO;
    self.webViewSize = size;
}



- (void)setFullScreen {
    
    self.webViewWidthConstraint.constant = [UIScreen mainScreen].bounds.size.width - 20;
    self.webViewHeightConstraint.constant = [UIScreen mainScreen].bounds.size.height - 20;

    [self.view layoutIfNeeded];
    self.isFullScreen = YES;
    self.webViewSize = CGSizeZero;
}


- (void)deviceDidRotateSelector:(NSNotification*) notification {
    // respond to rotation here
    if (self.isFullScreen) {
        [self setFullScreen];
    }
    NSInteger ycOrientation = 0;
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait ||
        [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown) {
        ycOrientation = 1;
        
    } else if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft ||
               [[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight) {
        ycOrientation = 2;
    }
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (self.wkWebView.loading) {
        [self.loadingIndicatorView startAnimating];
        self.loadingIndicatorView.hidden = NO;
    } else {
        self.loadingIndicatorView.hidden = YES;
        [self.loadingIndicatorView stopAnimating];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    [self.webViewDelegate removeObserver:self forKeyPath:@"isLoading"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (IntlWebSession *)getWebSession {
    return self.webSession;
}



- (void)close {
        if (self.navigationController.childViewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController.view removeFromSuperview];
        [self.navigationController removeFromParentViewController];
    }
    [self.webSession onWebDialogClosed];
}




/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
