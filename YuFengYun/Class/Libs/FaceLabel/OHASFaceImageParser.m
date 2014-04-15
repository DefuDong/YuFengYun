//
//  OHASFaceImageParser.m
//  TXiPhone
//
//  Created by qinxg on 13-10-15.
//
//

#import "OHASFaceImageParser.h"
#import "NSAttributedString+Attributes.h"
#import "StringUtil.h"

#if __has_feature(objc_arc)
#define MRC_AUTORELEASE(x) (x)
#else
#define MRC_AUTORELEASE(x) [(x) autorelease]
#endif

@interface OHASFaceImageParser ()
+(NSDictionary*)tagMappings; // To be overloaded by subclasses
@end

@implementation OHASFaceImageParser

/* Callbacks */
static void deallocCallback( void* ref ){
    [(id)ref release];
}
static CGFloat ascentCallback( void *ref ){
    return [(NSString*)[(NSDictionary*)ref objectForKey:@"height"] floatValue];
}
static CGFloat descentCallback( void *ref ){
    return 6.0;
}
static CGFloat widthCallback( void* ref ){
    return [(NSString*)[(NSDictionary*)ref objectForKey:@"width"] floatValue];
}

+(NSDictionary*)tagMappings
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            ^NSAttributedString*(NSAttributedString* str, NSTextCheckingResult* match)
                   {
                       NSRange linkRange = [match rangeAtIndex:1];
                       NSRange textRange = [match rangeAtIndex:1];
                       if ((linkRange.length>0) && (textRange.length>0))
                       {
                           NSString* link = [str attributedSubstringFromRange:linkRange].string;
                           //render empty space for drawing the image in the text //1
                           CTRunDelegateCallbacks callbacks;
                           callbacks.version = kCTRunDelegateVersion1;
                           callbacks.getAscent = ascentCallback;
                           callbacks.getDescent = descentCallback;
                           callbacks.getWidth = widthCallback;
                           callbacks.dealloc = deallocCallback;
                           
                           NSDictionary* imgAttr = [[NSDictionary dictionaryWithObjectsAndKeys: //2
                                                     @"19", @"width",
                                                     @"19", @"height",
                                                     nil] retain];
                           
                           CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, imgAttr); //3
                           NSDictionary *attrDictionaryDelegate = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                   //set the delegate
                                                                   (id)delegate, (NSString*)kCTRunDelegateAttributeName,
                                                                   nil];
                           NSString *faceNameStr = [NSString fileNameWithFaceCode:link];
                           if (faceNameStr)
                           {
                               NSMutableAttributedString* foundString = [[NSMutableAttributedString alloc] initWithString:@"·" attributes:attrDictionaryDelegate];
                               [foundString setTextColor:[UIColor clearColor]];
                               [foundString setEmoit:[NSString stringWithFormat:@"%@.png|%@|%@",[NSString fileNameWithFaceCode:link],
                                                      imgAttr[@"width"], imgAttr[@"height"]]];
                               
                               return MRC_AUTORELEASE(foundString);
                           }
                           else
                           {
                               return nil;
                           }

                       } else {
                           return nil;
                       }
                   }, @"\\[([a-zA-Z0-9\\u4e00-\\u9fa5]+?)\\]",//@"\\[\\/([a-zA-Z0-9\\u4e00-\\u9fa5]+?)\\]"    \\[([\\w\\u4e00-\\u9fa5]+?)\\]
                   //可以扩展更多正则表达式 详情请看OHAttribedLabel 官方例子 zjx
                   nil];
}

+(void)processMarkupInAttributedString:(NSMutableAttributedString*)mutAttrString
{
    NSDictionary* mappings = [self tagMappings];
    
    NSRegularExpressionOptions options = NSRegularExpressionAnchorsMatchLines | NSRegularExpressionDotMatchesLineSeparators | NSRegularExpressionUseUnicodeWordBoundaries;
    [mappings enumerateKeysAndObjectsUsingBlock:^(id pattern, id obj, BOOL *stop1)
     {
         TagProcessorBlockType block = (TagProcessorBlockType)obj;
         NSRegularExpression* regEx = [NSRegularExpression regularExpressionWithPattern:pattern options:options error:nil];
         
         NSAttributedString* processedString = [mutAttrString copy];
         __block NSUInteger offset = 0;
         NSRange range = NSMakeRange(0, processedString.length);
         [regEx enumerateMatchesInString:processedString.string options:0 range:range
                              usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop2)
          {
              NSAttributedString* repl = block(processedString, result);
              if (repl)
              {
                  int start =result.range.location - offset;
                  
                  NSRange offsetRange = NSMakeRange(start, result.range.length);
                  //NSLog(@"1111-%@-%@",NSStringFromRange(offsetRange),repl);
                  [mutAttrString replaceCharactersInRange:offsetRange withAttributedString:repl];
                  offset += result.range.length - repl.length;
              }
          }];
#if ! __has_feature(objc_arc)
         [processedString release];
#endif
     }];
    
}

+(NSMutableAttributedString*)attributedStringByProcessingMarkupInAttributedString:(NSAttributedString*)attrString
{
    NSMutableAttributedString* mutAttrString = [attrString mutableCopy];
    [self processMarkupInAttributedString:mutAttrString];
#if ! __has_feature(objc_arc)
    return [mutAttrString autorelease];
#else
    return mutAttrString;
#endif
}

+(NSMutableAttributedString*)attributedStringByProcessingMarkupInString:(NSString*)string
{
    NSMutableAttributedString* mutAttrString = [NSMutableAttributedString attributedStringWithString:string];
    [self processMarkupInAttributedString:mutAttrString];
    return mutAttrString;
}

@end
