//
//  AlertHUDView.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-10-18.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "AlertHUDView.h"
#import "AppDelegate.h"

#define kImageWidth 35

@interface AlertHUDView () {
    BOOL _showing;
    NSTimer *_timer;
}
@property (nonatomic, weak) UIWindow *window;

@property (nonatomic, strong) UIView *hudView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *lable;
@end

@implementation AlertHUDView


+ (id)hud {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{instance = [[self alloc] init];});
    return instance;
}


- (id)init {
    self = [super init];
    if (self) {
        AppDelegate *app = APP_DELEGATE;
        self.window = app.window;
        self.frame = [UIScreen mainScreen].applicationFrame;
        self.backgroundColor = [UIColor clearColor];
        [self.window addSubview:self];
        self.userInteractionEnabled = NO;
        
        float screenHeight = [UIScreen mainScreen].bounds.size.height;
        float orginY = (screenHeight > 480) ? 190 : 160;
        self.hudView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width, orginY, 140, 75)];
        self.hudView.backgroundColor = [UIColor colorWithWhite:0 alpha:.9];
        self.hudView.userInteractionEnabled = NO;
        [self addSubview:self.hudView];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.hudView.frame.size.width-kImageWidth)*.5,
                                                                       8, kImageWidth, kImageWidth)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.hudView addSubview:self.imageView];
        
        self.lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 120, 30)];
        self.lable.textColor = [UIColor whiteColor];
        self.lable.backgroundColor = [UIColor clearColor];
        self.lable.textAlignment = UITextAlignmentCenter;
        self.lable.font = [UIFont systemFontOfSize:16];
        self.lable.numberOfLines = 0;
        self.lable.minimumFontSize = 14;
        [self.hudView addSubview:self.lable];
    }
    return self;
}

- (void)showText:(NSString *)text {
    [self showText:text image:nil autoHide:YES];
}
- (void)showFaceText:(NSString *)text {
    [self showText:text image:[UIImage imageNamed:@"face_fail.png"] autoHide:YES];
}
- (void)showText:(NSString *)text image:(UIImage *)image autoHide:(BOOL)autoHide {
    if (!text && !image) return;
    
    [self.window bringSubviewToFront:self];
    self.lable.text = text;
    self.lable.center = CGPointMake(self.hudView.frame.size.width*.5, self.hudView.frame.size.height*.5);
    if (image) {
        self.imageView.hidden = NO;
        self.imageView.image = image;
        CGSize size = image.size;
        if (size.width < kImageWidth && size.height < kImageWidth) {
            self.imageView.contentMode = UIViewContentModeCenter;
        }else {
            self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        }
//        self.imageView.frame = CGRectMake((self.hudView.frame.size.width-kImageWidth)*.5, 8, kImageWidth, kImageWidth);
        self.lable.frame = CGRectMake(10, 0, 120, 30);
        self.lable.center = CGPointMake(self.lable.center.x, 55);
    } else {
        self.imageView.hidden = YES;
        self.lable.frame = CGRectInset(self.hudView.bounds, 10, 10);
    }
    
    CGRect frame = self.hudView.frame;
    frame.origin.x = self.frame.size.width;
    if (!_showing) {
        frame.origin.x = self.frame.size.width - self.hudView.frame.size.width;
        [UIView animateWithDuration:.25 animations:^{
            self.hudView.frame = frame;
        } completion:^(BOOL finished) {
            _showing = YES;
        }];
    }
    if (autoHide) {
        if ([_timer isValid]) {
            [_timer invalidate];
            _timer = nil;
        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.25
                                                  target:self
                                                selector:@selector(dismiss)
                                                userInfo:nil
                                                 repeats:NO];
    }
}

- (void)dismiss {
    _showing = NO;
    [_timer invalidate], _timer = nil;
    CGRect frame = self.hudView.frame;
    frame.origin.x = self.frame.size.width;
    [UIView animateWithDuration:.25 animations:^{
        self.hudView.frame = frame;
    }];
}


@end








