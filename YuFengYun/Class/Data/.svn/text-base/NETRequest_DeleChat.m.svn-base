//
//  NETRequest_DeleChat.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-9-12.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETRequest_DeleChat.h"

@implementation NETRequest_DeleChat

- (NSDictionary *)build {
    if (self.letterReceiveUserId) {
        [self.requestDic setObject:self.letterReceiveUserId forKey:@"letterReceiveUserId"];
    }
    if (self.letterId) {
        [self.requestDic setObject:self.letterId forKey:@"letterId"];
    }
    
    return self.requestDic;
}

- (NSDictionary *)loadUserId:(NSNumber *)userId
                    letterId:(NSNumber *)letterId {
    self.letterReceiveUserId = userId;
    self.letterId = letterId;
    return [self build];
}

@end
