//
//  SearchUser_Cell.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-9-6.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "SearchUser_Cell.h"

@implementation SearchUser_Cell


- (void)awakeFromNib {
    UIImage *image = [UIImage imageNamed:@"first_page_shadow.png"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
    self.backImageView.image = image;
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



//- (void)drawRect:(CGRect)rect {
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(context, 1);
//    CGContextSetStrokeColorWithColor(context, kRGBColor(229, 229, 229).CGColor);
//    CGContextMoveToPoint(context, 10, rect.size.height);
//    CGContextAddLineToPoint(context, rect.size.width-10, rect.size.height);
//    CGContextStrokePath(context);
//}
//

@end
