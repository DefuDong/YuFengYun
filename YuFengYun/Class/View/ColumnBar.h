//
//  ColumnBar.h
//  ColumnBarDemo
//
//  Created by chenfei on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

// 按钮之间的间距
#define kItemWidth 80.f
#define kSpace  1.f

@protocol ColumnBarDataSource;
@protocol ColumnBarDelegate;

@interface ColumnBar : UIView {
    
    UIScrollView    *_scrollView;
    NSMutableArray  *_buttons;
    UIView          *_mover;
}


@property (assign, nonatomic) int                   selectedIndex;

@property (weak, nonatomic) id<ColumnBarDataSource> dataSource;
@property (weak, nonatomic) id<ColumnBarDelegate>   delegate;

- (void)reloadData;
- (void)setSelectedIndex:(int)index animated:(BOOL)animated;
@end



@protocol ColumnBarDataSource <NSObject>
- (int)numberOfTabsInColumnBar:(ColumnBar *)columnBar;
- (NSString *)columnBar:(ColumnBar *)columnBar titleForTabAtIndex:(int)index;
@end

@protocol ColumnBarDelegate <NSObject>
@optional
- (void)columnBar:(ColumnBar *)columnBar didSelectedTabAtIndex:(int)index;
@end
