//
//  User_Basic_Cell.h
//  YuFengYun
//
//  Created by 董德富 on 14-1-3.
//  Copyright (c) 2014年 董德富. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UserAccountBasicCellHeight 44
#define UserAccountBasicCellIdentifier @"UserAccountBasicCellIdentifier"


typedef NS_ENUM(NSInteger, UserAccountBasicCellType) {
    UserAccountBasicCellTypeTop,
    UserAccountBasicCellTypeMid,
    UserAccountBasicCellTypeBottom,
    UserAccountBasicCellTypeRound
};

@interface User_Account_Basic_Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (nonatomic, assign) UserAccountBasicCellType type;

@property (nonatomic, assign) NSString *firstText;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIImageView *tagImageView;

@end
