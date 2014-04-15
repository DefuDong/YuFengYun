//
//  PullUpView.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-14.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PullUpComplete)(void);
typedef NS_ENUM(NSInteger, PullUpViewType) {
    PullUpViewTypeNormal = 0,
    PullUpViewTypeLoading,
    PullUpViewTypeNextPage,
    PullUpViewTypeNoMore,
};

@interface PullUpView : UIView

@property (nonatomic, weak, readonly) UITableView *owner;
@property (nonatomic, strong, readonly) UIButton *button;

@property (nonatomic, assign) PullUpViewType type;
@property (nonatomic, copy) PullUpComplete completeBlock;


- (id)initWithOwner:(UITableView *)owner complete:(PullUpComplete)block;

- (void)tableViewDidScroll:(UITableView *)tableView;

@end
