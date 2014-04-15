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

#import <UIKit/UIKit.h>
#import "JSBubbleView.h"
#import "HeadRoundButton.h"

/**
 *  The `JSBubbleMessageCell` class defines the attributes and behavior of the cells that appear in `JSMessagesViewController`. This class includes properties and methods for setting and managing cell content.
 */
@interface JSBubbleMessageCell : UITableViewCell

@property (weak, nonatomic, readonly) JSBubbleView *bubbleView;
@property (weak, nonatomic, readonly) HeadRoundButton *headButton;
@property (assign, nonatomic, readonly) JSBubbleMessageType type;

#pragma mark - Initialization
- (instancetype)initWithBubbleType:(JSBubbleMessageType)type
                   reuseIdentifier:(NSString *)reuseIdentifier;

#pragma mark - Setters

/**
 *  Sets the message to be displayed in the bubbleView of the cell.
 *
 *  @param msg The message text for the cell.
 */
- (void)setMessage:(NSString *)msg;


#pragma mark - Class methods

/**
 *  Computes and returns the minimum necessary height of a `JSBubbleMessageCell` needed to display its contents.
 *
 *  @param text         The text to display in the cell.
 *  @param hasTimestamp A boolean value indicating whether or not the cell has a timestamp.
 *  @param hasAvatar    A boolean value indicating whether or not the cell has an avatar.
 *  @param hasSubtitle  A boolean value indicating whether or not the cell has a subtitle.
 *
 *  @return The height required for the frame of the cell in order for the cell to display the entire contents of its subviews.
 */
+ (CGFloat)cellHeightWithText:(NSString *)text;

@end