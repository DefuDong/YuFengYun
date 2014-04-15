//
//  Utility.h
//  JingXiang
//
//  Created by xiaohuzhu on 13-1-24.
//
//

#import <Foundation/Foundation.h>
#import "DebugMacros.h"

#define MY_MACRO_NAME (DeviceSystemMajorVersion() < 7)

@interface Utility : NSObject

+ (NSString *)uniqueID;
+ (NSString *)MACAddr;

+ (NSString *)documentPath;
+ (NSString *)libraryPath;
+ (NSString *)cachesPath;

//按位与
+ (NSData *)simpleEncryption__Indexed_And_XOR__From:(NSData *)sourceData;//加密
+ (NSData *)simpleDecryption__XOR_And_Indexed__From:(NSData *)sourceData;//解密

//base 64
+ (NSString *)encodeBase64forData:(NSData*)theData; //编码
+ (NSData *)decodeBase64forString:(NSString*)theStr;//解码

//gzip
+ (NSData *)compressData:(NSData*)uncompressedData; //压缩
+ (NSData *)decompressData:(NSData *)compressedData;//解压缩

//md5
+ (NSString *)MD5:(NSString *)inPutText;

+ (NSString*)encodeURL:(NSString *)string;

+ (BOOL)isValidEmail:(NSString *)checkString;
+ (BOOL)isValueNumber:(NSString *)str;


+ (NSString *)saveImage:(UIImage *)image;

//system version
NSUInteger DeviceSystemMajorVersion();








//3DES
+ (NSString *)encrypt3DES:(NSString *)clearText;//3DES加密
+ (NSString *)decrypt3DES:(NSString *)plainText;//3DES解密

/**
 DES加密
 */
+ (NSString *)encryptUseDES:(NSString *)plainText;

/**
 DES解密
 */
+ (NSString *)decryptUseDES:(NSString *)plainText;

+ (NSString*)decryptUseDES:(NSString*)cipherText key:(NSString*)key;


+ (NSString *)errorDes:(NSString *)code;




@end
