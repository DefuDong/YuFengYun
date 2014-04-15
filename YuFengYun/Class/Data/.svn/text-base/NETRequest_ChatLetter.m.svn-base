//
//  NETRequest_ChatLetter.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-9-13.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETRequest_ChatLetter.h"

@implementation NETRequest_ChatLetter

- (NSDictionary *)build {
    if (self.letterReceiveUserId) {
        [self.requestDic setObject:self.letterReceiveUserId forKey:@"letterReceiveUserId"];
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

- (NSDictionary *)loadReceiveUserId:(NSNumber *)receiveUserId
                       pageIndex:(NSNumber *)pageIndex
                        pageSize:(NSNumber *)pageSize {
    self.letterReceiveUserId = receiveUserId;
    self.pageIndex = pageIndex;
    self.pageSize = pageSize;
    return [self build];
}

@end
