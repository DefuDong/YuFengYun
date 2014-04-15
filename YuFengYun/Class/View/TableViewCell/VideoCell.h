//
//  VideoCell.h
//  YuFengYun
//
//  Created by 董德富 on 13-12-6.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import <UIKit/UIKit.h>

#define VideoCellCellHeight 95
#define VideoCellIdentifier @"VideoCellIdentifier"


@interface VideoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView_;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel_;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end
