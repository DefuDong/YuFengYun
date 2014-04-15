//
//  OHASFaceImageParser.h
//  TXiPhone
//  
//  Created by qinxg on 13-10-15.
//
//  本类借鉴与OHAttributedLabel官方例子，想学习更多请下载官方demo zjx

#import <Foundation/Foundation.h>


typedef NSAttributedString*(^TagProcessorBlockType)(NSAttributedString*, NSTextCheckingResult*);

@interface OHASFaceImageParser : NSObject


/*!
 * Call this on concrete subclasses to process tags in an NSMutableAttributedString
 * and apply them (by changing the corresponding attributes)
 *
 * e.g. attrStr = [OHASTagParserHTML replacTagsInAttributedString:mutAttrStr];
 */
+(void)processMarkupInAttributedString:(NSMutableAttributedString*)mutAttrString;

/*!
 * Call this on concrete subclasses to get a parsed NSAttributedString with its attributes
 * changed according to the tags in the original attributed string.
 *
 * Note: this convenience method simply create a mutableCopy of string and use it to call "processMarkupInAttributedString:".
 */
+(NSMutableAttributedString*)attributedStringByProcessingMarkupInAttributedString:(NSAttributedString*)attrString;

/*!
 * Call this on concrete subclasses to get a parsed NSAttributedString with its attributes
 * set according to the tags in the original string.
 *
 * Note: this convenience method simply create a mutableAttributedString from string and use it to call "processMarkupInAttributedString:".
 */
+(NSMutableAttributedString*)attributedStringByProcessingMarkupInString:(NSString*)string;


@end
