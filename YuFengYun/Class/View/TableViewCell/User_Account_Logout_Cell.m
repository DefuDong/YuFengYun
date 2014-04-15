//
//  User_Basic_Cell.m
//  YuFengYun
//
//  Created by 董德富 on 14-1-3.
//  Copyright (c) 2014年 董德富. All rights reserved.
//

#import "User_Account_Logout_Cell.h"

@implementation User_Account_Logout_Cell

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

- (void)awakeFromNib {
    
    UIImage *image = [UIImage imageNamed:@"table_cell_round.png"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
    self.backImageView.image = image;
}


@end
