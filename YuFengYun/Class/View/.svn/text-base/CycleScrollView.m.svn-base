//
//  CycleScrollView.m
//  CircleScrollView
//
//  Created by 董德富 on 13-1-30.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "CycleScrollView.h"
#import "BBCyclingLabel.h"
#import "SMPageControl.h"
#import <QuartzCore/QuartzCore.h>

#define CYCLE_TIME_INTERVAL 3

@interface CycleScrollView ()
<
  UIScrollViewDelegate
> 
@property (nonatomic, strong) UIScrollView *baseScrollView;
@property (nonatomic, strong) SMPageControl *pageControl;
@property (nonatomic, strong) BBCyclingLabel *titleLable;

@property (nonatomic, strong) NSMutableArray *currentViews;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, assign) NSInteger perPage; //控制文字转换方向

@property (nonatomic, strong) CALayer *baseLayer;
@end


@implementation CycleScrollView
- (void)setDatasource:(id<CycleScrollViewDatasource>)datasource {
    _datasource = datasource;
    [self reloadData];
}
- (NSMutableArray *)currentViews {
    if (!_currentViews) {
        _currentViews = [[NSMutableArray alloc] initWithCapacity:3];
    }
    return _currentViews;
}
- (void)setCurrentPage:(NSInteger)currentPage {
    if (_currentPage != currentPage) {
        self.perPage = _currentPage;
        _currentPage = currentPage;
    }
}

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
    self.totalPages = [self.datasource numberOfCycleScrollViewPage];
    if (self.totalPages == 0) return;
    
    [self startTimer];
    self.pageControl.numberOfPages = self.totalPages;
    [self loadDataWithTextAnimat:YES];
}
- (void)startTimer {
    if (self.totalPages == 0) return;
    
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
    if (self.totalPages == 0) return;
    
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
}


#pragma mark - private
- (void)perset {
    self.currentPage = 0;
    self.clipsToBounds = YES;
    
    self.baseScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.baseScrollView.delegate = self;
    self.baseScrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
    self.baseScrollView.showsHorizontalScrollIndicator = NO;
    self.baseScrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
    self.baseScrollView.pagingEnabled = YES;
//    self.baseScrollView.clipsToBounds = YES;
    [self addSubview:self.baseScrollView];
    
    UIView *titleBackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-30, self.frame.size.width, 30)];
