//
//  NETRequest_SearchUser.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-9-6.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETRequest_SearchMedia.h"

@implementation NETRequest_SearchMedia

- (NSDictionary *)build {
    if (self.keyword) {
        [self.requestDic setObject:self.keyword forKey:@"keyword"];
    }
    if (self.type) {
        [self.requestDic setObject:self.type forKey:@"type"];
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

- (NSDictionary *)loadKeyword:(NSString *)keyword
                         type:(NSString *)type
                    pageIndex:(NSNumber *)pageIndex
                     pageSize:(NSNumber *)pageSize {
    self.keyword = keyword;
    self.type = type;
    self.pageIndex = pageIndex;
    self.pageSize = pageSize;
    return [self build];
}

@end
