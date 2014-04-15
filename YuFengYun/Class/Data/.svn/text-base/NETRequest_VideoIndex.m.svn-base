//
//  NETRequest_UserArticle.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-9-9.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETRequest_VideoIndex.h"

@implementation NETRequest_VideoIndex

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
