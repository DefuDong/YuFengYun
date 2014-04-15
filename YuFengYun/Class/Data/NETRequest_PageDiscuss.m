//
//  NETRequest_PageDiscuss.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-20.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETRequest_PageDiscuss.h"

@implementation NETRequest_PageDiscuss

- (NSDictionary *)build {
    if (self.userId) {
        [self.requestDic setObject:self.userId forKey:@"userId"];
    }
    if (self.articleId) {
        [self.requestDic setObject:self.articleId forKey:@"articleId"];
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

- (NSDictionary *)loadUserId:(NSNumber *)userId
                   articleId:(NSNumber *)articleId
                 commentType:(NSString *)commentType
                   pageIndex:(NSNumber *)pageIndex
                    pageSize:(NSNumber *)pageSize {
    self.userId = userId;
    self.articleId = articleId;
    self.commentType = commentType;
    self.pageIndex = pageIndex;
    self.pageSize = pageSize;
    return [self build];
}

@end
