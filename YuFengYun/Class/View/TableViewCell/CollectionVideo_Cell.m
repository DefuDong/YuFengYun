//
//  VideoCell.m
//  YuFengYun
//
//  Created by 董德富 on 13-12-6.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "CollectionVideo_Cell.h"
#import <QuartzCore/QuartzCore.h>
#import "SNPopupView.h"
#import "SNPopupView+UsingPrivateMethod.h"

@implementation CollectionVideo_Cell

- (void)awakeFromNib {
    UIImage *image = [UIImage imageNamed:@"first_page_shadow.png"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
    self.backImageView.image = image;
    
    self.imageView_.layer.cornerRadius = 3;
    self.imageView_.clipsToBounds = YES;
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
    if ([self.delegate respondsToSelector:@selector(collectionVideoCellDelete:)]) {
        [self.delegate collectionVideoCellDelete:self];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}

@end
