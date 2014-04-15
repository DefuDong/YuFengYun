//
//  DDFTextView.m
//  DDFTextView
//
//  Created by 董德富 on 13-4-25.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "DDFTextView.h"
#import "DataCenter.h"

static NSString *faceRegexString = @"\\[[\\w\u4e00-\u9fa5]+\\]";//@"@[\\w\u4e00-\u9fa5]+"

@interface DDFTextView () {
    NSMutableArray *_faceRanges;    //表情索引 NSValue——NSRect
    NSMutableString *_drawCachString;
}
@end

@implementation DDFTextView
- (void)setText:(NSString *)text {
    if (_text != text) {
        [_text release];
        _text = [text copy];
        
        [self getFaceCheckedRanges];
        
        [self setNeedsDisplay];
    }
}
- (void)setFont:(UIFont *)font {
    if (_font != font) {
        [_font release];
        _font = [font retain];
        if (_text.length) {
            [self setNeedsDisplay];
        }
    }
}
- (void)setTextColor:(UIColor *)textColor {
    if (_textColor != textColor) {
        [_textColor release];
        _textColor = [textColor retain];
        if (_text.length) {
            [self setNeedsDisplay];
        }
    }
}


#pragma mark - pubilc
+ (CGSize)sizeOfText:(NSString *)text
                font:(UIFont *)font
           limitSize:(CGSize)limitSize {
    if (text.length == 0) {
        return CGSizeZero;
    }
    
    NSMutableArray *rangeArray = [NSMutableArray array];
    NSRegularExpression *faceRegex =
    [NSRegularExpression regularExpressionWithPattern:faceRegexString
                                              options:NSRegularExpressionCaseInsensitive
                                                error:NULL];
    if (faceRegex) {
        NSArray *array = [faceRegex matchesInString:text options:0 range:NSMakeRange(0, text.length)];
        for (NSTextCheckingResult *result in array) {
            NSString *key = [text substringWithRange:result.range];
            NSString *imageName = [[DATA face_text_image] objectForKey:key];
            if (imageName.length) {
                [rangeArray addObject:[NSValue valueWithRange:result.range]];
            }
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    
    CGPoint drawPoint = CGPointZero;
    int lenght = text.length;
    float cHeight = [@" " sizeWithFont:font].height;
    float width = limitSize.width;
    
    
    if (rangeArray.count) {
        int faceIndex = 0;
        int faceBreakIndex = 0;
        
        for (int i = 0; i < lenght; i++) {
            NSRange faceRange = [rangeArray[faceIndex] rangeValue];
            if (i == faceRange.location) {
                //draw per string
                if (faceBreakIndex < i) {
                    NSString *subString = [text substringWithRange:NSMakeRange(faceBreakIndex, i-faceBreakIndex)];
                    CGSize size = [subString sizeWithFont:font];
                    
                    if (drawPoint.x+size.width > width) {
                        drawPoint.y += size.height;
                        
                        subString = [text substringWithRange:NSMakeRange(i-1, 1)];
                        size = [subString sizeWithFont:font];
                        drawPoint.x += size.width;
                    }else {
                        drawPoint.x += size.width;
                    }
                }
                
                if (drawPoint.x + cHeight >= width) {
                    drawPoint.x = 0;
                    drawPoint.y += cHeight;
                }
                drawPoint.x += cHeight;
                
                i += faceRange.length-1;
                if (faceIndex < rangeArray.count-1) {
                    faceIndex++;
                }
                
                faceBreakIndex = i+1;
                
            }else {
                if (faceBreakIndex >= i) continue;
                
                NSString *subString = [text substringWithRange:NSMakeRange(faceBreakIndex, i-faceBreakIndex)];
                CGSize size = [subString sizeWithFont:font];
                
                if (drawPoint.x+size.width == width) {
                    faceBreakIndex = i+1;
                    drawPoint.x = 0;
                    drawPoint.y += size.height;
                }
                else if (drawPoint.x+size.width > width) {
                    faceBreakIndex = i;
                    drawPoint.x = 0;
                    drawPoint.y += size.height;
                }
            }
        }
        
        if (drawPoint.y == 0) return CGSizeMake(drawPoint.x, cHeight);
        return CGSizeMake(width, drawPoint.y + cHeight);
    }
    else {
        return [text sizeWithFont:font constrainedToSize:limitSize lineBreakMode:NSLineBreakByCharWrapping];
    }
}


#pragma mark - init & preset
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self perset];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self perset];
    }
    return self;
}
- (id)init {
    self = [super init];
    if (self) {
        [self perset];
    }
    return self;
}
- (void)perset {
    _faceRanges = [[NSMutableArray alloc] init];
    _drawCachString = [[NSMutableString alloc] init];
    
    _textColor = [[UIColor blackColor] retain];
    _font = [[UIFont systemFontOfSize:16] retain];
    self.backgroundColor = [UIColor clearColor];
}


#pragma mark - draw

