//
//  NETRequest_FirstPage.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-7.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETRequest_FirstPage.h"

@implementation NETRequest_FirstPage

- (NSDictionary *)build {
    if (self.userId) {
        [self.requestDic setObject:self.userId forKey:@"userId"];
    }
    NSMutableDictionary *pageInfo = [NSMutableDictionary dictionaryWithCapacity:2];
    if (self.pageIndex) {
        [pageInfo setObject:self.pageIndex forKey:@"pageIndex"];
    }
    if (self.pageSize) {
        [pageInfo setObject:self.pageSize forKey:@"pageSize"];
    }else {
        [pageInfo setObject:@20 forKey:@"pageSize"];
    }
    [self.requestDic setObject:pageInfo forKey:@"pageInfo"];
    
    return self.requestDic;
}

- (NSDictionary *)loadUserId:(NSNumber *)userId
                   pageIndex:(NSNumber *)pageIndex
                    pageSize:(NSNumber *)pageSize {
    self.userId = userId;
    self.pageIndex = pageIndex;
    self.pageSize = pageSize;
    return [self build];
}

@end


@implementation PageInfo

- (NSDictionary *)build {
    if (self.pageIndex) {
        [self.requestDic setObject:self.pageIndex forKey:@"pageIndex"];
    }
    if (self.pageSize) {
        [self.requestDic setObject:self.pageSize forKey:@"pageSize"];
    }
    return self.requestDic;
}

@end