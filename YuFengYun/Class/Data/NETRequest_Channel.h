//
//  NETRequest_Channel.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-7.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETRequest.h"

@interface NETRequest_Channel : NETRequest

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, copy) NSString *channleCode;

@property (nonatomic, strong) NSNumber *pageIndex;
@property (nonatomic, strong) NSNumber *pageSize;

- (NSDictionary *)loadUserId:(NSNumber *)userId
                 channleCode:(NSString *)channleCode
                   pageIndex:(NSNumber *)pageIndex
                    pageSize:(NSNumber *)pageSize;
@end
