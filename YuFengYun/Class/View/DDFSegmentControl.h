//
//  DDFSegmentControl.h
//  YuFengYun
//
//  Created by 董德富 on 13-12-26.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDFSegmentControlDelegate <NSObject>
@optional
- (void)DDFSegmentPressedIndex:(int)index;
@end


@interface DDFSegmentControl : UIView

@property (nonatomic, assign) IBOutlet id<DDFSegmentControlDelegate> delegate;

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, assign) float percent;
- (void)setTitle:(NSString *)title index:(unsigned)index;

@end
