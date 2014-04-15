
//

#import "BubbleView.h"
#import "DDFTextView.h"

#define kMarginTop      8.0f
#define kMarginBottom   4.0f

#define kBubbleSelfEdgeInset UIEdgeInsetsMake(8, 5, 8, 13)
#define kBubbleOtherEdgeInset UIEdgeInsetsMake(8, 13, 8, 5)

#define kHeadWidth      40.0f
#define kDistanceHead   10.0f
#define kDistanceMess   5.0f

#define kBubbleImageWidth 250.0f

@interface BubbleView()
<
  UIActionSheetDelegate
>
@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, strong) DDFTextView *textView;

@end


@implementation BubbleView
#pragma mark - Setters
- (void)setStyle:(BubbleMessageStyle)newStyle {
    _style = newStyle;
    [self setNeedsDisplay];
    [self setNeedsLayout];
}
- (void)setText:(NSString *)newText {
    if (_text != newText) {
        _text = [newText copy];
        self.textView.text = _text;
        [self setNeedsLayout];
    }
}
- (void)setHighlighted:(BOOL)highlighted {
    if (_highlighted != highlighted) {
        _highlighted = highlighted;
        [self setNeedsDisplay];
    }
}

#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self setup];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    
    self.headButton = [HeadRoundButton buttonWithType:UIButtonTypeCustom];
    self.headButton.frame = CGRectMake(0, 5, kHeadWidth, kHeadWidth);
    [self addSubview:self.headButton];
    
    self.textView = [[DDFTextView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.textView];
    
//    UILongPressGestureRecognizer *longPress =
//    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
//    [self addGestureRecognizer:longPress];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rect = self.headButton.frame;
    if (self.style == BubbleMessageStyleOther) {
        rect.origin.x = kDistanceHead;
        self.headButton.frame = rect;
        self.textView.textColor = [UIColor blackColor];
    }else {
        rect.origin.x = self.frame.size.width-rect.size.width-kDistanceHead;
        self.headButton.frame = rect;
        self.textView.textColor = [UIColor whiteColor];
    }
    
    CGSize bubbleSize = [BubbleView bubbleSizeForText:self.text];
    float messDis = kDistanceHead+kHeadWidth+kDistanceMess;
    CGRect bubbleFrame = CGRectMake((self.style==BubbleMessageStyleOther) ? messDis : self.frame.size.width-messDis-bubbleSize.width,
                                    kMarginTop,
                                    bubbleSize.width,
                                    bubbleSize.height);
    
    CGSize textSize = [BubbleView textSizeForText:self.text];
	CGFloat textX = bubbleFrame.origin.x + (self.style==BubbleMessageStyleSelf ? kBubbleSelfEdgeInset.left : kBubbleOtherEdgeInset.left);
    CGRect textFrame = CGRectMake(textX, kBubbleOtherEdgeInset.top + kMarginTop, textSize.width, textSize.height);
    
    self.textView.frame = textFrame;
}

#pragma mark - gesture
/*
- (void)longPress:(UILongPressGestureRecognizer *)ges {
    if (ges.state == UIGestureRecognizerStateBegan) {
        DEBUG_LOG_(@"began");
        self.highlighted = YES;

//        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
//                                                                 delegate:self
//                                                        cancelButtonTitle:@"取消"
//                                                   destructiveButtonTitle:nil
//                                                        otherButtonTitles:@"复制", nil];
//        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
        
        CGSize bubbleSize = [BubbleView bubbleSizeForText:self.text];
        float messDis = kDistanceHead+kHeadWidth+kDistanceMess;
        CGRect bubbleFrame = CGRectMake((self.style==BubbleMessageStyleOther) ? messDis : self.frame.size.width-messDis-bubbleSize.width,
                                        kMarginTop,
                                        bubbleSize.width,
                                        bubbleSize.height);
        
        [self becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setTargetRect:bubbleFrame inView:self];
        [menu setMenuVisible:YES animated:YES];
        
    }
//        else if (ges.state == UIGestureRecognizerStateCancelled) {
//        self.highlighted = NO;
//    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:self.text];
    }
    self.highlighted = NO;
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
*/


#pragma mark - Drawing
- (void)drawRect:(CGRect)rect {
    
    CGSize bubbleSize = [BubbleView bubbleSizeForText:self.text];
    float messDis = kDistanceHead+kHeadWidth+kDistanceMess;
    CGRect bubbleFrame = CGRectMake((self.style==BubbleMessageStyleOther) ? messDis : rect.size.width-messDis-bubbleSize.width,
                                    kMarginTop,
                                    bubbleSize.width,
                                    bubbleSize.height);
    UIImage *image = [self bubleImage];
	[image drawInRect:bubbleFrame];
	
//    self.style == BubbleMessageStyleSelf ? [[UIColor whiteColor] set] : [[UIColor blackColor] set];
//    
//	CGSize textSize = [BubbleView textSizeForText:self.text];
//	CGFloat textX = bubbleFrame.origin.x + (self.style==BubbleMessageStyleSelf ? kBubbleSelfEdgeInset.left : kBubbleOtherEdgeInset.left);
//    CGRect textFrame = CGRectMake(textX, kBubbleOtherEdgeInset.top + kMarginTop, textSize.width, textSize.height);
//	[self.text drawInRect:textFrame
//                 withFont:[BubbleView font]
//            lineBreakMode:NSLineBreakByWordWrapping
//                alignment:(self.style == BubbleMessageStyleSelf) ? NSTextAlignmentRight : NSTextAlignmentLeft];
}

- (UIImage *)bubleImage {
    NSString *imageName = nil;
    UIEdgeInsets edgeInset;
    if (self.style == BubbleMessageStyleOther) {
        edgeInset = UIEdgeInsetsMake(25, 7, 3, 2);
        imageName = self.highlighted ? @"message_bubble_other.png" : @"message_bubble_other.png";
    }else {
        edgeInset = UIEdgeInsetsMake(25, 2, 3, 7);
        imageName = self.highlighted ? @"message_bubble_self.png" : @"message_bubble_self.png";
    }
    
    
    return [[UIImage imageNamed:imageName] resizableImageWithCapInsets:edgeInset];
}


#pragma mark - Bubble view
+ (UIFont *)font {
    return [UIFont systemFontOfSize:16.0f];
}
+ (CGSize)textSizeForText:(NSString *)txt {
    CGFloat width = kBubbleImageWidth - kBubbleOtherEdgeInset.left - kBubbleOtherEdgeInset.right;
        
    return [DDFTextView sizeOfText:txt
                              font:[BubbleView font]
                         limitSize:CGSizeMake(width, 1000)];
}
+ (CGSize)bubbleSizeForText:(NSString *)txt {
	CGSize textSize = [BubbleView textSizeForText:txt];
    float width = textSize.width + kBubbleOtherEdgeInset.left + kBubbleOtherEdgeInset.right;
	return CGSizeMake(width <= kBubbleImageWidth ? width : kBubbleImageWidth,
                      textSize.height + kBubbleOtherEdgeInset.top + kBubbleOtherEdgeInset.bottom);
}
+ (CGFloat)cellHeightForText:(NSString *)txt {
    float height = [BubbleView bubbleSizeForText:txt].height + kMarginTop + kMarginBottom;
    return height;
}


@end