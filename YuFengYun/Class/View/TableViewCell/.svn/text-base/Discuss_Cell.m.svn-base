//
//  Discuss_Cell.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-7-15.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "Discuss_Cell.h"
#import <QuartzCore/QuartzCore.h>
#import "SNPopupView.h"
#import "SNPopupView+UsingPrivateMethod.h"


@implementation Discuss_Cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    CGSize size = [self.detailLabel.text sizeWithFont:self.detailLabel.font
//                                    constrainedToSize:CGSizeMake(self.detailLabel.frame.size.width, 1000)];
//    CGSize size = [DDFTextView sizeOfText:self.detailLabel.text
//                                        font:self.detailLabel.font
//                                   limitSize:CGSizeMake(self.detailLabel.frame.size.width, 1000)];
    CGSize size = [self.detailLabel.attributedText sizeConstrainedToSize:CGSizeMake(self.detailLabel.frame.size.width, MAXFLOAT)];
    CGRect rect = self.detailLabel.frame;
    rect.size.height = size.height;
    self.detailLabel.frame = rect;
    
    [self setNeedsDisplay];
}

+ (float)cellHeight:(NSString *)string {
    float orgin_y = 30.0f;
    float width = 237.0f;
    
//    CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:12]
//                     constrainedToSize:CGSizeMake(width, 1000)];
//    CGSize size = [DDFTextView sizeOfText:string
//                                        font:[UIFont systemFontOfSize:16]
//                                   limitSize:CGSizeMake(width, 1000)];
   
    NSMutableAttributedString *_msgtext = [OHASFaceImageParser attributedStringByProcessingMarkupInString:string];
    [_msgtext setFont:[UIFont systemFontOfSize:16]];
    //    [_msgtext setTextAlignment:kCTLeftTextAlignment lineBreakMode:kCTLineBreakByCharWrapping];
    CGSize size = [_msgtext sizeConstrainedToSize:CGSizeMake(width, MAXFLOAT)];
   
    if ((orgin_y + size.height + 19) > DiscussCellHeight) {
        return orgin_y + size.height + 19;
    }else {
        return DiscussCellHeight;
    }
}

//- (void)drawRect:(CGRect)rect {
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(context, 1);
//    CGContextSetStrokeColorWithColor(context, kRGBColor(229, 229, 229).CGColor);
//    CGContextMoveToPoint(context, 10, rect.size.height);
//    CGContextAddLineToPoint(context, rect.size.width-10, rect.size.height);
//    CGContextStrokePath(context);
//}


- (IBAction)longPressed:(id)sender {
//    UIMenuController *menu = [UIMenuController sharedMenuController];
    UILongPressGestureRecognizer *longPre = (UILongPressGestureRecognizer *)sender;
    if (longPre.state == UIGestureRecognizerStateBegan) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        imageView.image = [UIImage imageNamed:@"delete_cell.png"];
        
        SNPopupView *popView = [[SNPopupView alloc] initWithContentView:imageView
                                                            contentSize:imageView.frame.size];
        CGPoint point = [longPre locationInView:self];
        [popView presentModalAtPoint:point inView:self animated:YES];
        [popView addTarget:self action:@selector(deleteButtonPressed:)];
        
        [self setSelected:NO animated:NO];
    }
}

- (void)deleteButtonPressed:(SNPopupView *)pop {
    [pop dismissModal];
    if ([self.delegate respondsToSelector:@selector(discussCellDeleteDelegate:)]) {
        [self.delegate discussCellDeleteDelegate:self];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}


@end
