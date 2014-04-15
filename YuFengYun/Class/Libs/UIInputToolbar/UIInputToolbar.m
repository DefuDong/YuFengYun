/*
 *  UIInputToolbar.m
 *  
 *  Created by Brandon Hamilton on 2011/05/03.
 *  Copyright 2011 Brandon Hamilton.
 *  
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *  
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *  
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 */

#import "UIInputToolbar.h"

@implementation UIInputToolbar

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setupToolbar];
    }
    return self;
}
- (id)init {
    if ((self = [super init])) {
        [self setupToolbar];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupToolbar];
    }
    return self;
}

-(void)setupToolbar {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;
    
    UIImage *backImage = [UIImage imageNamed:@"toolbar_back.png"];
    backImage = [backImage resizableImageWithCapInsets:UIEdgeInsetsMake(5, 1, 1, 1)];
    UIImageView * backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -2, self.frame.size.width, self.frame.size.height+5)];
    backImageView.image = backImage;
    backImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:backImageView];
    
    self.faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.faceButton.frame = CGRectMake(0, 2, 40, 40);
    self.faceButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    [self.faceButton setImage:[UIImage imageNamed:@"input_face.png"] forState:UIControlStateNormal];
    [self.faceButton setImage:[UIImage imageNamed:@"input_keyboard.png"] forState:UIControlStateSelected];
    [self.faceButton addTarget:self action:@selector(faceButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:self.faceButton];
    
    /* Create custom send button*/
    UIImage *image = [UIImage imageNamed:@"table_cell_round.png"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    self.inputButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.inputButton.frame = CGRectMake(self.frame.size.width-55, 5, 50, 28);
    self.inputButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [self.inputButton setTitle:@"发送" forState:UIControlStateNormal];
    self.inputButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.inputButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.inputButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self.inputButton setBackgroundImage:image forState:UIControlStateNormal];
//    [self.inputButton setImage:[UIImage imageNamed:@"input_yes.png"] forState:UIControlStateNormal];
    [self.inputButton addTarget:self action:@selector(inputButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//    [self.inputButton sizeToFit];
    self.inputButton.enabled = NO;
    [self addSubview:self.inputButton];

    /* Create UIExpandingTextView input */
    float width = self.frame.size.width - self.faceButton.frame.size.width - self.inputButton.frame.size.width - 10;
    self.textView = [[[UIExpandingTextView alloc] initWithFrame:CGRectMake(40, 7, width, 26)] autorelease];
    self.textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(4.0f, 0.0f, 10.0f, 0.0f);
    self.textView.delegate = self;
    self.textView.textColor = [UIColor blackColor];
    [self addSubview:self.textView];
}

-(void)inputButtonPressed {
    if ([self.delegate respondsToSelector:@selector(inputButtonPressed:)]) {
        [self.delegate inputButtonPressed:self.textView.text];
    }
    
    /* Remove the keyboard and clear the text */
//    [self.textView resignFirstResponder];
    [self.textView clearText];
}
- (void)faceButtonPressed:(UIButton *)faceButton {
    
    faceButton.selected = !faceButton.selected;
    kInputType type = faceButton.selected ? kInputTypeFaceboard : kInputTypeKeyboard;
    
    if ([self.delegate respondsToSelector:@selector(faceoboardButtonPressed:)]) {
        [self.delegate faceoboardButtonPressed:type];
    }
}


- (void)dealloc {
    [_textView release];
    [_inputButton release];
    [_faceButton release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark UIExpandingTextView delegate

-(void)expandingTextView:(UIExpandingTextView *)expandingTextView willChangeHeight:(float)height {

    /* Adjust the height of the toolbar when the input component expands */
    float diff = (_textView.frame.size.height - height);
    CGRect r = self.frame;
    r.origin.y += diff;
    r.size.height -= diff;
    
    if ([self.delegate respondsToSelector:@selector(inputBar:willChangeHeight:)]) {
        [self.delegate inputBar:self willChangeHeight:r.size.height];
    }
    
    self.frame = r;
}

-(void)expandingTextViewDidChange:(UIExpandingTextView *)expandingTextView {
    /* Enable/Disable the button */
    if ([expandingTextView.text length] > 0)
        self.inputButton.enabled = YES;
    else
        self.inputButton.enabled = NO;
}

@end
