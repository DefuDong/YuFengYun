//
//  UserInfo_Cell.m
//  YuFengYun
//
//  Created by 董德富 on 14-1-3.
//  Copyright (c) 2014年 董德富. All rights reserved.
//

#import "User_Acount_First_Cell.h"

@interface User_Acount_First_Cell()
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;
@end

@implementation User_Acount_First_Cell

- (void)awakeFromNib {
    UIImage *image = [UIImage imageNamed:@"table_cell_top.png"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(6, 10, 2, 10)];
    self.backImageView.image = image;
    
    self.headButton.roundColor = [UIColor clearColor];
}

- (void)setLevel:(NSString *)level {
    self.levelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"user_level_%@.png", level]];
}



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
