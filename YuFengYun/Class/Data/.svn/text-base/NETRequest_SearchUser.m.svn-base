//
//  NETRequest_SearchUser.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-9-6.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETRequest_SearchUser.h"

@implementation NETRequest_SearchUser

- (NSDictionary *)build {
    if (self.userId) {
        [self.requestDic setObject:self.userId forKey:@"userId"];
    }
    if (self.keyword) {
        [self.requestDic setObject:self.keyword forKey:@"keyword"];
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
                     keyword:(NSString *)keyword
                   pageIndex:(NSNumber *)pageIndex
                    pageSize:(NSNumber *)pageSize {
    self.userId = userId;
    self.keyword = keyword;
    self.pageIndex = pageIndex;
    self.pageSize = pageSize;
    return [self build];
}

@end
