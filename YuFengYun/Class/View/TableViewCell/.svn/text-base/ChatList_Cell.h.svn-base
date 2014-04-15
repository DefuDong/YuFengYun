//
//  ChatList_Cell.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-9-12.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadRoundButton.h"
#import "MKNumberBadgeView.h"
#import "OHASFaceImageParser.h"
#import "OHAttributedLabel.h"

#define ChatListCellHeight 70
#define ChatListCellIdentifier @"ChatListCellIdentifier"

@protocol ChatListCellDelegate; 
@interface ChatList_Cell : UITableViewCell

@property (nonatomic, strong) IBOutlet HeadRoundButton *headButtn;
@property (nonatomic, strong) IBOutlet MKNumberBadgeView *numberView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet OHAttributedLabel *messageLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) IBOutlet UILongPressGestureRecognizer *longPress;

@property (nonatomic, weak) id<ChatListCellDelegate> delegate;

@end




@protocol ChatListCellDelegate <NSObject>
@optional
- (void)chatListCellDeleteDelegate:(ChatList_Cell *)cell;

@end