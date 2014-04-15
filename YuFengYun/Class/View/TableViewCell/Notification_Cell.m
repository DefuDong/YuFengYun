//
//  Discuss_Cell.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-7-15.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "Notification_Cell.h"
#import <QuartzCore/QuartzCore.h>
#import "SNPopupView.h"
#import "SNPopupView+UsingPrivateMethod.h"


@implementation Notification_Cell

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
    
//    float orgin_y = self.detailLabel.frame.origin.y;
    CGSize size = [self.detailLabel.text sizeWithFont:self.detailLabel.font
                                    constrainedToSize:CGSizeMake(self.detailLabel.frame.size.width, 1000)];
    CGRect rect = self.detailLabel.frame;
    rect.size.height = size.height;
    self.detailLabel.frame = rect;
    
//    orgin_y += self.detailLabel.frame.size.height + 5;
    
//    CGRect rect2 = self.timeLabel.frame;
//    rect2.origin.y = orgin_y;
//    self.timeLabel.frame = rect2;
    
    [self setNeedsDisplay];
}

+ (float)cellHeight:(NSString *)string {
    float orgin_y = 10.0f;
    float width = 237.0f;
    
    CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:16]
                     constrainedToSize:CGSizeMake(width, 1000)];
    
    float cellHeight = orgin_y + size.height + 5 + 16 + 5;
    if (cellHeight > NotificationCellHeight) {
        return cellHeight;
    }else {
        return NotificationCellHeight;
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
    if ([self.delegate respondsToSelector:@selector(notificationCellDeleteDelegate:)]) {
        [self.delegate notificationCellDeleteDelegate:self];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}


@end
