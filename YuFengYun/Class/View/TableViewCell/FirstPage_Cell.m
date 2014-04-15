//
//  FirstPage_First_Cell.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-6-21.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "FirstPage_Cell.h"
#import <QuartzCore/QuartzCore.h>

@interface FirstPage_Cell()
@property (weak, nonatomic) IBOutlet UIImageView *shadowImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *timeIcon;
@end


@implementation FirstPage_Cell

- (void)awakeFromNib {
    UIImage *image = [UIImage imageNamed:@"first_page_shadow.png"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
    self.shadowImageView.image = image;
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


- (void)setTimeNumber:(NSString *)timeNumber {
    self.timeLabel.text = timeNumber;
    
    CGSize size = [timeNumber sizeWithFont:self.timeLabel.font];
    CGRect frame = self.timeLabel.frame;
    frame.size.width = size.width;
    frame.origin.x = 255-size.width-2;
    self.timeLabel.frame = frame;
    
    CGRect frame2 = self.timeIcon.frame;
    frame2.origin.x = frame.origin.x-frame2.size.width-4;
    self.timeIcon.frame = frame2;
}
- (NSString *)timeNumber {
    return self.timeLabel.text;
}


@end




@implementation FirstPageCellBackView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self perset];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self perset];
    }
    return self;
}
- (void)perset {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 3;
    self.clipsToBounds = YES;
    
//    self.layer.shadowColor = [UIColor redColor].CGColor;
//    self.layer.shadowRadius = 1;
//    self.layer.shadowOffset = CGSizeMake(0, 0);
//    self.layer.shadowOpacity = 1;
//    self.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.bounds] CGPath];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, kRGBColor(230, 230, 230).CGColor);
    CGContextMoveToPoint(context, 0, rect.size.height-30);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height-30);
    CGContextStrokePath(context);
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetFillColorWithColor(context, kRGBColor(248, 248, 248).CGColor);
    CGContextAddRect(context, CGRectMake(.5, rect.size.height-29, rect.size.width-1, 29));
    CGContextDrawPath(context, kCGPathEOFillStroke);
}

@end


