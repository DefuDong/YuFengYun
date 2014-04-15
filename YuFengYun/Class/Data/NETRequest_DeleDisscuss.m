//
//  NETRequest_DeleDisscuss.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-7.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETRequest_DeleDisscuss.h"

@implementation NETRequest_DeleDisscuss

- (NSDictionary *)build {
    if (self.commentId) {
        [self.requestDic setObject:self.commentId forKey:@"commentId"];
    }
    if (self.commentUserId) {
        [self.requestDic setObject:self.commentUserId forKey:@"commentUserId"];
    }
    
    return self.requestDic;
}


- (NSDictionary *)loadUserId:(NSNumber *)commentUserId
                   commentId:(NSNumber *)commentId {
    self.commentId = commentId;
    self.commentUserId = commentUserId;
    return [self build];
}


@end
