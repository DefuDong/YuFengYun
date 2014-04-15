//
//  DDFTextView.h
//  DDFTextView
//
//  Created by 董德富 on 13-4-25.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDFTextView : UIView

@property (nonatomic, copy) NSString *text;
@property (nonatomic, retain) UIFont *font;
@property (nonatomic, retain) UIColor *textColor;

+ (CGSize)sizeOfText:(NSString *)text
               font:(UIFont *)font
          limitSize:(CGSize)limitSize;

@end
