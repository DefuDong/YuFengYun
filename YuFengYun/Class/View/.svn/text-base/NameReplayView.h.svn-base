//
//  NameReplayView.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-7-15.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol NameReplayViewDelegate;
@interface NameReplayView : UIView

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *replayName;

@property (nonatomic, weak) IBOutlet id<NameReplayViewDelegate> delegate;
@end





@protocol NameReplayViewDelegate <NSObject>
@optional
- (void)nameReplayViewCallBack:(NSString *)name;
- (void)nameReplayView:(NameReplayView *)replayView index:(unsigned)index;

@end
