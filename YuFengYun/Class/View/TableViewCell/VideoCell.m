//
//  VideoCell.m
//  YuFengYun
//
//  Created by 董德富 on 13-12-6.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "VideoCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation VideoCell

- (void)awakeFromNib {
    UIImage *image = [UIImage imageNamed:@"first_page_shadow.png"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
    self.backImageView.image = image;
    
    self.imageView_.layer.cornerRadius = 3;
    self.imageView_.clipsToBounds = YES;
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
