//
//  MessageShowWindow.m
//  YunHua
//
//  Created by 董德富 on 13-9-12.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "MessageShowWindow.h"
#import "BBCyclingLabel.h"
#import "MessageSoundEffect.h"

#import "ChatLetterViewController.h"

@interface MessageShowWindow ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) BBCyclingLabel *label;
@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, copy) NSString *nickName;
@end

@implementation MessageShowWindow

+ (id)message {
    static MessageShowWindow *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{instance = [[self alloc] initWithFrame:CGRectMake(190, 0, 130, 20)];});
    return instance;
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.windowLevel = UIWindowLevelStatusBar + 1;
        self.backgroundColor = [UIColor blackColor];
        self.clipsToBounds = YES;
        
        self.label = [[BBCyclingLabel alloc] initWithFrame:self.bounds
                                         andTransitionType:BBCyclingLabelTransitionEffectScrollUp];
        self.label.font = [UIFont boldSystemFontOfSize:11];
        self.label.textColor = [UIColor whiteColor];
        self.label.textAlignment = UITextAlignmentCenter;
        self.label.transitionDuration = 0.4;
        [self addSubview:self.label];
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.frame = self.bounds;
        [self.button addTarget:self
                        action:@selector(messagePressed:)
              forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.button];
        
        self.hidden = YES;
    }
    return self;
}


- (void)showMessage:(NSString *)text userId:(NSNumber *)userId nickName:(NSString *)nickName {
    
    self.button.enabled = YES;
    
    self.userId = userId;
    self.nickName = nickName;
    if (userId && nickName.length) {
        [MessageSoundEffect playMessageReceivedSound];
    }
    
    CGRect frame = self.frame;
    frame.origin.y = 0;
    self.frame = frame;
    self.hidden = NO;
    
    [self.label setText:text animated:YES];
    
    if (self.timer) {
        if ([self.timer isValid]) {
            [self.timer invalidate];
            self.timer = nil;
        }
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2
                                                  target:self
                                                selector:@selector(hideMessageWindow)
                                                userInfo:nil
                                                 repeats:NO];
}

- (void)messagePressed:(UIButton *)button {
    if (self.userId && self.nickName.length) {
        
        button.enabled = NO;
        
         ChatLetterViewController *chat = [[ChatLetterViewController alloc] initWithUserId:self.userId nickName:self.nickName];
        [APP_ROOT_VC.navigationController pushViewController:chat animated:YES];
    }
}


- (void)hideMessageWindow {
    [UIView animateWithDuration:.25
                     animations:^{
                         CGRect frame = self.frame;
                         frame.origin.y = -20;
                         self.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         self.hidden = YES;
                         [self.label setText:@"" animated:NO];
                         self.button.enabled = YES;
                     }];
}





@end





