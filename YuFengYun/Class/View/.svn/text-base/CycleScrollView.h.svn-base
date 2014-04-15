//
//  CycleScrollView.h
//  CircleScrollView
//
//  Created by 董德富 on 13-1-30.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CycleScrollViewDelegate;
@protocol CycleScrollViewDatasource;

@interface CycleScrollView : UIView

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, weak) id<CycleScrollViewDatasource> datasource;
@property (nonatomic, weak) id<CycleScrollViewDelegate> delegate;

- (void)reloadData;
- (void)startTimer;
- (void)stopTimer; //must be called so that self can be dealloc

//- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index;

@end


@protocol CycleScrollViewDelegate <NSObject>
- (void)cycleView:(CycleScrollView *)cycleView didSelectPageAtIndex:(NSInteger)index;
@end


@protocol CycleScrollViewDatasource <NSObject>
@required
- (NSInteger)numberOfCycleScrollViewPage;
- (UIView *)cycleView:(CycleScrollView *)cycleView pageAtIndex:(NSInteger)index;
- (NSString *)cycleView:(CycleScrollView *)cycleView titleAtIndex:(NSInteger)index;
@end
