//
//  NETRequest_DeleNotification.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-22.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETRequest_DeleNotification.h"

@implementation NETRequest_DeleNotification

- (NSDictionary *)build {
    if (self.userId) {
        [self.requestDic setObject:self.userId forKey:@"userId"];
    }
    if (self.noticeId) {
        [self.requestDic setObject:self.noticeId forKey:@"noticeId"];
    }
    
    return self.requestDic;
}

- (NSDictionary *)loadUserId:(NSNumber *)userId noticeId:(NSNumber *)noticeId {
    self.userId = userId;
    self.noticeId = noticeId;
    return [self build];
}

@end
