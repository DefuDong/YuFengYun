//
//  User_Basic_Cell.m
//  YuFengYun
//
//  Created by 董德富 on 14-1-3.
//  Copyright (c) 2014年 董德富. All rights reserved.
//

#import "User_Account_Basic_Cell.h"

@interface User_Account_Basic_Cell()
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@end

@implementation User_Account_Basic_Cell

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


- (void)setFirstText:(NSString *)firstText {
    _firstText = firstText;
    _firstLabel.text = _firstText;
    
    CGSize size = [_firstText sizeWithFont:self.firstLabel.font];
    CGRect rect1 = _firstLabel.frame;
    rect1.size.width = size.width;
    _firstLabel.frame = rect1;
    
    CGRect rect2 = _textField.frame;
    rect2.origin.x = rect1.origin.x + rect1.size.width + 5;
    rect2.size.width = self.frame.size.width - rect2.origin.x - 35;
    _textField.frame = rect2;
}


- (void)setType:(UserAccountBasicCellType)type {
    _type = type;
    
    UIImage *image = nil;
    
    switch (_type) {
        case UserAccountBasicCellTypeRound: {
            image = [UIImage imageNamed:@"table_cell_round.png"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
        }
            break;
        case UserAccountBasicCellTypeTop: {
            image = [UIImage imageNamed:@"table_cell_top.png"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(6, 10, 2, 10)];
        }
            break;
        case UserAccountBasicCellTypeMid: {
            image = [UIImage imageNamed:@"table_cell_mid_line.png"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(1, 10, 1, 10)];
        }
            break;
        case UserAccountBasicCellTypeBottom: {
            image = [UIImage imageNamed:@"table_cell_bottom.png"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(2, 10, 10, 6)];
        }
            break;
        default:
            break;
    }
    self.backImageView.image = image;
}


//- (void)drawRect:(CGRect)rect {
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetStrokeColorWithColor(context, kRGBColor(53, 75, 88).CGColor);
//    CGContextSetLineWidth(context, .5);
//    
//    CGContextMoveToPoint(context, 9, 0);
//    CGContextAddLineToPoint(context, rect.size.width-18, 0);
//    CGContextMoveToPoint(context, 9, rect.size.height);
//    CGContextAddLineToPoint(context, rect.size.width-18, rect.size.height);
//    
//    CGContextStrokePath(context);
//}



@end
