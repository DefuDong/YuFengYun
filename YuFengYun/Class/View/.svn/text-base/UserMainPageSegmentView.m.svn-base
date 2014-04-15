//
//  UserMainPageSegmentView.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-7-30.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "UserMainPageSegmentView.h"

@interface UserMainPageSegmentView ()
@property (nonatomic, strong) NSMutableArray *buttonArray;
@end

@implementation UserMainPageSegmentView
- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [[NSMutableArray alloc] initWithCapacity:3];
    }
    return _buttonArray;
}
- (void)setPercent:(float)percent {
    _percent = percent;
    
    [self resetButton:_percent];
    
    [self setNeedsDisplay];
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadSubviews];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self loadSubviews];
    }
    return self;
}
- (void)loadSubviews {
    NSArray *imageName = @[@"user_main_page_paper_comment.png", @"user_main_page_paper.png", @"user_main_page_collect.png"];
    
    CGSize size = self.frame.size;
    float aWidth = size.width / 3.f;
    for (int i = 0; i < 3; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(aWidth*i, 0, aWidth, size.height);
        button.tag = i;
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:button];
        
        [button setImage:[UIImage imageNamed:imageName[i]] forState:UIControlStateNormal];
        [button setTitle:@"0" forState:UIControlStateNormal];
        [button setTitleColor:kRGBColor(40, 170, 220) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
        //        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, aWidth*.1)];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, aWidth*.2, 0, aWidth*.6)];
        [button setAdjustsImageWhenHighlighted:NO];
        
        [self.buttonArray addObject:button];
    }
}
- (void)buttonPressed:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(mainPageSegmentPressedIndex:)]) {
        [self.delegate mainPageSegmentPressedIndex:button.tag];
    }
}

- (void)resetButton:(float)percent {
    if (percent == 0.0f) {
        UIButton *button1 = self.buttonArray[0];
        UIButton *button2 = self.buttonArray[1];
        UIButton *button3 = self.buttonArray[2];
        button1.enabled = NO;
        button2.enabled = YES;
        button3.enabled = YES;
    }else if (percent == 1.0f/3.0f) {
        UIButton *button1 = self.buttonArray[0];
        UIButton *button2 = self.buttonArray[1];
        UIButton *button3 = self.buttonArray[2];
        button1.enabled = YES;
        button2.enabled = NO;
        button3.enabled = YES;
    }else if (percent == 2.0f/3.0f) {
        UIButton *button1 = self.buttonArray[0];
        UIButton *button2 = self.buttonArray[1];
        UIButton *button3 = self.buttonArray[2];
        button1.enabled = YES;
        button2.enabled = YES;
        button3.enabled = NO;
    }
}


- (void)drawRect:(CGRect)rect {
    float aWidth = rect.size.width / 3.;
    float aHeight = rect.size.height / 3.;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextAddRect(context, CGRectInset(rect, -1, 0));
    CGContextMoveToPoint(context, aWidth, aHeight);
    CGContextAddLineToPoint(context, aWidth, aHeight*2.);
    CGContextMoveToPoint(context, aWidth*2., aHeight);
    CGContextAddLineToPoint(context, aWidth*2., aHeight*2.);
    
    CGContextStrokePath(context);
        
    float origin_x = rect.size.width * self.percent;
    CGContextSetStrokeColorWithColor(context, [kRGBColor(40, 170, 220) CGColor]);
    CGContextSetLineWidth(context, 2);
    CGContextMoveToPoint(context, origin_x, rect.size.height-1.5);
    CGContextAddLineToPoint(context, origin_x + rect.size.width/3.0f, rect.size.height - 1.5);
    CGContextStrokePath(context);
}

@end
