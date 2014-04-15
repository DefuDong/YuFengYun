//
//  NETRequest_ReplayMe.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-7.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETRequest_ReplayMe.h"

@implementation NETRequest_ReplayMe

- (NSDictionary *)build {
    if (self.commentUserId) {
        [self.requestDic setObject:self.commentUserId forKey:@"commentUserId"];
    }
    if (self.commentType) {
        [self.requestDic setObject:self.commentType forKey:@"commentType"];
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

- (NSDictionary *)loadUserId:(NSNumber *)commentUserId
                 commentType:(NSString *)commentType
                   pageIndex:(NSNumber *)pageIndex
                    pageSize:(NSNumber *)pageSize {
    self.commentUserId = commentUserId;
    self.commentType = commentType;
    self.pageIndex = pageIndex;
    self.pageSize = pageSize;
    return [self build];
}

@end
