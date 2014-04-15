//
//  NameReplayView.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-7-15.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NameReplayView.h"

@implementation NameReplayView {
    CGRect nameRect;
    CGRect replayNameRect;
    
    BOOL touching;
    CGRect touchRect;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self perset];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self perset];
    }
    return self;
}
- (id)init {
    self = [super init];
    if (self) {
        [self perset];
    }
    return self;
}
- (void)perset {
    _font = [UIFont boldSystemFontOfSize:16];
    _textColor = kRGBColor(0, 147, 218);
    self.backgroundColor = [UIColor clearColor];
    nameRect = replayNameRect = touchRect = CGRectZero;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    [self setNeedsDisplay];
}
- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    [self setNeedsDisplay];
}
- (void)setName:(NSString *)name {
    if (_name != name) {
        _name = [name copy];
        [self setNeedsDisplay];
    }
}
- (void)setReplayName:(NSString *)replayName {
    if (_replayName != replayName) {
        _replayName = [replayName copy];
        [self setNeedsDisplay];
    }
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
    float orgin_x = 2;
    float s = 5;
    
    if (self.textColor) [self.textColor set];
    
    if (self.name) {
        CGSize nameSize = [self.name sizeWithFont:self.font];
        nameRect = CGRectMake(orgin_x, 0, nameSize.width, nameSize.height);
        [self.name drawInRect:nameRect withFont:self.font];
        orgin_x += nameSize.width + s;
    }
    
    if (self.replayName) {
        NSString *huifu = @"回复";
        CGSize huifuSize = [huifu sizeWithFont:self.font];
        CGSize replaySize = [self.replayName sizeWithFont:self.font];
        CGRect huifuRect = CGRectMake(orgin_x, 0, huifuSize.width, huifuSize.height);
        
        [[UIColor lightGrayColor] set];
        [huifu drawInRect:huifuRect withFont:self.font];
        orgin_x += huifuSize.width + s;
        
        [self.textColor set];
        replayNameRect = CGRectMake(orgin_x, 0, replaySize.width, replaySize.height);
        [self.replayName drawInRect:replayNameRect withFont:self.font];
    }
    
    if (touching && !CGRectEqualToRect(touchRect, CGRectZero)) {
        UIColor *fillColor = [UIColor colorWithWhite:0 alpha:.5];
        [fillColor setFill];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(touchRect, -2, 0)
                                                        cornerRadius:3];
        [path fill];
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (touches.count == 1) {
        UITouch *touch = [[event allTouches] anyObject];
        CGPoint touchPoint = [touch locationInView:self];
        if (CGRectContainsPoint(nameRect, touchPoint)) {
            touchRect = nameRect;
        }
        if (CGRectContainsPoint(replayNameRect, touchPoint)) {
            touchRect = replayNameRect;
        }
        if (!CGRectEqualToRect(touchRect, CGRectZero)) {
            touching = YES;
            [self setNeedsDisplay];
        }else {
            [self.nextResponder touchesBegan:touches withEvent:event];
        }
    }else {
        [self.nextResponder touchesBegan:touches withEvent:event];
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (touching) {
        if ([self.delegate respondsToSelector:@selector(nameReplayViewCallBack:)]) {
            NSString *callName = nil;
            if (CGRectEqualToRect(touchRect, nameRect)) {
                callName = self.name;
            }
            if (CGRectEqualToRect(touchRect, replayNameRect)) {
                callName = self.replayName;
            }
            [self.delegate nameReplayViewCallBack:callName];
        }
        if ([self.delegate respondsToSelector:@selector(nameReplayView:index:)]) {
            unsigned index = 0;
            if (CGRectEqualToRect(touchRect, nameRect)) index = 0;
            if (CGRectEqualToRect(touchRect, replayNameRect)) index = 1;
            [self.delegate nameReplayView:self index:index];
        }
        
        touching = NO;
        touchRect = CGRectZero;
        [self setNeedsDisplay];
    }else {
        [self.nextResponder touchesEnded:touches withEvent:event];
    }
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (touching) {
        touching = NO;
        touchRect = CGRectZero;
        [self setNeedsDisplay];
    }else {
        [self.nextResponder touchesCancelled:touches withEvent:event];
    }
}



@end
