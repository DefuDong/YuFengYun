//
//  NETRequest_SinaLogin.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-28.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETRequest_SinaLogin.h"

@implementation NETRequest_SinaLogin


- (NSDictionary *)build {
    if (self.uId) {
        [self.requestDic setObject:self.uId forKey:@"uId"];
    }
    if (self.tokenId) {
        [self.requestDic setObject:self.tokenId forKey:@"tokenId"];
    }
    
    return self.requestDic;
}


- (NSDictionary *)loadUId:(NSString *)uId tokenId:(NSString *)tokenId {
    self.uId = uId;
    self.tokenId = tokenId;
    return [self build];
}

@end
