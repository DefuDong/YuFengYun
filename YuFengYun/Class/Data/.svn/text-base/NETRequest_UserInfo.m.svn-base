//
//  NETRequest_UserInfo.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-7.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETRequest_UserInfo.h"

@implementation NETRequest_UserInfo

- (NSDictionary *)build {
    if (self.userId) {
        [self.requestDic setObject:self.userId forKey:@"userId"];
    }
    return self.requestDic;
}

- (NSDictionary *)loadUserId:(NSNumber *)userId {
    self.userId = userId;
    return [self build];
}

@end
