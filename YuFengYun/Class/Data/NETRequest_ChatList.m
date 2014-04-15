//
//  NETRequest_ChatList.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-9-12.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETRequest_ChatList.h"

@implementation NETRequest_ChatList

- (NSDictionary *)build {
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

- (NSDictionary *)loadPageIndex:(NSNumber *)pageIndex
                    pageSize:(NSNumber *)pageSize {
    self.pageIndex = pageIndex;
    self.pageSize = pageSize;
    return [self build];
}

@end
