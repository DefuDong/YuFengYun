//
//  Chat_Bubble_Cell.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-7-2.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BubbleView.h"

@interface Chat_Bubble_Cell : UITableViewCell

@property (nonatomic, strong) BubbleView *bubbleView;

+ (CGFloat)cellHeightWithText:(NSString *)text;

@end
