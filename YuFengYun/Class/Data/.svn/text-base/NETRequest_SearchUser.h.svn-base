//
//  NETRequest_SearchUser.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-9-6.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETRequest.h"

@interface NETRequest_SearchUser : NETRequest

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, copy) NSString *keyword;

@property (nonatomic, strong) NSNumber *pageIndex;
@property (nonatomic, strong) NSNumber *pageSize;

- (NSDictionary *)loadUserId:(NSNumber *)userId
                     keyword:(NSString *)keyword
                   pageIndex:(NSNumber *)pageIndex
                    pageSize:(NSNumber *)pageSize;


@end
