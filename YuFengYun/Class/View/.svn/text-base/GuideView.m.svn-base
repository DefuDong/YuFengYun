//
//  GuideView.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-7-24.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "GuideView.h"

@implementation GuideView
{
    CGPoint _point;
}
- (void)setImageNames:(NSArray *)imageNames {
    if (_imageNames != imageNames) {
        _imageNames = imageNames;
        
        [self loadSubviews];
    }
}

- (id)initWithFrame:(CGRect)frame  {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bounces = NO;
        
        [self.panGestureRecognizer addTarget:self action:@selector(pan:)];
    }
    return self;
}

- (void)loadSubviews {
    if (self.imageNames.count == 0) return;
    
    for (NSString *imageName in self.imageNames) {
        NSInteger index = [self.imageNames indexOfObject:imageName];
        CGSize size = self.frame.size;
       
        UIImage *image = UIIMAGE_FILE(imageName);
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(index * size.width, 0, size.width, size.height);
        [self addSubview:imageView];
    }
    self.contentSize = CGSizeMake(self.frame.size.width * self.imageNames.count, self.frame.size.height);
}

- (void)pan:(UIPanGestureRecognizer *)panGesture {
    if (self.contentOffset.x < self.contentSize.width - self.frame.size.width) {
        return;
    }
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        _point = [panGesture locationInView:self];
    }else if (panGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint p = [panGesture locationInView:self];
        self.contentOffset = CGPointMake(self.contentOffset.x - (p.x-_point.x), 0);
        
        float percent = 1 - (self.contentOffset.x - (self.contentSize.width-self.frame.size.width))/self.frame.size.width;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.8 * percent];
    }else {
        if ((self.contentOffset.x - (self.contentSize.width-self.frame.size.width))/self.frame.size.width < 0.2) {
            [self setContentOffset:CGPointMake(self.contentSize.width-self.frame.size.width, 0) animated:YES];
        }else {
            [self setContentOffset:CGPointMake(self.contentSize.width, 0) animated:YES];
            [UIView animateWithDuration:.25
                             animations:^{self.backgroundColor = [UIColor clearColor];}
                             completion:^(BOOL finished) {
                                 if (self.completeBlock) {
                                     self.completeBlock();
                                 }
                                 [self removeFromSuperview];
                             }];
        }
    }
}


@end
