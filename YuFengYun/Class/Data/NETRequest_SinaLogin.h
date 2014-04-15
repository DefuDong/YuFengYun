//
//  NETRequest_SinaLogin.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-28.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETRequest.h"

@interface NETRequest_SinaLogin : NETRequest

@property (nonatomic, copy) NSString *uId;
@property (nonatomic, copy) NSString *tokenId;

- (NSDictionary *)loadUId:(NSString *)uId tokenId:(NSString *)tokenId;

@end
