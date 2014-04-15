//
//  Utility.m
//  JingXiang
//
//  Created by xiaohuzhu on 13-1-24.
//
//

#import "Utility.h"
#include <stdio.h>
#include <arpa/inet.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <arpa/inet.h>
#include <ifaddrs.h>
#import "zlib.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"


#define kDevKey @"yufengyun"

@implementation Utility

+ (NSString *)uniqueID {
    
    NSString *devKey = kDevKey;
    NSString *MACAddr = [Utility MACAddr];
    
    const char  *cstart = [[NSString stringWithFormat:@"%C%C%@%@%C%C",
                            [MACAddr characterAtIndex:6],
                            [MACAddr characterAtIndex:7],
                            devKey,
                            MACAddr,
                            [MACAddr characterAtIndex:3],
                            [MACAddr characterAtIndex:4]] UTF8String];
    
    
    
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(cstart,strlen(cstart),result);
    
    NSMutableString *hash = [NSMutableString string];
    
    int i;
    for (i=0; i < 20; i++) {
        [hash appendFormat:@"%02x",result[i]];
    }
    
    return [hash lowercaseString];
}
+ (NSString *)MACAddr {
    struct ifaddrs *interfaces;
    const struct ifaddrs *tmpaddr;
    
    if (getifaddrs(&interfaces)==0)
    {
        tmpaddr = interfaces;
        
        while (tmpaddr != NULL)
        {
            if (strcmp(tmpaddr->ifa_name,"en0")==0)
            {
                struct sockaddr_dl *dl_addr = ((struct sockaddr_dl *)tmpaddr->ifa_addr);
                uint8_t *base = (uint8_t *)&dl_addr->sdl_data[dl_addr->sdl_nlen];
                
                NSMutableString *s = [NSMutableString string];
                int l = dl_addr->sdl_alen;
                int i;
                
                for (i=0; i < l; i++)
                {
                    [s appendFormat:(i!=0)?@":%02x":@"%02x",base[i]];
                }
                
                return s;
            }
            
            tmpaddr = tmpaddr->ifa_next;
        }
        
        freeifaddrs(interfaces);
    }
    return @"00:00:00:00:00:00";
}


+ (NSString *)documentPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}
+ (NSString *)libraryPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}
+ (NSString *)cachesPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}


+ (NSData *)simpleEncryption__Indexed_And_XOR__From:(NSData *)sourceData {
    const uint8_t *     dataBuffer;
	NSUInteger          dataLength;
	NSMutableData *     result = nil;
	
	//expand all bytes
	dataLength = [sourceData length];
	
	if (dataLength) {
		
		dataBuffer = (const uint8_t *)[sourceData bytes];
        result = [NSMutableData dataWithCapacity:dataLength];
        //		uint8_t *resultBuffer = new uint8_t[dataLength];
#if DEBUG_ENCRYPT
		NSLog(@"+++++ encoding source data %@", [sourceData description]);
#endif
		//across all bytes, excute add and xor
		uint8_t lastByte = *dataBuffer; //beginning one
                                        //		resultBuffer[0] = lastByte;
        [result appendBytes:&lastByte length:1];
		for (int i = 1; i < dataLength; i ++) {
			
			uint8_t byte = *(dataBuffer+i);
			uint8_t a_byte = byte + i;
			uint8_t b_byte = a_byte ^ lastByte;
            //			resultBuffer[i] = b_byte;
            [result appendBytes:&b_byte length:1];
			lastByte = byte;
		}
        //		result = [NSData dataWithBytes:resultBuffer length:dataLength];
        //		delete resultBuffer;
	}
	
	//return copy of autorelease
#if DEBUG_ENCRYPT
	NSLog(@"+++++ target data %@", [result description]);
#endif
    
	return result;
}
+ (NSData *)simpleDecryption__XOR_And_Indexed__From:(NSData *)sourceData {
    const uint8_t *     dataBuffer;
	NSUInteger          dataLength;
	NSMutableData *     result = nil;
	
	//expand all bytes
	dataLength = [sourceData length];
	
	if (dataLength) {
		
		dataBuffer = (const uint8_t *)[sourceData bytes];
        //		uint8_t *resultBuffer = new uint8_t[dataLength];
		result = [NSMutableData dataWithCapacity:dataLength];
#if DEBUG_ENCRYPT
		NSLog(@"+++++ decoding source data %@", [sourceData description]);
#endif
		//across all bytes, excute add and xor
		uint8_t lastByte = *dataBuffer; //beginning one
                                        //		resultBuffer[0] = lastByte;
        [result appendBytes:&lastByte length:1];
		for (int i = 1; i < dataLength; i ++) {
            
			uint8_t byte = *(dataBuffer+i);
			uint8_t b_byte = byte ^ lastByte;
			uint8_t a_byte = b_byte - i;
            
            //			resultBuffer[i] = a_byte;
            [result appendBytes:&a_byte length:1];
			lastByte = a_byte;
		}
        //		result = [NSData dataWithBytes:resultBuffer length:dataLength];
        //		delete resultBuffer;
	}
	
	//return copy of autorelease
#if DEBUG_ENCRYPT
	NSLog(@"+++++ target data %@", [result description]);
#endif
    
	return result;
    
}


