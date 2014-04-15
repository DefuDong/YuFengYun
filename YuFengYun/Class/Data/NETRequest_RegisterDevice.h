//
//  NETRequest_RegisterDevice.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-9-13.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETRequest.h"

@interface NETRequest_RegisterDevice : NETRequest

@property (nonatomic, copy) NSString *deviceToken;
@property (nonatomic, copy) NSString *osVersion;
@property (nonatomic, copy) NSString *terminalType;
@property (nonatomic, copy) NSString *terminalVersion;

- (NSDictionary *)loadDeviceToken:(NSString *)deviceToken;

@end
