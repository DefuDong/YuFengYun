//
//  UserMainPageSegmentView.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-7-30.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserMainPageSegmentDelegate <NSObject>
@optional
- (void)mainPageSegmentPressedIndex:(int)index;
@end


@interface UserMainPageSegment : UIView

@property (nonatomic, assign) IBOutlet id<UserMainPageSegmentDelegate> delegate;

- (void)setTitle:(NSString *)title index:(unsigned)index;

@end
