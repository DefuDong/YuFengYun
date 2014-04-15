//
//  UserInfo_Cell.m
//  YuFengYun
//
//  Created by 董德富 on 14-1-3.
//  Copyright (c) 2014年 董德富. All rights reserved.
//

#import "UserInfo_Cell.h"

@interface UserInfo_Cell()
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@end

@implementation UserInfo_Cell

- (void)awakeFromNib {
    UIImage *image = [UIImage imageNamed:@"table_cell_top.png"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(6, 10, 2, 10)];
    self.backImageView.image = image;
    
    self.headButton.roundColor = [UIColor clearColor];
}

- (void)setName:(NSString *)name {
    
    self.nameLabel.text = name;

    CGSize size = [name sizeWithFont:self.nameLabel.font
                                constrainedToSize:CGSizeMake(160, 20)];
    CGRect frame = self.nameLabel.frame;
    frame.size.width = size.width;
    self.nameLabel.frame = frame;
    
    frame = self.levelImageView.frame;
    frame.origin.x = self.nameLabel.frame.origin.x + self.nameLabel.frame.size.width + 8;
    self.levelImageView.frame = frame;
}

- (void)setDetail:(NSString *)detail {
    
    self.detailLabel.text = detail;
    
//    CGSize size = [detail sizeWithFont:self.detailLabel.font
//                   constrainedToSize:CGSizeMake(self.detailLabel.frame.size.width, MAXFLOAT)];
//    CGRect frame = self.detailLabel.frame;
//    frame.size.height = size.height;
//    self.detailLabel.frame = frame;
    
    [self layoutIfNeeded];
}

- (void)setLevel:(NSString *)level {
    self.levelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"user_level_%@.png", level]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = [self.detailLabel.text sizeWithFont:self.detailLabel.font
                                    constrainedToSize:CGSizeMake(self.detailLabel.frame.size.width, MAXFLOAT)];
    CGRect frame = self.detailLabel.frame;
    frame.size.height = size.height;
    self.detailLabel.frame = frame;
}


+ (float)cellHeight:(NSString *)detail {
    if (!detail || !detail.length) {
        return 86;
    }
    
    CGSize size = [detail sizeWithFont:[UIFont systemFontOfSize:12]
                     constrainedToSize:CGSizeMake(280, MAXFLOAT)];
    return 86 + size.height + 8;
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
