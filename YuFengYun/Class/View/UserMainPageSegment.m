//
//  UserMainPageSegmentView.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-7-30.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "UserMainPageSegment.h"

@interface UserMainPageSegment ()
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) UIView *tagView;
@end

@implementation UserMainPageSegment

#pragma mark - public
- (void)setTitle:(NSString *)title index:(unsigned int)index {
    if (index >= self.buttonArray.count) return;
    
    UIButton *button = self.buttonArray[index];
    [button setTitle:title forState:UIControlStateNormal];
}
- (void)layoutSubviews {
    [super layoutSubviews];
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
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    
//    NSArray *imageName = @[@"user_main_page_paper_comment.png", @"user_main_page_paper.png", @"user_main_page_collect.png"];
//    
//    CGSize size = self.frame.size;
//    float aWidth = size.width / 3.f;
//    for (int i = 0; i < 3; i++) {
//        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(aWidth*i, 0, aWidth, size.height);
//        button.tag = i;
//        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
//        [self addSubview:button];
//        
//        [button setImage:[UIImage imageNamed:imageName[i]] forState:UIControlStateNormal];
//        [button setTitle:@"..." forState:UIControlStateNormal];
//        [button setTitleColor:kRGBColor(40, 170, 220) forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
//        //        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, aWidth*.1)];
//        [button setImageEdgeInsets:UIEdgeInsetsMake(0, aWidth*.2, 0, aWidth*.6)];
//        [button setAdjustsImageWhenHighlighted:NO];
//        
//        [self.buttonArray addObject:button];
//    }
    self.tagView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-2, self.frame.size.width, 2)];
    self.tagView.backgroundColor = kRGBColor(40, 170, 220);
    [self addSubview:self.tagView];
}
- (void)buttonPressed:(UIButton *)button {
    [UIView animateWithDuration:.25
                     animations:^{
                         CGRect rect = self.tagView.frame;
                         rect.origin.x = button.tag * (self.frame.size.width / 3.0f);
                         self.tagView.frame = rect;
                     }
                     completion:^(BOOL finished) {
                         [self resetButton:button.tag];
                     }];
    
    if ([self.delegate respondsToSelector:@selector(mainPageSegmentPressedIndex:)]) {
        [self.delegate mainPageSegmentPressedIndex:button.tag];
    }
}

- (void)resetButton:(NSInteger)percent {
    if (percent == 0) {
        UIButton *button1 = self.buttonArray[0];
        UIButton *button2 = self.buttonArray[1];
        UIButton *button3 = self.buttonArray[2];
        button1.enabled = NO;
        button2.enabled = YES;
        button3.enabled = YES;
    }else if (percent == 1) {
        UIButton *button1 = self.buttonArray[0];
        UIButton *button2 = self.buttonArray[1];
        UIButton *button3 = self.buttonArray[2];
        button1.enabled = YES;
        button2.enabled = NO;
        button3.enabled = YES;
    }else if (percent == 2) {
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
//    float aHeight = rect.size.height / 3.;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, .5);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:.7 alpha:1].CGColor);
    CGContextAddRect(context, CGRectInset(rect, -1, 0));
    CGContextMoveToPoint(context, aWidth, 0);
    CGContextAddLineToPoint(context, aWidth, rect.size.height);
    CGContextMoveToPoint(context, aWidth*2., 0);
    CGContextAddLineToPoint(context, aWidth*2., rect.size.height);
    
    CGContextStrokePath(context);
//    kRGBColor(25, 71, 129)
}

@end
