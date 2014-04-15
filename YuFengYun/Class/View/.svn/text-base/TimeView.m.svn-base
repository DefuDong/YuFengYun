//
//  TimeView.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-6-24.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "TimeView.h"
#import <QuartzCore/QuartzCore.h>

#define WIDTH 17

@interface TimeView ()
@property (nonatomic, strong) CALayer *hourHandLayer;
@property (nonatomic, strong) CALayer *minuteHandLayer;

@property (nonatomic, assign) float hour;
@property (nonatomic, assign) float minute;
@end

@implementation TimeView

- (id)initWithFrame:(CGRect)frame {
    CGRect rect = frame;
    rect.size = CGSizeMake(WIDTH, WIDTH);
    self = [super initWithFrame:rect];
    if (self) {
        // Initialization code
        [self preset];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self preset];
    }
    return self;
}
- (id)init {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        [self preset];
    }
    return self;
}
- (void)setFrame:(CGRect)frame {
    CGRect rect = frame;
    rect.size = CGSizeMake(WIDTH, WIDTH);
    [super setFrame:rect];
}

- (void)preset {
    self.backgroundColor = [UIColor clearColor];
    self.hourHandLayer = [CALayer layer];
    self.hourHandLayer.frame = CGRectMake(0, 0, 1, WIDTH*.25);
    self.hourHandLayer.anchorPoint = CGPointMake(.5, .9);
    self.hourHandLayer.position = CGPointMake(self.frame.size.width/2., self.frame.size.height/2.);
    self.hourHandLayer.backgroundColor = [UIColor whiteColor].CGColor;
//    self.hourHandLayer.cornerRadius = 1;
    [self.layer addSublayer:self.hourHandLayer];

    self.minuteHandLayer = [CALayer layer];
    self.minuteHandLayer.frame = CGRectMake(0, 0, 1, WIDTH*.39);
    self.minuteHandLayer.anchorPoint = CGPointMake(.5, .9);
    self.minuteHandLayer.position = CGPointMake(self.frame.size.width/2., self.frame.size.height/2.);
    self.minuteHandLayer.backgroundColor = [UIColor whiteColor].CGColor;
//    self.minuteHandLayer.cornerRadius = 1;
    [self.layer addSublayer:self.minuteHandLayer];
}

- (void)setHour:(unsigned)hour minute:(unsigned)minute {
    unsigned m_ = minute;
    unsigned h_ = hour;
    
    if (m_ > 60) m_ = m_ % 60;
    if (h_> 12) h_ = h_ % 12;
    
    float m = (float)m_;
    float h = (float)h_;
    
    self.minute = m;
    self.hour = h;
    
    [self setMinute];
    [self performSelector:@selector(setMinute) withObject:nil afterDelay:.2];
    [self performSelector:@selector(setHour) withObject:nil afterDelay:.4];
}

- (void)setMinute {
    
    float m = self.minute / 60.;
    CATransform3D transform = CATransform3DMakeRotation(2.*M_PI*m, 0, 0, 1);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.duration = .7;
//    animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:.5 :1. :0 :.5];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    animation.toValue = [NSValue valueWithCATransform3D:transform];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.minuteHandLayer addAnimation:animation forKey:nil];
}
- (void)setHour {
    
    float h = (self.hour / 12.) + (self.minute / 60. / 12.);    
    CATransform3D transform = CATransform3DMakeRotation(2.*M_PI*h, 0, 0, 1);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.duration = .7;
    animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:.5 :1. :0 :.5];
    animation.toValue = [NSValue valueWithCATransform3D:transform];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.hourHandLayer addAnimation:animation forKey:nil];
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextAddEllipseInRect(context, CGRectInset(rect, 1, 1));
    CGContextStrokePath(context);
}

@end




