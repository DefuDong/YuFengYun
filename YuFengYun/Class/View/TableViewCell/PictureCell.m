//
//  PictureCell.m
//  YuFengYun
//
//  Created by 董德富 on 13-12-5.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "PictureCell.h"


@interface PictureCell ()
@property (weak, nonatomic) IBOutlet UIImageView *backImageView_1;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView_2;

@property (weak, nonatomic) IBOutlet PictureCellBackView *backView_2;

@end

@implementation PictureCell


- (void)awakeFromNib {
    UIImage *image = [UIImage imageNamed:@"first_page_shadow.png"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
    self.backImageView_1.image = image;
    self.backImageView_2.image = image;
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

- (IBAction)elementTap:(UITapGestureRecognizer *)sender {
    UIView *view = sender.view;
    if ([self.delegate respondsToSelector:@selector(pictureCell:tapAtIndex:)]) {
        [self.delegate pictureCell:self tapAtIndex:view.tag];
    }
}


- (void)setBViewHidden:(BOOL)hide {
    self.backImageView_2.hidden = self.backView_2.hidden = hide;
}

@end



@implementation PictureCellBackView

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
    CGContextMoveToPoint(context, 0, rect.size.height-24);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height-24);
    CGContextStrokePath(context);
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetFillColorWithColor(context, kRGBColor(248, 248, 248).CGColor);
    CGContextAddRect(context, CGRectMake(.5, rect.size.height-23, rect.size.width-1, 23));
    CGContextDrawPath(context, kCGPathEOFillStroke);
}

@end
