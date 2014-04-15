//
//  Chat_Bubble_Cell.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-7-2.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "Chat_Bubble_Cell1.h"
#import "HeadRoundButton.h"
#import "UIButton+WebCache.h"

#define kCellMarginTop      8.0f
#define kCellMarginBottom   4.0f

#define kHeadWidth      40.0f
#define kDistanceHead   10.0f
#define kDistanceMess   5.0f


#define kBubbleMaxWidth 240.0f
#define kSelfLabelEdgeInset UIEdgeInsetsMake(8, 5, 8, 13)
#define kOtherLabelEdgeInset UIEdgeInsetsMake(8, 13, 8, 5)

@interface ChatBubbleView : UIImageView

@property (nonatomic, assign) NSString *text;
@property (nonatomic, assign) ChatBubbleCellStyle style;

+ (UIFont *)textFont;
+ (CGSize)bubbleSize:(NSString *)text;

@end


@implementation Chat_Bubble_Cell1 {
    
    HeadRoundButton *_headImageButton;
    ChatBubbleView *_bubbleView;
}
- (void)setStyle:(ChatBubbleCellStyle)style {
    _style = style;
    _bubbleView.style = _style;
    [self setNeedsLayout];
}
- (void)setHeadImageURL:(NSURL *)headImageURL {
    if (_headImageURL != headImageURL) {
        _headImageURL = headImageURL;
        [_headImageButton setImageWithURL:headImageURL forState:UIControlStateNormal];
    }
}
- (void)setText:(NSString *)text {
    if (_text != text) {
        _text = text;
        _bubbleView.text = _text;
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _headImageButton = [HeadRoundButton buttonWithType:UIButtonTypeCustom];
        _headImageButton.frame = CGRectMake(0, 0, kHeadWidth, kHeadWidth);
        [self.contentView addSubview:_headImageButton];
        
        _bubbleView = [[ChatBubbleView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_bubbleView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = [ChatBubbleView bubbleSize:self.text];
    if (self.style == ChatBubbleCellStyleSelf) {
        _headImageButton.frame = CGRectMake(self.frame.size.width-kDistanceHead-kHeadWidth,
                                            5, kHeadWidth, kHeadWidth);
        _bubbleView.frame = CGRectMake(self.frame.size.width-kDistanceHead-kHeadWidth-kDistanceMess-size.width,
                                       kCellMarginTop, size.width, size.height);
    } else {
        _headImageButton.frame = CGRectMake(kDistanceHead, 5, kHeadWidth, kHeadWidth);
        _bubbleView.frame = CGRectMake(kDistanceHead+kHeadWidth+kDistanceMess, kCellMarginTop, size.width, size.height);
    }
}

+ (CGFloat)cellHeightWithText:(NSString *)text {
    CGSize bubbleSize = [ChatBubbleView bubbleSize:text];
    return bubbleSize.height + kCellMarginTop + kCellMarginBottom;
}

@end




@implementation ChatBubbleView {
    UILabel *_label;
}

+ (UIFont *)textFont {
    return [UIFont systemFontOfSize:17];
}
+ (CGSize)bubbleSize:(NSString *)text {
    float textLimitWidth = kBubbleMaxWidth - kSelfLabelEdgeInset.right - kSelfLabelEdgeInset.left;
    CGSize size = [text sizeWithFont:[ChatBubbleView textFont] constrainedToSize:CGSizeMake(textLimitWidth, 1000)];
    CGSize bubbleSize = CGSizeMake(size.width+kSelfLabelEdgeInset.left+kSelfLabelEdgeInset.right,
                                   size.height+kSelfLabelEdgeInset.top+kSelfLabelEdgeInset.bottom);
    return bubbleSize;
}

- (void)setStyle:(ChatBubbleCellStyle)style {
    _style = style;
    
    UIImage *image = [self bubleImageHighlighted:NO];
    UIImage *highImage = [self bubleImageHighlighted:YES];
    [self setImage:image];
    [self setHighlightedImage:highImage];
    
    if (_style == ChatBubbleCellStyleSelf) {
        _label.textColor = [UIColor whiteColor];
    } else {
        _label.textColor = [UIColor blackColor];
    }
}
- (void)setText:(NSString *)text {
    if (_text != text) {
        _text = text;
        _label.text = _text;
    }
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self loadSubviews];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self loadSubviews];
    }
    return self;
}
- (void)loadSubviews {
    self.userInteractionEnabled = YES;
    
    _label = [[UILabel alloc] init];
    _label.font = [ChatBubbleView textFont];
    _label.backgroundColor = [UIColor clearColor];
    _label.numberOfLines = 0;
    [self addSubview:_label];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    [self addGestureRecognizer:longPress];
    
//    [NOTI_CENTER addObserver:self selector:@selector(menuShow:) name:UIMenuControllerWillShowMenuNotification object:nil];
    [NOTI_CENTER addObserver:self selector:@selector(menuHide:) name:UIMenuControllerWillHideMenuNotification object:nil];
}
- (void)dealloc {
    [NOTI_CENTER removeObserver:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIEdgeInsets inset = self.style==ChatBubbleCellStyleOther ? kOtherLabelEdgeInset : kSelfLabelEdgeInset;
    CGRect frame = CGRectMake(inset.left,
                              inset.top,
                              self.frame.size.width - inset.left - inset.right,
                              self.frame.size.height - inset.top - inset.bottom);
    _label.frame = frame;
}

- (UIImage *)bubleImageHighlighted:(BOOL)highlighted {
    NSString *imageName = nil;
    UIEdgeInsets edgeInset;
    if (self.style == ChatBubbleCellStyleOther) {
        edgeInset = UIEdgeInsetsMake(25, 7, 3, 2);
        imageName = highlighted ? @"message_bubble_other_2.png" : @"message_bubble_other.png";
    }else {
        edgeInset = UIEdgeInsetsMake(25, 2, 3, 7);
        imageName = highlighted ? @"message_bubble_self_2.png" : @"message_bubble_self.png";
    }
    
    return [[UIImage imageNamed:imageName] resizableImageWithCapInsets:edgeInset];
}

- (void)longPressed:(UILongPressGestureRecognizer *)ges {
    if (ges.state == UIGestureRecognizerStateBegan) {
        self.highlighted = YES;
        
        [self becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setTargetRect:self.bounds inView:self];
        [menu setMenuVisible:YES animated:YES];
    }
//    else if (ges.state == UIGestureRecognizerStateCancelled || ges.state == UIGestureRecognizerStateEnded) {
//        self.highlighted = NO;
//    }
}
- (void)menuHide:(NSNotification *)note {
    if (self.highlighted) {
        self.highlighted = NO;
    }
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copy:)) {
        return YES;
    }else {
        return [super canPerformAction:action withSender:sender];
    }
}
- (void)copy:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.text];
    self.highlighted = NO;
    [self resignFirstResponder];
}


@end

