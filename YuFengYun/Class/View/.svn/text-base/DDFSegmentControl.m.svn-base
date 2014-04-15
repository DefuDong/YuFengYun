//
//  DDFSegmentControl.m
//  YuFengYun
//
//  Created by 董德富 on 13-12-26.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "DDFSegmentControl.h"

@interface DDFSegmentControl ()
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) UIView *tagView;
@end

@implementation DDFSegmentControl

#pragma mark - public
- (void)setTitle:(NSString *)title index:(unsigned int)index {
    if (index >= self.buttonArray.count) return;
    
    UIButton *button = self.buttonArray[index];
    [button setTitle:title forState:UIControlStateNormal];
}
- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    self.buttonArray = [[NSMutableArray alloc] initWithCapacity:_titles.count];
    
    for (UIView *vi in self.subviews) {
        if ([vi isKindOfClass:[UIButton class]]) {
            [vi removeFromSuperview];
        }
    }
    
    CGSize size = self.frame.size;
    float aWidth = size.width / _titles.count;
    
    for (int i = 0; i < _titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(aWidth*i, 0, aWidth, size.height);
        button.tag = i;
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:button];
        
        [button setTitle:_titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [button setAdjustsImageWhenHighlighted:NO];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        
        [self.buttonArray addObject:button];
    }
    
    [self setNeedsDisplay];
    [self setNeedsLayout];
}
- (void)setPercent:(float)percent {
    _percent = percent;
    
    int percent_ = percent * 1000000;
    int aPercent_ = 1.0f / _titles.count * 1000000;

    if (!(percent_ % aPercent_)) {
        int index = percent_ / aPercent_;
        
        CGRect rect = self.tagView.frame;
        rect.origin.x = index * (self.frame.size.width / _titles.count);
        self.tagView.frame = rect;
        
        [self resetButton:index];
    }
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

    self.tagView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-2, self.frame.size.width, 2)];
    self.tagView.backgroundColor = kRGBColor(0, 147, 218);
    [self addSubview:self.tagView];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.tagView.frame;
    frame.size.width = self.frame.size.width / _titles.count;
    self.tagView.frame = frame;
}

- (void)buttonPressed:(UIButton *)button {
    [UIView animateWithDuration:.25
                     animations:^{
                         CGRect rect = self.tagView.frame;
                         rect.origin.x = button.tag * (self.frame.size.width / _titles.count);
                         self.tagView.frame = rect;
                     }
                     completion:^(BOOL finished) {
                         [self resetButton:button.tag];
                     }];
    
    if ([self.delegate respondsToSelector:@selector(DDFSegmentPressedIndex:)]) {
        [self.delegate DDFSegmentPressedIndex:button.tag];
    }
}

- (void)resetButton:(NSInteger)percent {
    for (UIButton *button in self.buttonArray) {        
        button.enabled = YES;
    }
    UIButton *perButton = self.buttonArray[percent];
    perButton.enabled = NO;
}


- (void)drawRect:(CGRect)rect {
    if (!_titles || !_titles.count) return;
    
    float aWidth = rect.size.width / _titles.count;
    float aHeight = rect.size.height / 4.;

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, .5);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:.7 alpha:1].CGColor);
    CGContextAddRect(context, CGRectInset(rect, -1, 0));
    
    for (int i = 0; i < _titles.count; i++) {
        CGContextMoveToPoint(context, aWidth * i, aHeight);
        CGContextAddLineToPoint(context, aWidth * i, aHeight * 3);
    }
    
    CGContextStrokePath(context);
}
@end

