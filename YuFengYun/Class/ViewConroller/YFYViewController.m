//
//  YFYViewController.m
//  JingXiang
//
//  Created by 董德富 on 13-2-1.
//
//

#import "YFYViewController.h"
#import "MBProgressHUD.h"
#import "UMSocial.h"


@interface LoadingView : UIImageView
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UILabel *refreshLabel;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@end


@interface YFYViewController ()
@property (nonatomic, readwrite, strong) CustomNavigationBar *navigationBar;
@property (nonatomic, strong) MBProgressHUD *loadingHUD;
@property (nonatomic, strong) LoadingView *loadingView;
@end

@implementation YFYViewController

#pragma mark - public
- (id)initFromNib {
    self = [super initWithNibName:NSStringFromClass(self.class) bundle:nil];
    if (self) {
        
    }
    return self;
}
- (void)setNavigationBarHidden:(BOOL)navigationBarHidden {
    if (_navigationBarHidden != navigationBarHidden || !self.navigationBar) {
        if (navigationBarHidden) {
            [self.navigationBar removeFromSuperview];
            self.navigationBar = nil;
        }else {
            CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, 44);
            if (SYSTEM_VERSION_MOER_THAN_7) {
                rect.size.height = 64;
            }
            self.navigationBar = [[CustomNavigationBar alloc] initWithFrame:rect];
            [self.view addSubview:self.navigationBar];
        }
        _navigationBarHidden = navigationBarHidden;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.navigationController) {
        self.navigationBarHidden = NO;
    }
    
    IOS7;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (SYSTEM_VERSION_MOER_THAN_7) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

- (void)showLoadingViewBelow:(UIView *)theView {
    
    self.loadingView = [[LoadingView alloc] init];
    self.loadingView.tapGesture.enabled = NO;
    //    self.loadingView.activityView.hidden = NO;
    [self.loadingView.activityView startAnimating];
    self.loadingView.refreshLabel.hidden = YES;
    
    if (theView) {
        [self.view insertSubview:self.loadingView belowSubview:theView];
    }else {
        [self.view insertSubview:self.loadingView belowSubview:self.navigationBar];
    }
}
- (void)hideLoadingView {
    if (self.loadingView) {
        [UIView animateWithDuration:.3 animations:^{
            self.loadingView.alpha = .2;
        } completion:^(BOOL finished) {
            [self.loadingView removeFromSuperview];
            self.loadingView = nil;
        }];
    }
}
- (void)setLoadingFail {
    if (!self.loadingView) {
        self.loadingView = [[LoadingView alloc] init];
        [self.view insertSubview:self.loadingView belowSubview:self.navigationBar];
    }
    
    [self.loadingView.activityView stopAnimating];
    self.loadingView.refreshLabel.hidden = NO;
    self.loadingView.tapGesture.enabled = YES;
    
    [self.loadingView.tapGesture addTarget:self action:@selector(tapGesture:)];
}
- (void)tapGesture:(id)sender {
    [self.loadingView.activityView startAnimating];
    self.loadingView.refreshLabel.hidden = YES;
    self.loadingView.tapGesture.enabled = NO;
    
    [self clickLoadingViewToRefresh];
}
- (void)clickLoadingViewToRefresh {
    //do refresh in child vc
}


- (void)showHUDTitle:(NSString *)title {
    if (self.loadingHUD && self.loadingHUD.superview && self.loadingHUD.mode == MBProgressHUDModeIndeterminate) {
        self.loadingHUD.labelText = title;//title ? title : @"加载中...";
        return;
    }
    [self.loadingHUD hide:NO];
    self.loadingHUD = nil;
    
    self.loadingHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.loadingHUD.labelText = title;//title ? title : @"加载中...";
    self.loadingHUD.labelFont = [UIFont boldSystemFontOfSize:13];
    self.loadingHUD.removeFromSuperViewOnHide = YES;
}
- (void)hideHUD:(NSTimeInterval)delay {
    if (self.loadingHUD) {
        if (delay == 0) {
            [self.loadingHUD hide:YES];
        }else {
            [self.loadingHUD hide:YES afterDelay:delay];
        }
        self.loadingHUD = nil;
    }
}

#pragma mark - memory
- (void)viewDidUnload {
    [super viewDidUnload];
    self.navigationBar = nil;
    self.loadingView = nil;
    self.loadingHUD = nil;
    [self clearMemory];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0f) {
        if ([self isViewLoaded] && [self.view window] == nil) {
            self.navigationBar = nil;
            self.loadingView = nil;
            self.loadingHUD = nil;
            [self clearMemory];
            self.view = nil;
        }
    }
#endif
}
- (void)clearMemory {
    
}


@end

@implementation YFYViewController (customNav)
- (UIButton *)setNavigationBarWithImageName:(NSString *)imageName
                                     target:(id)target
                                     action:(SEL)action
                                   position:(CustomNavigationBarPosition)position {
//    UIImage *image = UIIMAGE_FILE(image);
    UIImage *image = [UIImage imageNamed:imageName];
    CGSize size = image.size;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, size.width, size.height);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    if (position == CustomNavigationBarPositionLeft) {
        self.navigationBar.leftBarButton = button;
    }else {
        self.navigationBar.rightBarButton = button;
    }
    return button;
}
- (void)setBackNavigationBarWithTarget:(id)target action:(SEL)action {
    [self setNavigationBarWithImageName:@"nav_back.png"
                                 target:target
                                 action:action
                               position:CustomNavigationBarPositionLeft];
}
- (void)setBackNavButtonActionPop {
    [self setBackNavigationBarWithTarget:self action:@selector(backActionPop)];
}
- (void)setBackNavButtonActionDismiss {
    [self setBackNavigationBarWithTarget:self action:@selector(backActionDismiss)];
}
- (void)backActionPop {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)backActionDismiss {
    [self dismissModalViewControllerAnimated:YES];
}

