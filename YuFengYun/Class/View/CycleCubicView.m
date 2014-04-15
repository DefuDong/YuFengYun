//
//  CycleCubicView.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-6-24.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "CycleCubicView.h"
#import <QuartzCore/QuartzCore.h>

#define CYCLE_TIME_INTERVAL 3

@interface CycleCubicView ()

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, assign) int nextPage;

@property (nonatomic, strong) NSMutableArray *allViews;
@end


@implementation CycleCubicView
- (NSMutableArray *)allViews {
    if (!_allViews) {
        _allViews = [NSMutableArray array];
    }
    return _allViews;
}
- (void)setDatasource:(id<CycleCubicViewDatasource>)datasource {
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
    self.totalPages = [self.datasource numberOfCycleCubicViewPage];
    if (self.totalPages == 0) return;
    
    [self.allViews removeAllObjects];
    for (int i = 0; i < self.totalPages; i++) {
        UIView *view = [self.datasource CycleCubicView:self pageAtIndex:i];
        view.userInteractionEnabled = NO;
        [self.allViews addObject:view];
    }
    
    [self startTimer];
    self.pageControl.numberOfPages = self.totalPages;
    UIView *currentView = self.allViews[self.currentPage];
    [self insertSubview:currentView atIndex:0];
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
    self.clipsToBounds = NO;
    
    CGRect rect = self.bounds;
    rect.origin.y = rect.size.height - 30;
    rect.size.height = 30;
    self.pageControl = [[UIPageControl alloc] initWithFrame:rect];
    self.pageControl.userInteractionEnabled = NO;
    [self addSubview:self.pageControl];
    
    _currentPage = 0;
    
    UISwipeGestureRecognizer *swipeL = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeL.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer *swipeR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeR.direction = UISwipeGestureRecognizerDirectionRight;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:swipeL];
    [self addGestureRecognizer:swipeR];
    [self addGestureRecognizer:tap];
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
    UIView *currentView = self.allViews[self.currentPage];
    UIView *nextView = self.allViews[self.nextPage];
    [self insertSubview:nextView belowSubview:currentView];
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:1. :.005 :0 :.995];
    animation.duration = .9;
    animation.type = @"cube";
    animation.subtype = left ? kCATransitionFromRight : kCATransitionFromLeft;
    
    int currIndex = [self.subviews indexOfObject:currentView];
    int nextIndex = [self.subviews indexOfObject:nextView];
    [self exchangeSubviewAtIndex:currIndex withSubviewAtIndex:nextIndex];
    
    [self.layer addAnimation:animation forKey:nil];
//    [self bringSubviewToFront:self.pageControl];
    [self stopTimer];
    self.userInteractionEnabled = NO;
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    UIView *currentView = self.allViews[self.currentPage];
    [currentView removeFromSuperview];
    
    _currentPage = self.nextPage;
    self.pageControl.currentPage = self.currentPage;
    
    self.userInteractionEnabled = YES;
    [self startTimer];
}


@end