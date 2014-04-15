//
//  NETRequest_Register.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-7.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETRequest_Register.h"

@implementation NETRequest_Register

- (NSDictionary *)build {
    if (self.userEmail) {
        [self.requestDic setObject:self.userEmail forKey:@"userEmail"];
    }
    if (self.userNickname) {
        [self.requestDic setObject:self.userNickname forKey:@"userNickname"];
    }
    if (self.userPwd) {
        [self.requestDic setObject:self.userPwd forKey:@"userPwd"];
    }
    if (self.userRegisteredWay) {
        [self.requestDic setObject:self.userRegisteredWay forKey:@"userRegisteredWay"];
    }
    if (self.platformId) {
        [self.requestDic setObject:self.platformId forKey:@"platformId"];
    }
    return self.requestDic;
}

- (NSDictionary *)loadEmail:(NSString *)email nickName:(NSString *)nickName pwd:(NSString *)pwd {
    self.userEmail = email;
    self.userNickname = nickName;
    self.userPwd = pwd;
    self.userRegisteredWay = @"4";
    self.platformId = @1;
    return [self build];
}

@end
