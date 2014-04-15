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

#import "JSBubbleMessageCell.h"
#import "UIColor+JSMessagesView.h"

static const CGFloat kJSLabelPadding = 5.0f;

@implementation JSBubbleMessageCell

#pragma mark - Setup

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.accessoryView = nil;
    
    self.imageView.image = nil;
    self.imageView.hidden = YES;
    self.textLabel.text = nil;
    self.textLabel.hidden = YES;
    self.detailTextLabel.text = nil;
    self.detailTextLabel.hidden = YES;
    
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                             action:@selector(handleLongPressGesture:)];
    [recognizer setMinimumPressDuration:0.4f];
    [self addGestureRecognizer:recognizer];
}


- (void)configureWithBubbleImageView:(UIImageView *)bubbleImageView
{
    CGFloat bubbleY = 0.0f, bubbleX = 0.0f, offsetX = 0.0f;
    CGFloat avatarX = 0.5f;
    
    //avatar
    offsetX = 4.0f;
    bubbleX = 50;
    if(_type == JSBubbleMessageTypeOutgoing) {
        offsetX = 50 - 4.0f;
        avatarX = (self.contentView.frame.size.width - 50);
    }
    
    //head
    CGFloat avatarY = self.contentView.frame.size.height - 50;
    HeadRoundButton *headButton = [HeadRoundButton buttonWithType:UIButtonTypeCustom];
    headButton.frame = CGRectMake(avatarX, avatarY, 50, 50);
    [self addSubview:headButton];
    _headButton = headButton;
    
    //bubble
    CGRect frame = CGRectMake(bubbleX - offsetX,
                              bubbleY,
                              self.contentView.frame.size.width - bubbleX,
                              self.contentView.frame.size.height );
    
    JSBubbleView *bubbleView = [[JSBubbleView alloc] initWithFrame:frame
                                                        bubbleType:_type
                                                   bubbleImageView:bubbleImageView];
    
    bubbleView.autoresizingMask = (UIViewAutoresizingFlexibleWidth
                                    | UIViewAutoresizingFlexibleHeight
                                    | UIViewAutoresizingFlexibleBottomMargin);
    
    [self.contentView addSubview:bubbleView];
    [self.contentView sendSubviewToBack:bubbleView];
    _bubbleView = bubbleView;
}


#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat bubbleY = 0.0f, bubbleX = 0.0f, offsetX = 0.0f;
    CGFloat avatarX = 0.5f;
    
    offsetX = 4.0f;
    bubbleX = 50;
    if(self.type == JSBubbleMessageTypeOutgoing) {
        offsetX = 50 - 4.0f;
        avatarX = (self.contentView.frame.size.width - 50);
    }
    
    CGFloat avatarY = self.contentView.frame.size.height - 50;
    self.headButton.frame = CGRectMake(avatarX, avatarY, 50, 50);
    
    //bubble
    CGRect frame = CGRectMake(bubbleX - offsetX,
                              bubbleY,
                              self.contentView.frame.size.width - bubbleX,
                              self.contentView.frame.size.height );
    
    _bubbleView.frame = frame;
    
}


#pragma mark - Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithBubbleType:(JSBubbleMessageType)type
                   reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self) {
        
        _type = type;
        
        UIColor *color = (type == JSBubbleMessageTypeIncoming)?[UIColor js_bubbleLightGrayColor]:[UIColor js_bubbleBlueColor];
        UIImageView *bubbleImageView = [JSBubbleImageViewFactory bubbleImageViewForType:type
                                                                                  color:color];
        
        [self configureWithBubbleImageView:bubbleImageView];
    }
    return self;
}

- (void)dealloc
{
    _bubbleView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - TableViewCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.bubbleView.messageLabel.attributedText = nil;
}

- (void)setBackgroundColor:(UIColor *)color
{
    [super setBackgroundColor:color];
    [self.contentView setBackgroundColor:color];
    [self.bubbleView setBackgroundColor:color];
}

#pragma mark - Setters

- (void)setMessage:(NSString *)msg
{
    self.bubbleView.message = msg;
}


#pragma mark - Class methods

+ (CGFloat)cellHeightWithText:(NSString *)text
{
    CGFloat avatarHeight = 50;
    
    CGFloat subviewHeights = kJSLabelPadding;
    
    CGFloat bubbleHeight = [JSBubbleView neededHeightForText:text];
    
    return subviewHeights + MAX(avatarHeight, bubbleHeight);
}


#pragma mark - Copying

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)becomeFirstResponder
{
    return [super becomeFirstResponder];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return (action == @selector(copy:));
}

- (void)copy:(id)sender
{
    [[UIPasteboard generalPasteboard] setString:self.bubbleView.message];
    [self resignFirstResponder];
}

#pragma mark - Gestures

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)longPress
{
    if(longPress.state != UIGestureRecognizerStateBegan || ![self becomeFirstResponder])
        return;
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    CGRect targetRect = [self convertRect:[self.bubbleView bubbleFrame]
                                 fromView:self.bubbleView];
    
    [menu setTargetRect:CGRectInset(targetRect, 0.0f, 4.0f) inView:self];
    
    self.bubbleView.bubbleImageView.highlighted = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillShowNotification:)
                                                 name:UIMenuControllerWillShowMenuNotification
                                               object:nil];
    [menu setMenuVisible:YES animated:YES];
}

#pragma mark - Notifications

- (void)handleMenuWillHideNotification:(NSNotification *)notification
{
    self.bubbleView.bubbleImageView.highlighted = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillHideMenuNotification
                                                  object:nil];
}

- (void)handleMenuWillShowNotification:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillShowMenuNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillHideNotification:)
                                                 name:UIMenuControllerWillHideMenuNotification
                                               object:nil];
}

@end