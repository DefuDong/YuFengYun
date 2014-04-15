//
//  User_Basic_Cell.h
//  YuFengYun
//
//  Created by 董德富 on 14-1-3.
//  Copyright (c) 2014年 董德富. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UserBasicCellHeight 44
#define UserBasicCellIdentifier @"UserBasicCellIdentifier"


typedef NS_ENUM(NSInteger, UserBasicCellType) {
    UserBasicCellTypeTop,
    UserBasicCellTypeMid,
    UserBasicCellTypeBottom,
    UserBasicCellTypeRound
};

@interface User_Basic_Cell : UITableViewCell

@property (nonatomic, assign) UserBasicCellType type;

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end
