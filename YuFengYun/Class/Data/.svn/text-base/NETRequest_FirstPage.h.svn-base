//
//  NETRequest_FirstPage.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-7.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETRequest.h"

@interface PageInfo : NETRequest
@property (nonatomic, strong) NSNumber *pageIndex;
@property (nonatomic, strong) NSNumber *pageSize;
@end

@interface NETRequest_FirstPage : NETRequest

@property (nonatomic, strong) NSNumber *userId;

@property (nonatomic, strong) NSNumber *pageIndex;
@property (nonatomic, strong) NSNumber *pageSize;
//@property (nonatomic, strong) PageInfo *pageInfo;

- (NSDictionary *)loadUserId:(NSNumber *)userId
                   pageIndex:(NSNumber *)pageIndex
                    pageSize:(NSNumber *)pageSize;

@end
