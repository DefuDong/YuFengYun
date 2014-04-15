//
//  LeftPageCell.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-7-23.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "LeftPageCell.h"

@implementation LeftPageCell

- (void)setCellTitle:(NSString *)cellTitle {
    _cellTitleLabel.text = cellTitle;
}
- (NSString *)cellTitle {
    return _cellTitleLabel.text;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGSize size = self.frame.size;
                
        _cellTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 150, size.height)];
        _cellTitleLabel.backgroundColor = [UIColor clearColor];
        _cellTitleLabel.textColor = [UIColor whiteColor];
        _cellTitleLabel.font = [UIFont systemFontOfSize:17];
        _cellTitleLabel.textAlignment = UITextAlignmentLeft;
        [self.contentView addSubview:_cellTitleLabel];
                
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.backgroundColor = [UIColor clearColor];
        
        UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
//        backView.contentMode
        backView.backgroundColor = kRGBColor(53, 75, 88);
        self.selectedBackgroundView = backView;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, kRGBColor(53, 75, 88).CGColor);
    CGContextSetLineWidth(context, 1);
    CGContextMoveToPoint(context, 0, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextStrokePath(context);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