//    UIView *titleBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 96, self.frame.size.width, 44)];
    titleBackView.backgroundColor = [UIColor colorWithWhite:0 alpha:.4];
    titleBackView.userInteractionEnabled = NO;
    [self addSubview:titleBackView];
    self.titleLable = [[BBCyclingLabel alloc] initWithFrame:CGRectMake(5, 0, 275, 30)];
    self.titleLable.transitionEffect = BBCyclingLabelTransitionEffectScrollUp;
    self.titleLable.numberOfLines = 1;
    self.titleLable.font = [UIFont boldSystemFontOfSize:16];
    self.titleLable.textColor = [UIColor whiteColor];
    self.titleLable.textAlignment = UITextAlignmentLeft;
    self.titleLable.transitionDuration = .7;
    self.titleLable.clipsToBounds = YES;
    [titleBackView addSubview:self.titleLable];
    
    CGRect pageRect = CGRectMake(self.titleLable.frame.size.width, 0, 40, 30);
    self.pageControl = [[SMPageControl alloc] initWithFrame:pageRect];
    self.pageControl.userInteractionEnabled = NO;
    self.pageControl.currentPage = self.currentPage;
    self.pageControl.alignment = SMPageControlAlignmentRight;
    self.pageControl.indicatorMargin = 3;
    self.pageControl.indicatorDiameter = 4;
    [titleBackView addSubview:self.pageControl];
}
- (void)loadDataWithTextAnimat:(BOOL)animate {
    
    self.pageControl.currentPage = self.currentPage;
    
    if (animate) {
        self.titleLable.transitionEffect = (self.currentPage > self.perPage) ? BBCyclingLabelTransitionEffectScrollUp : BBCyclingLabelTransitionEffectScrollDown;
        [self.titleLable setText:[self.datasource cycleView:self titleAtIndex:self.currentPage]
                        animated:YES];
    }
    
    //从scrollView上移除所有的subview
    NSArray *subViews = [self.baseScrollView subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self getDisplayImagesWithCurpage:self.currentPage];
    
    for (int i = 0; i < self.currentViews.count; i++) {
        UIView *v = [self.currentViews objectAtIndex:i];
        v.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleTap:)];
        [v addGestureRecognizer:singleTap];
        v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
        [self.baseScrollView addSubview:v];
    }
    
    [self.baseScrollView setContentOffset:CGPointMake(self.baseScrollView.frame.size.width, 0)];
}
- (void)getDisplayImagesWithCurpage:(int)page {
    
    int pre = [self validPageValue:self.currentPage-1];
    int last = [self validPageValue:self.currentPage+1];
        
    [self.currentViews removeAllObjects];
    
//    NSLog(@"%d", pre);
//    NSLog(@"%@", [self.datasource cycleView:self pageAtIndex:pre]);
    if (!self.datasource) return;
    [self.currentViews addObject:[self.datasource cycleView:self pageAtIndex:pre]];
    [self.currentViews addObject:[self.datasource cycleView:self pageAtIndex:page]];
    [self.currentViews addObject:[self.datasource cycleView:self pageAtIndex:last]];    
}
- (int)validPageValue:(NSInteger)value {
    
    if(value == -1) value = self.totalPages - 1;
    if(value == self.totalPages) value = 0;
    
    return value;
}
- (void)handleTap:(UITapGestureRecognizer *)tap {
    
    if ([self.delegate respondsToSelector:@selector(cycleView:didSelectPageAtIndex:)]) {
        [self.delegate cycleView:self didSelectPageAtIndex:self.currentPage];
    }
}
- (void)handelTimer:(NSTimer *)timer {
    [self.baseScrollView setContentOffset:CGPointMake(self.baseScrollView.bounds.size.width * 2, 0)
                                 animated:YES];
//    [self setTransToNextPage];
}
#pragma mark animate
- (void)setTransToNextPage {
    CGSize size = self.frame.size;
    self.baseLayer = [CALayer layer];
    CALayer *theLayer = [CALayer layer];
    CALayer *nextLayer = [CALayer layer];
    self.baseLayer.backgroundColor = [UIColor whiteColor].CGColor;
    
    if (self.currentViews.count != 3) return;
    UIView *currentView = self.currentViews[1];
    UIView *nextView = self.currentViews[2];
    theLayer.contents = currentView.layer.contents;
    nextLayer.contents = nextView.layer.contents;
    
    nextLayer.frame = CGRectMake(size.width, 0, size.width, size.height);
    theLayer.frame = CGRectMake(0, 0, size.width, size.height);    
    [self.baseLayer addSublayer:nextLayer];
    [self.baseLayer addSublayer:theLayer];
    
    self.baseLayer.frame = CGRectMake(0, 0, size.width*2, size.height);
    [self.layer insertSublayer:self.baseLayer above:self.baseScrollView.layer];
    
    CAMediaTimingFunction *timeFunction = [CAMediaTimingFunction functionWithControlPoints:1. :.001 :0 :.999];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    animation.toValue = [NSNumber numberWithFloat:0];
    animation.timingFunction = timeFunction;
    animation.delegate = self;
    animation.duration = .7;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.baseLayer addAnimation:animation forKey:nil];
    
    self.userInteractionEnabled = NO;
    [self stopTimer];
    
    self.titleLable.transitionEffect
    = ([self validPageValue:self.currentPage+1] > self.currentPage) ?
    BBCyclingLabelTransitionEffectScrollUp : BBCyclingLabelTransitionEffectScrollDown;
    [self.titleLable setText:[self.datasource cycleView:self titleAtIndex:self.currentPage]
                    animated:YES];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.baseLayer removeFromSuperlayer];
    self.baseLayer = nil;
    self.currentPage = [self validPageValue:self.currentPage+1];
    [self loadDataWithTextAnimat:NO];
    
    self.userInteractionEnabled = YES;
    [self startTimer];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {    
    int x = scrollView.contentOffset.x;
    //往下翻一张
    if(x >= (2*self.frame.size.width)) {
        self.currentPage = [self validPageValue:self.currentPage+1];
        [self loadDataWithTextAnimat:YES];
    }
    //往上翻
    if(x <= 0) {
        self.currentPage = [self validPageValue:self.currentPage-1];
        [self loadDataWithTextAnimat:YES];
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    int x = scrollView.contentOffset.x;
    //往下翻一张
    if(x >= (2*self.frame.size.width)) {
        self.currentPage = [self validPageValue:self.currentPage+1];
        [self loadDataWithTextAnimat:YES];
    }
    //往上翻
    if(x <= 0) {
        self.currentPage = [self validPageValue:self.currentPage-1];
        [self loadDataWithTextAnimat:YES];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self startTimer];
}

@end