static char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
+ (NSString *)encodeBase64forData:(NSData*)theData {
	
	const uint8_t* input = (const uint8_t*)[theData bytes];
	NSInteger length = [theData length];
	
    
	
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
	
	NSInteger i,i2;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
		for (i2=0; i2<3; i2++) {
            value <<= 8;
            if (i+i2 < length) {
                value |= (0xFF & input[i+i2]);
            }
        }
		
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    encodingTable[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    encodingTable[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? encodingTable[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? encodingTable[(value >> 0)  & 0x3F] : '=';
    }
	
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}
+ (NSData *)decodeBase64forString:(NSString*)theStr{
    if (theStr == nil)
		[NSException raise:NSInvalidArgumentException format:nil];
	if ([theStr length] == 0)
		return [NSData data];
	
	static char *decodingTable = NULL;
	if (decodingTable == NULL)
        {
		decodingTable = malloc(256);
		if (decodingTable == NULL)
			return nil;
		memset(decodingTable, CHAR_MAX, 256);
		NSUInteger i;
		for (i = 0; i < 64; i++)
			decodingTable[(short)encodingTable[i]] = i;
        }
	
	const char *characters = [theStr cStringUsingEncoding:NSASCIIStringEncoding];
	if (characters == NULL)     //  Not an ASCII string!
		return nil;
	char *bytes = malloc((([theStr length] + 3) / 4) * 3);
	if (bytes == NULL)
		return nil;
	NSUInteger length = 0;
    
	NSUInteger i = 0;
	while (YES)
        {
		char buffer[4];
		short bufferLength;
		for (bufferLength = 0; bufferLength < 4; i++)
            {
			if (characters[i] == '\0')
				break;
			if (isspace(characters[i]) || characters[i] == '=')
				continue;
			buffer[bufferLength] = decodingTable[(short)characters[i]];
			if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
                {
				free(bytes);
				return nil;
                }
            }
		
		if (bufferLength == 0)
			break;
		if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
            {
			free(bytes);
			return nil;
            }
		
		//  Decode the characters in the buffer to bytes.
		bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
		if (bufferLength > 2)
			bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
		if (bufferLength > 3)
			bytes[length++] = (buffer[2] << 6) | buffer[3];
        }
	
	realloc(bytes, length);
	return [NSData dataWithBytesNoCopy:bytes length:length];
}


+ (NSString*)encodeURL:(NSString *)string {
	return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                            kCFAllocatorDefault,
                                            (__bridge CFStringRef)string,
                                            NULL,
                                            CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"),
                                            CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
}

+ (BOOL)isValueNumber:(NSString *)str {
    if (str.length > 13)
        return NO;
    
    NSScanner *scanner = [NSScanner scannerWithString:str];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789- "];
    
    while ([scanner isAtEnd] == NO) {
        NSString *buffer;
        if (![scanner scanCharactersFromSet:numbers intoString:&buffer])
            return NO;
    }
    return YES;
}
+ (BOOL)isValidEmail:(NSString *)checkString {
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = YES ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


+ (NSString *)saveImage:(UIImage *)image {
    
    CGSize size = CGSizeMake(130, 130);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImageJPEGRepresentation(scaledImage, 1);
    
    NSString *fullPathToFile = [[Utility cachesPath] stringByAppendingPathComponent:@"uploadImage.jpg"];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:YES];
    return fullPathToFile;
}


////////////////////////////////////////////////////////////////////////////
#pragma mark -
NSUInteger DeviceSystemMajorVersion() {
    
    static NSUInteger _deviceSystemMajorVersion = -1;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
        
    });
    
    return _deviceSystemMajorVersion;
}


