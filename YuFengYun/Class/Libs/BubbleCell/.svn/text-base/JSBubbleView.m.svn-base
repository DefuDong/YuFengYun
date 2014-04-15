//
//  Created by Jesse Squires
//  http://www.hexedbits.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSMessagesViewController
//
//
//  The MIT License
//  Copyright (c) 2013 Jesse Squires
//  http://opensource.org/licenses/MIT
//

#import "JSBubbleView.h"

#import "NSString+JSMessagesView.h"
#import "OHASFaceImageParser.h"


#define kMarginTop 8.0f
#define kMarginBottom 4.0f
#define kPaddingTop 4.0f
#define kPaddingBottom 8.0f
#define kBubblePaddingRight 35.0f


@implementation JSBubbleView

#pragma mark - Setup

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame
                   bubbleType:(JSBubbleMessageType)bubleType
              bubbleImageView:(UIImageView *)bubbleImageView
{
    self = [super initWithFrame:frame];
    if(self) {
        [self setup];
        
        _type = bubleType;
        
        bubbleImageView.userInteractionEnabled = YES;
        [self addSubview:bubbleImageView];
        _bubbleImageView = bubbleImageView;
        
        OHAttributedLabel *label = [[OHAttributedLabel alloc] init];
        label.font = [JSBubbleView font];
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:label];
        _messageLabel = label;
    }
    return self;
}

#pragma mark - Setters

- (void)setMessage:(NSString *)message {
    _message = message;
    NSMutableAttributedString *_msgtext = [OHASFaceImageParser attributedStringByProcessingMarkupInString:_message];
    [_msgtext setFont:[JSBubbleView font]];
    _messageLabel.attributedText = _msgtext;
    
//    [self setNeedsDisplay];
    [self setNeedsLayout];
}

#pragma mark - UIAppearance Getters

+ (UIFont *)font
{
    return [UIFont systemFontOfSize:14.0f];
}

#pragma mark - Getters

- (CGRect)bubbleFrame
{
    CGSize bubbleSize = [JSBubbleView neededSizeForText:_message];
    
    return CGRectMake((self.type == JSBubbleMessageTypeOutgoing ? self.frame.size.width - bubbleSize.width : 0.0f),
                      kMarginTop,
                      bubbleSize.width,
                      bubbleSize.height + kMarginTop);
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bubbleImageView.frame = [self bubbleFrame];
    
    CGFloat textX = self.bubbleImageView.frame.origin.x;
    
    if(self.type == JSBubbleMessageTypeIncoming) {
        textX += 20;
    }else {
        textX += 15;
    }
    
    CGSize textSize = [JSBubbleView textSizeForText:_message];
    
    CGRect labelFrame = CGRectMake(textX,
                                  (self.bubbleImageView.frame.size.height - textSize.height) * .5 + self.bubbleImageView.frame.origin.y,
                                  textSize.width,
                                  textSize.height);
    
    self.messageLabel.frame = labelFrame;
}

#pragma mark - Bubble view

+ (CGSize)textSizeForText:(NSString *)txt
{
    CGFloat maxWidth = [UIScreen mainScreen].applicationFrame.size.width * 0.70f;
    NSMutableAttributedString *_msgtext = [OHASFaceImageParser attributedStringByProcessingMarkupInString:txt];
    [_msgtext setFont:[JSBubbleView font]];
    return [_msgtext sizeConstrainedToSize:CGSizeMake(maxWidth, MAXFLOAT)];
}

+ (CGSize)neededSizeForText:(NSString *)text
{
    CGSize textSize = [JSBubbleView textSizeForText:text];
    
	return CGSizeMake(textSize.width + kBubblePaddingRight,
                      textSize.height + kPaddingTop + kPaddingBottom);
}

+ (CGFloat)neededHeightForText:(NSString *)text
{
    CGSize size = [JSBubbleView neededSizeForText:text];
    return size.height + kMarginTop + kMarginBottom;
}

@end