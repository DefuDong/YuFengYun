//
//  NETRequest_DeleLike.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-20.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETRequest_DeleLike.h"

@implementation NETRequest_DeleLike


- (NSDictionary *)build {
    if (self.userId) {
        [self.requestDic setObject:self.userId forKey:@"userId"];
    }
    if (self.articleId) {
        [self.requestDic setObject:self.articleId forKey:@"articleId"];
    }
    
    return self.requestDic;
}

- (NSDictionary *)loadUserId:(NSNumber *)userId articleId:(NSNumber *)articleId {
    self.userId = userId;
    self.articleId = articleId;
    return [self build];
}

@end
