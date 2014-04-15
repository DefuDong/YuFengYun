
#import "StringUtil.h"



static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

const Tface g_faceTable[]={
    
    {"yfy1_",    "[呵呵]",     "呵呵"},
    {"yfy2_",    "[嘻嘻]",     "嘻嘻"},
    {"yfy3_",    "[哈哈]",     "哈哈"},
    {"yfy4_",    "[可爱]",     "可爱"},
    {"yfy5_",    "[可怜]",     "可怜"},
    {"yfy6_",    "[挖鼻孔]",    "挖鼻孔"},
    {"yfy7_",    "[吃惊]",     "吃惊"},
    {"yfy8_",    "[害羞]",     "害羞"},
    {"yfy9_",    "[挤眼]",     "挤眼"},
    {"yfy10_",    "[闭嘴]",     "闭嘴"},
    {"yfy11_",    "[鄙视]",    "鄙视"},
    {"yfy12_",    "[爱你]",    "爱你"},
    {"yfy13_",    "[流泪]",    "流泪"},
    {"yfy14_",    "[偷笑]",    "偷笑"},
    {"yfy15_",    "[亲亲]",    "亲亲"},
    {"yfy16_",    "[生病]",    "生病"},
    {"yfy17_",    "[开心]",    "开心"},
    {"yfy18_",    "[懒得理你]", "懒得理你"},
    {"yfy19_",    "[左哼哼]",   "左哼哼"},
    {"yfy20_",    "[右哼哼]",   "右哼哼"},
    {"yfy21_",    "[嘘]",      "嘘"},
    {"yfy22_",    "[衰]",      "衰"},
    {"yfy23_",    "[委屈]",    "委屈"},
    {"yfy24_",    "[吐]",      "吐"},
    {"yfy25_",    "[打哈欠]",   "打哈欠"},
    {"yfy26_",    "[抱抱]",    "抱抱"},
    {"yfy27_",    "[怒]",      "怒"},
    {"yfy28_",    "[疑问]",    "疑问"},
    {"yfy29_",    "[馋嘴]",    "馋嘴"},
    {"yfy30_",    "[拜拜]",    "拜拜"},
    {"yfy31_",    "[思考]",    "思考"},
    {"yfy32_",    "[汗]",      "汗"},
    {"yfy33_",    "[困]",      "困"},
    {"yfy34_",    "[睡觉]",    "睡觉"},
    {"yfy35_",    "[钱]",      "钱"},
    {"yfy36_",    "[失望]",    "失望"},
    {"yfy37_",    "[酷]",      "酷"},
    {"yfy38_",    "[花心]",    "花心"},
    {"yfy39_",    "[哼]",      "哼"},
    {"yfy40_",    "[鼓掌]",    "鼓掌"},
    {"yfy41_",    "[晕]",      "晕"},
    {"yfy42_",    "[悲伤]",    "悲伤"},
    {"yfy43_",    "[抓狂]",    "抓狂"},
    {"yfy44_",    "[黑线]",    "黑线"},
    {"yfy45_",    "[阴脸]",    "阴脸"},
    {"yfy46_",    "[怒骂]",    "怒骂"},
    {"yfy47_",    "[心]",      "心"},
    {"yfy48_",    "[伤心]",    "伤心"},
    {"yfy49_",    "[猪头]",    "猪头"},
    {"yfy50_",    "[OK]",      "OK"},
    {"yfy51_",    "[耶]",      "耶"},
    {"yfy52_",    "[good]",    "good"},
    {"yfy53_",    "[不要]",    "不要"},
    {"yfy54_",    "[赞]",      "赞"},
    {"yfy55_",    "[来]",      "来"},
    {"yfy56_",    "[弱]",      "弱"},
    {"yfy57_",    "[蜡烛]",    "蜡烛"},
    {"yfy58_",    "[钟]",      "钟"},
    {"yfy59_",    "[蛋糕]",    "蛋糕"},
    {"yfy60_",    "[话筒]",    "话筒"},

};



@implementation NSString (NSStringUtils)
- (NSString*)encodeAsURIComponent
{
	const char* p = [self UTF8String];
	NSMutableString* result = [NSMutableString string];
	
	for (;*p ;p++) {
		unsigned char c = *p;
		if ((c >= '0' && c <= '9') || (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c == '-' || c == '_') {
			[result appendFormat:@"%c", c];
		} else {
			[result appendFormat:@"%%%02X", c];
		}
	}
	return result;
}

+ (NSString*)base64encode:(NSString*)str 
{
    if ([str length] == 0)
        return @"";

    const char *source = [str UTF8String];
    int strlength  = strlen(source);
    
    char *characters = malloc(((strlength + 2) / 3) * 4);
    if (characters == NULL)
        return nil;

    NSUInteger length = 0;
    NSUInteger i = 0;

    while (i < strlength) {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < strlength)
            buffer[bufferLength++] = source[i++];
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES] autorelease];
}