- (void)drawRect:(CGRect)rect {
    
    //draw image & text
    CGPoint drawPoint = CGPointZero;
    
    int lenght = _text.length;
    float cHeight = [@" " sizeWithFont:_font].height;
    float width = self.frame.size.width;
    
    [_textColor set];
    
    if (_faceRanges.count) {
        int faceIndex = 0;
        int faceBreakIndex = 0;
        
        for (int i = 0; i < lenght; i++) {
            @autoreleasepool {
                NSRange faceRange = [_faceRanges[faceIndex] rangeValue];
                if (i == faceRange.location) {
                    //draw per string
                    if (faceBreakIndex < i) {
                        NSString *subString = [_text substringWithRange:NSMakeRange(faceBreakIndex, i-faceBreakIndex)];
                        CGSize size = [subString sizeWithFont:_font];
                        
                        if (drawPoint.x+size.width > width) {
                            subString = [_text substringWithRange:NSMakeRange(faceBreakIndex, i-faceBreakIndex-1)];
                            [subString drawInRect:CGRectMake(drawPoint.x, drawPoint.y, width-drawPoint.x, size.height) withFont:_font];
                            drawPoint.x = 0;
                            drawPoint.y += size.height;
                            
                            subString = [_text substringWithRange:NSMakeRange(i-1, 1)];
                            size = [subString sizeWithFont:_font];
                            [subString drawInRect:CGRectMake(0, drawPoint.y, size.width, size.height) withFont:_font];
                            drawPoint.x += size.width;
                        }else {
                            [subString drawInRect:CGRectMake(drawPoint.x, drawPoint.y, size.width, size.height) withFont:_font];
                            drawPoint.x += size.width;
                        }
                    }
                    
                    if (drawPoint.x + cHeight >= width) {
                        drawPoint.x = 0;
                        drawPoint.y += cHeight;
                    }
                    NSString *name = [_text substringWithRange:NSMakeRange(faceRange.location, faceRange.length)];
                    UIImage *image = [UIImage imageNamed:[self imageName:name]];
                    [image drawInRect:CGRectMake(drawPoint.x+2, drawPoint.y+3, 13, 13)];
                    drawPoint.x += cHeight;
                    
                    i += faceRange.length-1;
                    if (faceIndex < _faceRanges.count-1) {
                        faceIndex++;
                    }
                    
                    faceBreakIndex = i+1;
                    
                }else {
                    if (faceBreakIndex >= i) continue;
                    
                    NSString *subString = [_text substringWithRange:NSMakeRange(faceBreakIndex, i-faceBreakIndex)];
                    CGSize size = [subString sizeWithFont:_font];
                    
                    if (drawPoint.x+size.width == width) {
                        [subString drawInRect:CGRectMake(drawPoint.x, drawPoint.y, size.width, size.height) withFont:_font];
                        faceBreakIndex = i+1;
                        drawPoint.x = 0;
                        drawPoint.y += size.height;
                    }else if (drawPoint.x+size.width > width) {
                        subString = [_text substringWithRange:NSMakeRange(faceBreakIndex, i-faceBreakIndex-1)];
                        [subString drawInRect:CGRectMake(drawPoint.x, drawPoint.y, width-drawPoint.x, size.height) withFont:_font];
                        faceBreakIndex = i;
                        drawPoint.x = 0;
                        drawPoint.y += size.height;
                    }
                    else if (i == lenght - 1) {
                        subString = [_text substringFromIndex:faceBreakIndex];
                        [subString drawInRect:CGRectMake(drawPoint.x, drawPoint.y, width-drawPoint.x, cHeight) withFont:_font];
                        
                    }
                }
                
            }
            
            /*
             //image
             if (_faceRanges.count) {
             NSRange faceRange = [_faceRanges[faceIndex] rangeValue];
             if (i == faceRange.location) {
             if (drawPoint.x + cHeight > width) {
             drawPoint.x = 0;
             drawPoint.y += cHeight;
             }
             NSString *name = [_text substringWithRange:NSMakeRange(faceRange.location, faceRange.length)];
             UIImage *image = [UIImage imageNamed:[self imageName:name]];
             [image drawInRect:CGRectMake(drawPoint.x+2, drawPoint.y+3, 13, 13)];
             drawPoint.x += cHeight;
             
             i += faceRange.length-1;
             if (faceIndex < _faceRanges.count-1) {
             faceIndex++;
             }
             continue;
             }
             }
             
             //text
             NSString *aString = [_text substringWithRange:NSMakeRange(i, 1)];
             CGSize size = [aString sizeWithFont:_font];
             
             if (drawPoint.x + size.width > width) {
             drawPoint.x = 0;
             drawPoint.y += cHeight;
             }
             CGRect rect = CGRectMake(drawPoint.x, drawPoint.y, size.width, size.height);
             
             
             [aString drawInRect:rect withFont:_font];
             drawPoint.x += size.width;
             */
        }
    }
    else {
        [_text drawInRect:rect withFont:_font lineBreakMode:NSLineBreakByCharWrapping];
    }
    
}


#pragma mark - private
- (void)getFaceCheckedRanges {
    [_faceRanges removeAllObjects];
    NSRegularExpression *faceRegex =
    [NSRegularExpression regularExpressionWithPattern:faceRegexString
                                              options:NSRegularExpressionCaseInsensitive
                                                error:NULL];
    if (faceRegex) {
        NSArray *array = [faceRegex matchesInString:_text options:0 range:NSMakeRange(0, _text.length)];
        for (NSTextCheckingResult *result in array) {
            NSString *text = [_text substringWithRange:result.range];
            if ([self imageName:text]) {
                [_faceRanges addObject:[NSValue valueWithRange:result.range]];
            }
        }
    }
}
- (NSString *)imageName:(NSString *)key {
    NSString *imageName = [[DATA face_text_image] objectForKey:key];
    if (imageName.length) {
        return [imageName stringByAppendingString:@"_.png"];
    }
    return nil;
}


#pragma mark - others
- (void)layoutSubviews {
    [super layoutSubviews];
    [self setNeedsDisplay];
}

- (void)dealloc {
    [_text release];
    [_textColor release];
    [_font release];
    
    [_faceRanges release];
    [_drawCachString release];
    
    [super dealloc];
}

@end

