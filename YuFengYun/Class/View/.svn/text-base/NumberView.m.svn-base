//
//  NumberView.m
//  YuFengYun
//
//  Created by 董德富 on 13-12-26.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NumberView.h"

@implementation NumberView
@synthesize number = _number;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self loadSubViews];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self loadSubViews];
    }
    return self;
}
- (id)init {
    self = [super init];
    if (self) {
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
    
    UIImage *image = [UIImage imageNamed:@"number_bubble.png"];//43*23
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 10, 5, 5)];
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imageView.image = image;
    [self addSubview:_imageView];
    
    _label = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 5, 2)];
    _label.textColor = [UIColor whiteColor];
    _label.backgroundColor = [UIColor clearColor];
    _label.font = [UIFont boldSystemFontOfSize:14];
    _label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_label];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.bounds;
    _label.frame = CGRectMake(5, 0, self.frame.size.width-7, self.frame.size.height);
}


- (void)setNumber:(NSString *)number {
    if ([number isEqualToString:@"0"] || !number) {
        self.hidden = YES;
    }else {
        self.hidden = NO;
    }
    
    _number = number;
    _label.text = number;
    
    CGRect frame = self.frame;
    CGSize size = [number sizeWithFont:_label.font];
    if (size.width <= 43) {
        size.width = 43;
    }
    frame.size.width = size.width;
    self.frame = frame;
}
- (NSString *)number {
    return _label.text;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
