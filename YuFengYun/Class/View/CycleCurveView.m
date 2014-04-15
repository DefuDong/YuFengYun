//
//  CycleCurveView.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-6-21.
//  Copyright (c) 2013年 董德富. All rights reserved.
//


#import "CycleCurveView.h"
#import <QuartzCore/QuartzCore.h>

#define CYCLE_TIME_INTERVAL 3

@interface CycleCurveView ()
<
  UIGestureRecognizerDelegate
>

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, assign) int nextPage;

@property (nonatomic, strong) CALayer *baseLayer;

@property (nonatomic, strong) NSMutableArray *allViews;
@end


@implementation CycleCurveView
- (NSMutableArray *)allViews {
    if (!_allViews) {
        _allViews = [NSMutableArray array];
    }
    return _allViews;
}
- (void)setDatasource:(id<CycleCurveViewDatasource>)datasource {
    _datasource = datasource;
    [self reloadData];
}
//- (void)setCurrentPage:(NSInteger)currentPage {
//    if (_currentPage != currentPage) {
//        if (currentPage > _currentPage) {
//            [self setTransToPageWithDirectionLeft:YES];
//        }else {
//            [self setTransToPageWithDirectionLeft:NO];
//        }
//        _currentPage = currentPage;
//    }
//}


#pragma mark - init
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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


#pragma mark - public
- (void)reloadData {
    self.totalPages = [self.datasource numberOfCycleCurveViewPage];
    if (self.totalPages == 0) return;
    
    [self.allViews removeAllObjects];
    for (int i = 0; i < self.totalPages; i++) {
        UIView *view = [self.datasource cycleCurveView:self pageAtIndex:i];
        view.userInteractionEnabled = NO;
        [self.allViews addObject:view];
    }
    
    [self startTimer];
    self.pageControl.numberOfPages = self.totalPages;
    UIView *currentView = self.allViews[self.currentPage];
    self.layer.contents = currentView.layer.contents;
}
- (void)startTimer {
    if ([self.timer isValid]) {
        [self.timer invalidate];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:CYCLE_TIME_INTERVAL
                                                  target:self
                                                selector:@selector(handelTimer:)
                                                userInfo:nil
                                                 repeats:YES];
}
- (void)stopTimer {
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
}


#pragma mark - private
- (void)perset {
    self.clipsToBounds = YES;
    
    CGRect rect = self.bounds;
    rect.origin.y = rect.size.height - 30;
    rect.size.height = 30;
    self.pageControl = [[UIPageControl alloc] initWithFrame:rect];
    self.pageControl.userInteractionEnabled = NO;
    [self addSubview:self.pageControl];
    
    _currentPage = 0;
    
    UISwipeGestureRecognizer *swipeL = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeL.delegate = self;
    swipeL.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeL.delaysTouchesBegan = YES;
    UISwipeGestureRecognizer *swipeR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeR.delegate = self;
    swipeR.direction = UISwipeGestureRecognizerDirectionRight;
    swipeR.delaysTouchesBegan = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:swipeL];
    [self addGestureRecognizer:swipeR];
    [self addGestureRecognizer:tap];
    
    UIScrollView *scrollView = (UIScrollView *)self.superview.superview;
    [scrollView.panGestureRecognizer requireGestureRecognizerToFail:swipeR];
    [scrollView.panGestureRecognizer requireGestureRecognizerToFail:swipeL];
    
    UIScrollView *scrollView1 = (UIScrollView *)self.superview;
    [scrollView1.panGestureRecognizer requireGestureRecognizerToFail:swipeR];
    [scrollView1.panGestureRecognizer requireGestureRecognizerToFail:swipeL];
}
- (int)validPageValue:(NSInteger)value {
    if(value == -1) value = self.totalPages - 1;
    if(value == self.totalPages) value = 0;
    return value;
}

- (void)swipe:(UISwipeGestureRecognizer *)swipe {
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        self.nextPage = [self validPageValue:self.currentPage - 1];
        [self setTransToPageWithDirectionLeft:NO];
    }
    else if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        self.nextPage = [self validPageValue:self.currentPage + 1];
        [self setTransToPageWithDirectionLeft:YES];
    }
}
- (void)tap:(UITapGestureRecognizer *)tap {
    
    if ([self.delegate respondsToSelector:@selector(cycleView:didSelectPageAtIndex:)]) {
        [self.delegate cycleView:self didSelectPageAtIndex:self.currentPage];
    }
}

- (void)handelTimer:(NSTimer *)timer {
    self.nextPage = [self validPageValue:self.currentPage+1];
    [self setTransToPageWithDirectionLeft:YES];
//    [self stopTimer];
}

- (void)setTransToPageWithDirectionLeft:(BOOL)left {
    CGSize size = self.frame.size;
    self.baseLayer = [CALayer layer];
    CALayer *theLayer = [CALayer layer];
    CALayer *nextLayer = [CALayer layer];
    
    UIView *currentView = self.allViews[self.currentPage];
    UIView *nextView = self.allViews[self.nextPage];
    theLayer.contents = currentView.layer.contents;
    nextLayer.contents = nextView.layer.contents;
    
    if (left) {        
        nextLayer.frame = CGRectMake(size.width, 0, size.width, size.height);
        theLayer.frame = CGRectMake(0, 0, size.width, size.height);
    }
    else {        
        nextLayer.frame = CGRectMake(0, 0, size.width, size.height);
        theLayer.frame = CGRectMake(size.width, 0, size.width, size.height);
    }
    
    [self.baseLayer addSublayer:nextLayer];
    [self.baseLayer addSublayer:theLayer];
    
    self.baseLayer.frame = CGRectMake(left ? 0 : -size.width, 0, size.width*2, size.height);
    [self.layer insertSublayer:self.baseLayer atIndex:0];
    
    CAMediaTimingFunction *timeFunction = [CAMediaTimingFunction functionWithControlPoints:1. :.001 :0 :.999];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    animation.toValue = [NSNumber numberWithFloat:left ? 0 : size.width];
    animation.timingFunction = timeFunction;
    animation.delegate = self;
    animation.duration = .7;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.baseLayer addAnimation:animation forKey:nil];
    
    self.userInteractionEnabled = NO;
    [self stopTimer];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {

    UIView *nextView = self.allViews[self.nextPage];
    self.layer.contents = nextView.layer.contents;
    [self.baseLayer removeFromSuperlayer];
    self.baseLayer = nil;
    
    _currentPage = self.nextPage;
    _pageControl.currentPage = self.currentPage;
    
    self.userInteractionEnabled = YES;
    [self startTimer];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]]) {
        return YES;
    }
    return NO;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

@end
