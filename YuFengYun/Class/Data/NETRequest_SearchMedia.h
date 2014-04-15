//
//  NETRequest_SearchUser.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-9-6.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETRequest.h"

@interface NETRequest_SearchMedia : NETRequest

@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) NSNumber *pageIndex;
@property (nonatomic, strong) NSNumber *pageSize;

- (NSDictionary *)loadKeyword:(NSString *)keyword
                         type:(NSString *)type
                    pageIndex:(NSNumber *)pageIndex
                     pageSize:(NSNumber *)pageSize;


@end
