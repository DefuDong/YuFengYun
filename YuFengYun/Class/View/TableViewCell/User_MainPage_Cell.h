//
//  User_MainPage_Cell.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-7-31.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadRoundButton.h"

#define UserMainPageCellHeight 80
#define UserMainPageCellIdentifier @"UserMainPageCellIdentifier"

@interface User_MainPage_Cell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *cellImageView;
@property (nonatomic, strong) IBOutlet UILabel *cellTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;

@end
