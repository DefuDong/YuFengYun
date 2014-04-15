//
//  CycleCubicView.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-6-24.
//  Copyright (c) 2013年 董德富. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol CycleCubicViewDelegate;
@protocol CycleCubicViewDatasource;

@interface CycleCubicView : UIView

@property (nonatomic, readonly) NSInteger currentPage;
@property (nonatomic, weak) id<CycleCubicViewDatasource> datasource;
@property (nonatomic, weak) id<CycleCubicViewDelegate> delegate;

- (void)reloadData;
- (void)startTimer;
- (void)stopTimer; //must be called so that self can be dealloc

//- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index;

@end


@protocol CycleCubicViewDelegate <NSObject>
- (void)cycleView:(CycleCubicView *)cycleView didSelectPageAtIndex:(NSInteger)index;
@end


@protocol CycleCubicViewDatasource <NSObject>
@required
- (NSInteger)numberOfCycleCubicViewPage;
- (UIView *)CycleCubicView:(CycleCubicView *)cycleView pageAtIndex:(NSInteger)index;
@end