//
//  TextLeftView.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-7-18.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "TextLeftView.h"

@implementation TextLeftView

- (id)initWithImage:(NSString *)imageName {
    self = [super initWithFrame:CGRectMake(0, 0, 44, 44)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        self.imageName = imageName;
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0, 0, 44, 44)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    _image = [UIImage imageNamed:_imageName];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    float width = rect.size.height;
    //    float height = rect.size.height;
    if (_image) {
        CGRect imageRect;
        imageRect.size = _image.size;
        imageRect.origin.x = (width-_image.size.width) * .5;
        imageRect.origin.y = (width-_image.size.height) * .5;
        [_image drawInRect:imageRect];
    }
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(context, 1);
//    CGContextSetStrokeColorWithColor(context, kRGBColor(40, 170, 220).CGColor);
//    CGContextMoveToPoint(context, width-1, width*.33);
//    CGContextAddLineToPoint(context, width-1, width*.67);
//    CGContextStrokePath(context);
}
@end
