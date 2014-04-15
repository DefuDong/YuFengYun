//
//  UserMainPageSegmentView.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-7-30.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserMainPageSegmentViewDelegate <NSObject>
@optional
- (void)mainPageSegmentPressedIndex:(int)index;
@end


@interface UserMainPageSegmentView : UIView

@property (nonatomic, assign) IBOutlet id<UserMainPageSegmentViewDelegate> delegate;
@property (nonatomic, assign) float percent; //0-3

@end