////////////////////////////////////////////////////////////////////////////
//gzip
+ (NSData *)compressData: (NSData*)uncompressedData  {
    
    
    if (!uncompressedData || [uncompressedData length] == 0)  {
        NSLog(@"%s: Error: Can't compress an empty or null NSData object.", __func__);
        return nil;
    }
    
    z_stream zlibStreamStruct;
    zlibStreamStruct.zalloc    = Z_NULL; // Set zalloc, zfree, and opaque to Z_NULL so
    zlibStreamStruct.zfree     = Z_NULL; // that when we call deflateInit2 they will be
    zlibStreamStruct.opaque    = Z_NULL; // updated to use default allocation functions.
    zlibStreamStruct.total_out = 0; // Total number of output bytes produced so far
    zlibStreamStruct.next_in   = (Bytef*)[uncompressedData bytes]; // Pointer to input byt
    zlibStreamStruct.avail_in  = [uncompressedData length]; // Number of input bytes left to process
    
    int initError = deflateInit2(&zlibStreamStruct, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY);
    if (initError != Z_OK)
    {
        NSString *errorMsg = nil;
        switch (initError)
        {
            case Z_STREAM_ERROR:
                errorMsg = @"Invalid parameter passed in to function.";
                break;
            case Z_MEM_ERROR:
                errorMsg = @"Insufficient memory.";
                break;
            case Z_VERSION_ERROR:
                errorMsg = @"The version of zlib.h and the version of the library linked do not match.";
                break;
            default:
                errorMsg = @"Unknown error code.";
                break;
        }
        NSLog(@"%s: deflateInit2() Error: \"%@\" Message: \"%s\"", __func__, errorMsg, zlibStreamStruct.msg);
        return nil;
    }
    
    
    NSMutableData *compressedData = [NSMutableData dataWithLength:[uncompressedData length] * 1.01 + 12];
    
    int deflateStatus;
    do
    {
        // Store location where next byte should be put in next_out
        zlibStreamStruct.next_out = [compressedData mutableBytes] + zlibStreamStruct.total_out;
        
        zlibStreamStruct.avail_out = [compressedData length] - zlibStreamStruct.total_out;
        
        deflateStatus = deflate(&zlibStreamStruct, Z_FINISH);
        
    } while ( deflateStatus == Z_OK );
    
    if (deflateStatus != Z_STREAM_END)
    {
        NSString *errorMsg = nil;
        switch (deflateStatus)
        {
            case Z_ERRNO:
                errorMsg = @"Error occured while reading file.";
                break;
            case Z_STREAM_ERROR:
                errorMsg = @"The stream state was inconsistent (e.g., next_in or next_out was NULL).";
                break;
            case Z_DATA_ERROR:
                errorMsg = @"The deflate data was invalid or incomplete.";
                break;
            case Z_MEM_ERROR:
                errorMsg = @"Memory could not be allocated for processing.";
                break;
            case Z_BUF_ERROR:
                errorMsg = @"Ran out of output buffer for writing compressed bytes.";
                break;
            case Z_VERSION_ERROR:
                errorMsg = @"The version of zlib.h and the version of the library linked do not match.";
                break;
            default:
                errorMsg = @"Unknown error code.";
                break;
        }
        
        NSLog(@"%s: zlib error while attempting compression: \"%@\" Message: \"%s\"", __func__, errorMsg, zlibStreamStruct.msg);
        
        deflateEnd(&zlibStreamStruct);
        
        return nil;
    }
        
    deflateEnd(&zlibStreamStruct);
    [compressedData setLength: zlibStreamStruct.total_out];
    return compressedData;
}
+ (NSData *)decompressData:(NSData *)compressedData {
    
    z_stream zStream;
    zStream.zalloc = Z_NULL;
    zStream.zfree = Z_NULL;
    zStream.opaque = Z_NULL;
    zStream.avail_in = 0;
    zStream.next_in = 0;
    
    int status = inflateInit2(&zStream, (15+32));
    if (status != Z_OK) {
        return nil;
    }
    
    Bytef *bytes = (Bytef *)[compressedData bytes];
    NSUInteger length = [compressedData length];
    
    NSUInteger halfLength = length/2;
    NSMutableData *uncompressedData = [NSMutableData dataWithLength:length+halfLength];
    
    zStream.next_in = bytes;
    zStream.avail_in = (unsigned int)length;
    zStream.avail_out = 0;
    
    NSInteger bytesProcessedAlready = zStream.total_out;
    while (zStream.avail_in != 0) {
        if (zStream.total_out - bytesProcessedAlready >= [uncompressedData length]) {
            [uncompressedData increaseLengthBy:halfLength];
        }
        
        zStream.next_out = (Bytef*)[uncompressedData mutableBytes] + zStream.total_out-bytesProcessedAlready;
        zStream.avail_out = (unsigned int)([uncompressedData length] - (zStream.total_out-bytesProcessedAlready));
        
        status = inflate(&zStream, Z_NO_FLUSH);
        if (status == Z_STREAM_END) {
            break;
        } else if (status != Z_OK) {
            return nil;
        }
    }
    
    status = inflateEnd(&zStream);
    if (status != Z_OK) {
        return nil;
    }
    
    [uncompressedData setLength: zStream.total_out-bytesProcessedAlready];  // Set real length    
    return uncompressedData;    
}