- (NSString*)escapeHTML
{
	NSMutableString* s = [NSMutableString string];
	
	int start = 0;
	int len = [self length];
	NSCharacterSet* chs = [NSCharacterSet characterSetWithCharactersInString:@"<>&\""];
	
	while (start < len) {
		NSRange r = [self rangeOfCharacterFromSet:chs options:0 range:NSMakeRange(start, len-start)];
		if (r.location == NSNotFound) {
			[s appendString:[self substringFromIndex:start]];
			break;
		}
		
		if (start < r.location) {
			[s appendString:[self substringWithRange:NSMakeRange(start, r.location-start)]];
		}
		
		switch ([self characterAtIndex:r.location]) {
			case '<':
				[s appendString:@"&lt;"];
				break;
			case '>':
				[s appendString:@"&gt;"];
				break;
			case '"':
				[s appendString:@"&quot;"];
				break;
			case '&':
				[s appendString:@"&amp;"];
				break;
		}
		
		start = r.location + 1;
	}
	
	return s;
}

- (NSString*)unescapeHTML
{
	NSMutableString* s = [NSMutableString string];
	NSMutableString* target = [[self mutableCopy] autorelease];
	NSCharacterSet* chs = [NSCharacterSet characterSetWithCharactersInString:@"&"];
	
	while ([target length] > 0) {
		NSRange r = [target rangeOfCharacterFromSet:chs];
		if (r.location == NSNotFound) {
			[s appendString:target];
			break;
		}
		
		if (r.location > 0) {
			[s appendString:[target substringToIndex:r.location]];
			[target deleteCharactersInRange:NSMakeRange(0, r.location)];
		}
		
		if ([target hasPrefix:@"&lt;"]) {
			[s appendString:@"<"];
			[target deleteCharactersInRange:NSMakeRange(0, 4)];
		} else if ([target hasPrefix:@"&gt;"]) {
			[s appendString:@">"];
			[target deleteCharactersInRange:NSMakeRange(0, 4)];
		} else if ([target hasPrefix:@"&quot;"]) {
			[s appendString:@"\""];
			[target deleteCharactersInRange:NSMakeRange(0, 6)];
		} else if ([target hasPrefix:@"&amp;"]) {
			[s appendString:@"&"];
			[target deleteCharactersInRange:NSMakeRange(0, 5)];
		} else {
			[s appendString:@"&"];
			[target deleteCharactersInRange:NSMakeRange(0, 1)];
		}
	}
	
	return s;
}

+ (NSString*)localizedString:(NSString*)key
{
	return [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:key];
}

//// 发送之前将表情转化为字符串
//+ (void) FilterFaceCodeSend:(NSMutableString*)strMsgContent
//{
//    // 表情3.0版本(主要是iphone4升级到ios5.1导致，需要做转码 2012-3-12,转完之后走原来流程)
//    // 
//    for (int i=0; i<FACE_NUM; i++)
//    {
//        NSString* strNewFace = nil;
//        NSString* strOldFace = nil;
//        int iOld = g_faceTable[i].orgface;
//        int iFirst = g_faceTable[i].newfacepre;
//        int iSecond = g_faceTable[i].newfacesuf;
//        NSString *sThree = [NSString stringWithCString:g_faceTable[i].newfaceCode encoding:NSUTF8StringEncoding];  // 3.8.2 新加表情编码 (其中包含了表情2。0 的转码)
//        //对最早的表情1.0 进行解码
//        NSString *s_old_face_code = [NSString stringWithCString:g_faceTable[i].oldfaceCode encoding:NSUTF8StringEncoding];
//        
//        if (iSecond>0)
//        {
//            strNewFace = [NSString stringWithFormat:@"%C%C",(ushort)iFirst,(ushort)iSecond];
//        }
//        else
//        {
//            strNewFace = [NSString stringWithFormat:@"%C",(ushort)iFirst];
//        }
//        strOldFace = [NSString stringWithFormat:@"%C",(ushort)iOld];
//
//        [strMsgContent replaceOccurrencesOfString:strNewFace withString:strOldFace options:NSCaseInsensitiveSearch range:NSMakeRange(0, strMsgContent.length)];
//        
//        //如果sThree 长度大于0 为表情4.0 新的编码 (zjx - 修改与2013-6-17)
//        if (sThree.length>0)
//        {
//            NSString *newFace = [NSString stringWithString:sThree];
//            [strMsgContent replaceOccurrencesOfString:strOldFace withString:newFace options:NSCaseInsensitiveSearch range:NSMakeRange(0, strMsgContent.length)];
//        }
//        //兼容老版本  老的表情依然要走老的编码
//        if (s_old_face_code.length)
//        {
//            [strMsgContent replaceOccurrencesOfString:strOldFace withString:s_old_face_code options:NSCaseInsensitiveSearch range:NSMakeRange(0, strMsgContent.length)];
//        }
//    }
//}

static NSMutableDictionary *emotDicts =nil;
// 通过表情编码找到表情文件名(只支持自定义表情)
+ (NSString *)fileNameWithFaceCode:(NSString *)strCode
{
    if (emotDicts!=nil) {
        return [emotDicts objectForKey:strCode]?[emotDicts objectForKey:strCode]:nil;
    }
    emotDicts = [[NSMutableDictionary alloc] init];
    for (int i=0; i<FACE_NUM; i++)
    {
        NSString *faceFileName = [[NSString alloc] initWithCString:g_faceTable[i].facename encoding:NSUTF8StringEncoding];
        NSString *faceCode = [[NSString alloc] initWithCString:g_faceTable[i].readyfaceCode encoding:NSUTF8StringEncoding];
        if (faceCode.length>0)
        {
            [emotDicts setValue:faceFileName forKey:faceCode];
        }
        [faceFileName release];
        [faceCode release];
    }
    return [emotDicts objectForKey:strCode]?[emotDicts objectForKey:strCode]:nil;
}

@end