@end


@implementation CustomNavigationBar

#pragma mark - init & fram perset

- (void)setLeftBarButton:(UIButton *)leftBarButton {
    if (_leftBarButton) {
        [_leftBarButton removeFromSuperview];
        _leftBarButton = nil;
    }
    CGRect rect = leftBarButton.frame;
    
    if (rect.size.height > 44) {
        rect.size.width *= 44 / rect.size.height;
        rect.size.height = 44;
    }
    rect.origin = CGPointMake(0, self.frame.size.height-rect.size.height);
    
    leftBarButton.frame = rect;
    [self addSubview:leftBarButton];
    _leftBarButton = leftBarButton;
}
- (void)setRightBarButton:(UIButton *)rightBarButton {
    if (_rightBarButton) {
        [_rightBarButton removeFromSuperview];
        _rightBarButton = nil;
    }
    CGRect rect = rightBarButton.frame;
    if (rect.size.height > 44) {
        rect.size.width *= 44 / rect.size.height;
        rect.size.height = 44;
    }
    rect.origin = CGPointMake(self.frame.size.width - rect.size.width, self.frame.size.height-rect.size.height);
    
    rightBarButton.frame = rect;
    [self addSubview:rightBarButton];
    _rightBarButton = rightBarButton;
}
- (void)setTitleView:(UIView *)titleView {
    if (_titleLabel) {
        [_titleLabel removeFromSuperview];
        _titleLabel = nil;
    }
    if (_titleView) {
        [_titleView removeFromSuperview];
        _titleView = nil;
    }
    [self addSubview:titleView];
    _titleView = titleView;
    
    if (SYSTEM_VERSION_MOER_THAN_7) {
        titleView.center = CGPointMake(self.center.x, 20+22);
    }else {
        titleView.center = self.center;
    }
}
- (void)setTitle:(NSString *)title {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height-44, 200, 44)];
        _titleLabel.center = CGPointMake(self.center.x, _titleLabel.center.y);
        _titleLabel.text = title;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = UITextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:20];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
    }
    _titleLabel.text = title;
    _title = title;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kRGBAColor(0, 147, 218, .99);
//        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextAddRect(context, rect);
//    [kRGBColor(40, 170, 220) setFill];
//    CGContextDrawPath(context, kCGPathFill);
    
//    UIImage *backImage = [[UIImage imageNamed:@"nav_background.png"] resizableImageWithCapInsets:UIEdgeInsetsZero];
//    [backImage drawInRect:rect];
}

@end


@implementation LoadingView

- (id)init {
    self = [super init];
    if (self) {
        CGRect frame = [UIScreen mainScreen].applicationFrame;
        if (SYSTEM_VERSION_MOER_THAN_7) {
            frame = [UIScreen mainScreen].bounds;
        }
        frame.origin = CGPointZero;
        self.frame = frame;
        self.userInteractionEnabled = YES;
        
        BOOL is4Screen = frame.size.height > 480;
        
        if (is4Screen) {
            self.image = [UIImage imageNamed:@"loading_back_4.png"];
        } else {
            self.image = [UIImage imageNamed:@"loading_back_35.png"];
        }
        
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityView.center = CGPointMake(self.center.x, is4Screen?290:260);
        [self addSubview:self.activityView];
        
        self.refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, is4Screen?270:240, 120, 40)];
        self.refreshLabel.backgroundColor = [UIColor clearColor];
        self.refreshLabel.text = @"点击屏幕，重新加载";
        self.refreshLabel.textAlignment = UITextAlignmentCenter;
        self.refreshLabel.textColor = [UIColor colorWithWhite:.3 alpha:1];
        self.refreshLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.refreshLabel];
        
        self.tapGesture = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:self.tapGesture];
    }
    return self;
}


@end


@implementation UIViewController (UMengSocial)

- (void)shareUmengWithString:(NSString *)sendString image:(UIImage *)image url:(NSString *)url delegate:(id)delegate {
    
    NSArray *shareTo = @[UMShareToSina,
                         UMShareToTencent,
                         UMShareToEmail,
                         UMShareToSms,
                         UMShareToWechatSession,
                         UMShareToWechatTimeline,
                         UMShareToQQ,
                         UMShareToQzone];
    //如果得到分享完成回调，需要传递delegate参数
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:kUMAppKey
                                      shareText:sendString
                                     shareImage:image
                                shareToSnsNames:shareTo
                                       delegate:delegate];
    
    UMSocialExtConfig *config = [UMSocialData defaultData].extConfig;
    /**
     *  微信,朋友圈
     */
    config.wechatSessionData.url = url;
    config.wechatSessionData.wxMessageType = UMSocialWXMessageTypeWeb;
    
    config.wechatTimelineData.url = url;
    config.wechatTimelineData.wxMessageType = UMSocialWXMessageTypeWeb;
    
    /**
     *  qqZone QQ
     */
    config.qqData.url = url;
    
    config.qzoneData.url = url;    
}

@end

