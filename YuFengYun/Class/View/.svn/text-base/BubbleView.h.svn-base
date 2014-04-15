
//

#import <UIKit/UIKit.h>
#import "HeadRoundButton.h"


typedef enum {
	BubbleMessageStyleSelf,
	BubbleMessageStyleOther,
} BubbleMessageStyle;



@interface BubbleView : UIView

@property (nonatomic, assign) BubbleMessageStyle style;
@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong) HeadRoundButton *headButton;

#pragma mark - Bubble view 
+ (UIFont *)font;
+ (CGFloat)cellHeightForText:(NSString *)txt;

@end