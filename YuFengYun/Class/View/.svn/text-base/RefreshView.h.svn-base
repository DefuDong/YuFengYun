//
//  RefreshView.h
//  TestRefreshView
//
//  Created by Jason Liu on 12-1-10.
//  Copyright 2012年 Yulong. All rights reserved.
//

// Refresh view controller show label 
#define REFRESH_LOADING_STATUS @"加载中..."
#define REFRESH_PULL_DOWN_STATUS @"下拉可以刷新..."
#define REFRESH_RELEASED_STATUS @"松开即刷新..."
#define REFRESH_UPDATE_TIME_PREFIX @"上次刷新: "
//#define REFRESH_HEADER_HEIGHT 60
#define REFRESH_TRIGGER_HEIGHT 60

typedef void (^RefreshViewCallBack)(void);

#import <UIKit/UIKit.h>
@interface RefreshView : UIView

@property (nonatomic, assign, readonly) BOOL isLoading;
@property (nonatomic, weak, readonly) UIScrollView *owner;
@property (nonatomic, copy) RefreshViewCallBack callBackBlock;

// 初始化并安装refreshView
- (id)initWithOwner:(UIScrollView *)owner callBack:(RefreshViewCallBack)callBack;

// 开始加载和结束加载动画
- (void)startLoading;
- (void)stopLoading;

// 拖动过程中
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
@end

