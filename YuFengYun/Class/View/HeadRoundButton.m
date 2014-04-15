//
//  HeadRoundButton.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-7-15.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "HeadRoundButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation HeadRoundButton
@synthesize roundColor = _roundColor;

- (void)setHeadImage:(UIImage *)headImage {
    [self setTitle:nil forState:UIControlStateNormal];
    [self setImage:headImage forState:UIControlStateNormal];
}
- (UIImage *)headImage {
    return [self imageForState:UIControlStateNormal];
}
- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    [super setImage:image forState:state];
    self.imageEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);// = CGRectInset(self.bounds, 3, 3);
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width * .5;
}

- (void)setRoundColor:(UIColor *)roundColor {
    if (_roundColor != roundColor) {
        _roundColor = roundColor;
        [self setNeedsDisplay];
    }
}
- (UIColor *)roundColor {
    if (!_roundColor) {
        _roundColor = kRGBColor(240, 240, 240);
    }
    return _roundColor;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.roundColor.CGColor);
    CGContextSetStrokeColorWithColor(context, self.roundColor.CGColor);
    CGContextFillEllipseInRect(context, rect);    
}


@end
