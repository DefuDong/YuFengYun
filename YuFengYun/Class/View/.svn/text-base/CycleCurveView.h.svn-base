//
//  CycleCurveView.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-6-21.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CycleCurveViewDelegate;
@protocol CycleCurveViewDatasource;

@interface CycleCurveView : UIView

@property (nonatomic, readonly) NSInteger currentPage;
@property (nonatomic, weak) id<CycleCurveViewDatasource> datasource;
@property (nonatomic, weak) id<CycleCurveViewDelegate> delegate;

- (void)reloadData;
- (void)startTimer;
- (void)stopTimer; //must be called so that self can be dealloc

//- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index;

@end


@protocol CycleCurveViewDelegate <NSObject>
- (void)cycleView:(CycleCurveView *)cycleView didSelectPageAtIndex:(NSInteger)index;
@end


@protocol CycleCurveViewDatasource <NSObject>
@required
- (NSInteger)numberOfCycleCurveViewPage;
- (UIView *)cycleCurveView:(CycleCurveView *)cycleView pageAtIndex:(NSInteger)index;
@end


