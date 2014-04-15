//
//  NETRequest_Login.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-7.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETRequest_Login.h"

@implementation NETRequest_Login

- (NSDictionary *)build {
    if (self.userEmail) {
        [self.requestDic setObject:self.userEmail forKey:@"userEmail"];
    }
    if (self.userPwd) {
        [self.requestDic setObject:self.userPwd forKey:@"userPwd"];
    }
    if (self.loginType) {
        [self.requestDic setObject:self.loginType forKey:@"loginType"];
    }
    if (self.deviceToken.length) {
        [self.requestDic setObject:self.deviceToken forKey:@"deviceToken"];
    }
    self.terminalType = @"i";
    [self.requestDic setObject:self.terminalType forKey:@"terminalType"];
    
    return self.requestDic;
}

- (NSDictionary *)loadEmail:(NSString *)email
                        pwd:(NSString *)pwd
                       type:(NSString *)type
                deviceToken:(NSString *)deviceToken {
    self.userEmail = email;
    self.userPwd = pwd;
    self.loginType = type;
    self.deviceToken = deviceToken;
    return [self build];
}

@end
