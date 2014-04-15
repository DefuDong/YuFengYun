//
//  Chat_Bubble_Cell.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-7-2.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "Chat_Bubble_Cell.h"

@implementation Chat_Bubble_Cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.bubbleView = [[BubbleView alloc] initWithFrame:self.contentView.bounds];
        self.bubbleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.contentView addSubview:self.bubbleView];
        [self.contentView sendSubviewToBack:self.bubbleView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeightWithText:(NSString *)text {
    return [BubbleView cellHeightForText:text];
}

@end