+ (NSString *)MD5:(NSString *)inPutText {
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
//    NSString *hash = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
//                      result[0], result[1], result[2], result[3],
//                      result[4], result[5], result[6], result[7],
//                      result[8], result[9], result[10], result[11],
//                      result[12], result[13], result[14], result[15]
//                      ];    
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    
    return [hash lowercaseString];
}


static Byte iv[] = {1,2,3,4,5,6,7,8};
static NSString *des3Key = @"bea79d8a3233e014d8166729ccc02d37";

//DES加密
+ (NSString *)encrypt3DES:(NSString *)clearText {
    NSString *ciphertext = nil;
    
    NSData *textData = [clearText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [clearText length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithm3DES,
                                          kCCOptionECBMode|kCCOptionPKCS7Padding,
                                          [des3Key UTF8String], kCCKeySize3DES,
                                          iv,
                                          [textData bytes]	, dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        Byte* bb = (Byte*)[data bytes];
        ciphertext = [Utility parseByteArray2HexString:bb];
        
    }else{
        NSLog(@"DES加密失败");
    }
    return [ciphertext lowercaseString];
}
// DES解密
+ (NSString *)decrypt3DES:(NSString *)plainText {
    
    NSString *cleartext = nil;
    
    NSData *textData = [Utility parseHexToByteArray:plainText];
    NSUInteger dataLength = [textData length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithm3DES,
                                          kCCOptionECBMode|kCCOptionPKCS7Padding,
                                          [des3Key UTF8String], kCCKeySize3DES,
                                          iv,
                                          [textData bytes]	, dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {        
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        cleartext = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }else{
        NSLog(@"DES解密失败");
    }
    return cleartext;
}

// 将NSData数组转化成16进制数据
+ (NSString *) parseByteArray2HexString:(Byte[]) bytes {
    NSMutableString *hexStr = [NSMutableString string];
    int i = 0;
    if(bytes) {
        while (bytes[i] != '\0') {
            NSString *hexByte = [NSString stringWithFormat:@"%x",bytes[i] & 0xff];///16进制数
            if([hexByte length]==1)
                [hexStr appendFormat:@"0%@", hexByte];
            else
                [hexStr appendFormat:@"%@", hexByte];
            
            i++;
        }
    }
    return [hexStr uppercaseString];
}
// 将16进制数据转化成NSData 数组
+ (NSData*) parseHexToByteArray:(NSString *)hexString {
    hexString = [hexString uppercaseString];
    int j=0;
    Byte bytes[hexString.length];
    for(int i=0;i<[hexString length];i++)
    {
        int int_ch;  /// 两位16进制数转化后的10进制数
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char1 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
        j++;
    }
    
    NSData *newData = [[NSData alloc] initWithBytes:bytes length:hexString.length/2];
    return newData;
}


static NSString *defKey = @"yhsd2013";
// DES加密
+ (NSString *)encryptUseDES:(NSString *)clearText {
    NSString *ciphertext = nil;
    
    NSData *textData = [clearText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [clearText length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionECBMode,
                                          [defKey UTF8String], kCCKeySizeDES,
                                          iv,
                                          [textData bytes]  , dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSLog(@"DES加密成功");
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        Byte* bb = (Byte*)[data bytes];
        ciphertext = [Utility parseByteArray2HexString:bb];
    }else{
        NSLog(@"DES加密失败");
    }
    return [ciphertext lowercaseString];
}
// DES解密
+ (NSString *)decryptUseDES:(NSString *)plainText {
    NSString *cleartext = nil;
//    NSData *textData = [Utility parseHexToByteArray:plainText];
    NSData *textData = [Utility decodeBase64forString:plainText];
    NSLog(@"%@", [[NSString alloc] initWithData:textData encoding:NSUTF8StringEncoding]);
    
    NSUInteger dataLength = [textData length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionECBMode,
                                          [defKey UTF8String], kCCKeySizeDES,
                                          iv,
                                          [textData bytes]  , dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSLog(@"DES解密成功");
        
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        cleartext = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }else{
        NSLog(@"DES解密失败");
    }
    return cleartext;
}


+ (NSString *)decryptUseDES:(NSString*)cipherText key:(NSString*)key {
    NSData* cipherData = [GTMBase64 decodeString:cipherText]; 
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [defKey UTF8String],
                                          kCCKeySizeDES,
                                          iv,
                                          [cipherData bytes],
                                          [cipherData length],
                                          buffer,
                                          1024,
                                          &numBytesDecrypted);
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData* data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return plainText;
}


+ (NSString *)errorDes:(NSString *)code {
    
    if ([code isEqualToString:@"00000000"]) return @"请求成功";
    if ([code isEqualToString:@"10100001"]) return @"请求报文参数缺失";
    if ([code isEqualToString:@"10100002"]) return @"请求报文参数格式错误";
    if ([code isEqualToString:@"10100003"]) return @"用户token不存在或已过期";
    if ([code isEqualToString:@"10100004"]) return @"authCode认证失败";
    if ([code isEqualToString:@"10100005"]) return @"用户没有登录";
    if ([code isEqualToString:@"10100006"]) return @"服务器业务接口调用异常";
    if ([code isEqualToString:@"10200001"]) return @"缺失证书号";
    if ([code isEqualToString:@"10200002"]) return @"缺失终端标识";
    if ([code isEqualToString:@"10200003"]) return @"缺失apkCode";
    if ([code isEqualToString:@"10200004"]) return @"缺失apkType";
    if ([code isEqualToString:@"10200005"]) return @"缺失apkVersion";
    if ([code isEqualToString:@"10200006"]) return @"终端组件规格不存在";
    if ([code isEqualToString:@"10200007"]) return @"缺失厂商";
    if ([code isEqualToString:@"10200008"]) return @"缺失终端版本ID";
    if ([code isEqualToString:@"10200009"]) return @"无效的APK CODE";
    if ([code isEqualToString:@"10200010"]) return @"缺失个人终端标识";
    if ([code isEqualToString:@"10200011"]) return @"缺失操作系统类型";
    if ([code isEqualToString:@"10200012"]) return @"缺失软件版本";
    if ([code isEqualToString:@"10200013"]) return @"缺失终端设备类型";
    if ([code isEqualToString:@"10200014"]) return @"操作系统格式错误";
    if ([code isEqualToString:@"10200015"]) return @"操作系统格式错误";
    if ([code isEqualToString:@"10200016"]) return @"终端设备类型格式错误";
    if ([code isEqualToString:@"10200017"]) return @"颜色格式不匹配";
    if ([code isEqualToString:@"10200018"]) return @"3G标准不匹配";
    if ([code isEqualToString:@"10200019"]) return @"出厂日期格式不匹配";
    if ([code isEqualToString:@"10200020"]) return @"尺寸单位格式不匹配";
    if ([code isEqualToString:@"10200021"]) return @"分辨率格式不匹配";
    if ([code isEqualToString:@"10200022"]) return @"重力感应格式不匹配";
    if ([code isEqualToString:@"10200023"]) return @"触摸感应格式不匹配";
    if ([code isEqualToString:@"10200024"]) return @"WIFI格式不匹配";
    if ([code isEqualToString:@"10200025"]) return @"ios访问扩展标识错误";
    if ([code isEqualToString:@"10300001"]) return @"商品ID缺失";
    if ([code isEqualToString:@"10300002"]) return @"是否赠送标识缺失";
    if ([code isEqualToString:@"10300003"]) return @"商品ID参数错误";
    if ([code isEqualToString:@"10300004"]) return @"是否赠送标识参数错误";
    if ([code isEqualToString:@"10300005"]) return @"当前用户ID错误";
    if ([code isEqualToString:@"10300006"]) return @"缺失设备证书号";
    if ([code isEqualToString:@"10300007"]) return @"缺失内容列表";
    if ([code isEqualToString:@"10300008"]) return @"缺失内容项";
    if ([code isEqualToString:@"10300009"]) return @"缺失内容的Guid";
    if ([code isEqualToString:@"10300010"]) return @"根据Guid没有找到内容数据";
    if ([code isEqualToString:@"10300101"]) return @"获取赠送列表分页验证失败";
    if ([code isEqualToString:@"10300102"]) return @"订阅编号缺失";
    if ([code isEqualToString:@"10300103"]) return @"商品类型错误";
    if ([code isEqualToString:@"10300104"]) return @"交付单编号缺失";
    if ([code isEqualToString:@"10300109"]) return @"该客户端无商品可赠";
    if ([code isEqualToString:@"10300110"]) return @"该商品已下架";
    if ([code isEqualToString:@"10400001"]) return @"用户账号为空";
    if ([code isEqualToString:@"10400002"]) return @"用户密码为空";
    if ([code isEqualToString:@"10400003"]) return @"用户密码或密码错误";
    if ([code isEqualToString:@"10400004"]) return @"用户已被拉黑";
    if ([code isEqualToString:@"10400005"]) return @"用户账号为空";
    if ([code isEqualToString:@"10400006"]) return @"用户昵称为空";
    if ([code isEqualToString:@"10400007"]) return @"用户密码为空";
    if ([code isEqualToString:@"10400008"]) return @"用户邮箱已存在";
    if ([code isEqualToString:@"10400009"]) return @"用户昵称已存在";
    if ([code isEqualToString:@"10400010"]) return @"用户注册方式丢失";
    if ([code isEqualToString:@"10400011"]) return @"用户ID丢失";
    return nil;
}









@end
