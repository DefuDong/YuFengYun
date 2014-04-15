//
//  ChatList_Cell.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-9-12.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "ChatList_Cell.h"
#import "SNPopupView.h"
#import "SNPopupView+UsingPrivateMethod.h"

@implementation ChatList_Cell

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

- (void)awakeFromNib {
    self.numberView.hideWhenZero = YES;
    self.numberView.font = [UIFont boldSystemFontOfSize:10];
    self.numberView.shadow = NO;
    self.numberView.shine = NO;
    self.numberView.strokeWidth = 0;
    self.numberView.fillColor = kRGBColor(40, 170, 220);
}

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
    if ([self.delegate respondsToSelector:@selector(chatListCellDeleteDelegate:)]) {
        [self.delegate chatListCellDeleteDelegate:self];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}


//- (void)drawRect:(CGRect)rect {
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(context, 1);
//    CGContextSetStrokeColorWithColor(context, kRGBColor(229, 229, 229).CGColor);
//    CGContextMoveToPoint(context, 10, rect.size.height);
//    CGContextAddLineToPoint(context, rect.size.width-10, rect.size.height);
//    CGContextStrokePath(context);
//}



@end
