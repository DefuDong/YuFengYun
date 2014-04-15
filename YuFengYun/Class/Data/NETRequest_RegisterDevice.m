//
//  NETRequest_RegisterDevice.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-9-13.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETRequest_RegisterDevice.h"

@implementation NETRequest_RegisterDevice


- (NSDictionary *)build {
    if (self.deviceToken.length) {
        [self.requestDic setObject:self.deviceToken forKey:@"deviceToken"];
    }
    
    self.osVersion = [[UIDevice currentDevice] model];
    self.terminalType = @"i";
    self.terminalVersion = [[UIDevice currentDevice] systemVersion];

    [self.requestDic setObject:self.osVersion forKey:@"osVersion"];
    [self.requestDic setObject:self.terminalType forKey:@"terminalType"];
    [self.requestDic setObject:self.terminalVersion forKey:@"terminalVersion"];
    
    return self.requestDic;
}

- (NSDictionary *)loadDeviceToken:(NSString *)deviceToken {
    self.deviceToken = deviceToken;    
    return [self build];
}


@end
