//
// 
//  YunHuaShiDai
//
//  Created by 董德富 on 13-7-15.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadRoundButton.h"
#import "NameReplayView.h"
#import "OHAttributedLabel.h"
#import "OHASFaceImageParser.h"


#define DiscussTitleCellHeight 110
#define DiscussTitleCellIdentifier @"DiscussTitleCellIdentifier"

@protocol DiscussCellDelegate;
@interface Discuss_Title_Cell : UITableViewCell

@property (nonatomic, strong) IBOutlet HeadRoundButton *headButton;
@property (nonatomic, strong) IBOutlet NameReplayView *nameView;
@property (nonatomic, strong) IBOutlet OHAttributedLabel *detailLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) IBOutlet UIView *titleView;
@property (nonatomic, strong) IBOutlet UIButton *articleTitleButton;
@property (nonatomic, strong) IBOutlet UILabel *articleTitleLabel;

@property (nonatomic, strong) IBOutlet UILongPressGestureRecognizer *longPress;

@property (nonatomic, weak) id<DiscussCellDelegate> delegate;

+ (float)cellHeight:(NSString *)string;

@end



@protocol DiscussCellDelegate <NSObject>
@optional
- (void)discussCellDeleteDelegate:(Discuss_Title_Cell *)cell;

@end