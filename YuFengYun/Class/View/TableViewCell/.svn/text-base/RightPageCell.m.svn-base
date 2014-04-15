//
//  RightPageCell.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-7-11.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "RightPageCell.h"
//#import "MKNumberBadgeView.h"
#import "NumberView.h"

const float x = 90;

@implementation RightPageCell
- (void)setCellImage:(UIImage *)cellImage {
    CGSize size = cellImage.size;
    CGRect rect = _cellImageView.frame;
    rect.size = size;
    _cellImageView.frame = rect;
    _cellImageView.center = CGPointMake(x, self.frame.size.height*.5);
    
    _cellImageView.image = cellImage;
}
- (UIImage *)cellImage {
    return _cellImageView.image;
}

- (void)setCellTitle:(NSString *)cellTitle {
    _cellTitleLabel.text = cellTitle;
}
- (NSString *)cellTitle {   
    return _cellTitleLabel.text;
}

- (void)setCellValue:(NSInteger)cellValue {
//    _cellValueView.value = cellValue;
    _cellValueView.number = [[NSNumber numberWithInt:cellValue] stringValue];
}
- (NSInteger)cellValue {
//    return _cellValueView.value;
    return [_cellValueView.number integerValue];
}



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGSize size = self.frame.size;
        float centerY = size.height * .5;
        
        _cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        _cellImageView.center = CGPointMake(x, centerY);
        [self addSubview:_cellImageView];
        
        _cellTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, size.height)];
        _cellTitleLabel.center = CGPointMake(x + 50, centerY);
        _cellTitleLabel.backgroundColor = [UIColor clearColor];
        _cellTitleLabel.textColor = [UIColor whiteColor];
        _cellTitleLabel.font = [UIFont boldSystemFontOfSize:16];
        [self addSubview:_cellTitleLabel];
        
        
        _cellValueView = [[NumberView alloc] initWithFrame:CGRectMake(x+55, 10, 43, 24)];
        [self addSubview:_cellValueView];
        
//        _cellValueView = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(x + 30, 0, 50, 20)];
//        _cellValueView.font = [UIFont systemFontOfSize:10];
//        _cellValueView.strokeWidth = 0;
//        _cellValueView.shine = NO;
//        _cellValueView.shadow = NO;
////        _cellValueView.alignment = UITextAlignmentLeft;
//        _cellValueView.fillColor = [UIColor redColor];
//        _cellValueView.shadow = NO;
//        _cellValueView.hideWhenZero = YES;
//        [self addSubview:_cellValueView];
        
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.backgroundColor = [UIColor clearColor];
        
        UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
        backView.backgroundColor = kRGBColor(53, 75, 88);
        self.selectedBackgroundView = backView;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, .5);
    CGContextMoveToPoint(context, 20, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width - 20, rect.size.height);
    CGContextStrokePath(context);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
