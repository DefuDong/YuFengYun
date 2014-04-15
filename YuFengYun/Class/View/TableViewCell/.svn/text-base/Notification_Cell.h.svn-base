//
//  YunHuaShiDai
//
//  Created by 董德富 on 13-7-15.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NotificationCellHeight 71
#define NotificationCellIdentifier @"NotificationCellIdentifier"

@protocol NotificationCellDelegate;
@interface Notification_Cell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *detailLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) IBOutlet UILongPressGestureRecognizer *longPress;

@property (nonatomic, weak) id<NotificationCellDelegate> delegate;

+ (float)cellHeight:(NSString *)string;

@end



@protocol NotificationCellDelegate <NSObject>
@optional
- (void)notificationCellDeleteDelegate:(Notification_Cell *)cell;

@end