//
//  NETRequest_Register.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-7.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETRequest.h"

@interface NETRequest_Register : NETRequest

@property (nonatomic, copy) NSString *userEmail;
@property (nonatomic, copy) NSString *userNickname;
@property (nonatomic, copy) NSString *userPwd;
@property (nonatomic, copy) NSString *userRegisteredWay;
@property (nonatomic, strong) NSNumber *platformId;

- (NSDictionary *)loadEmail:(NSString *)email nickName:(NSString *)nickName pwd:(NSString *)pwd;

@end
