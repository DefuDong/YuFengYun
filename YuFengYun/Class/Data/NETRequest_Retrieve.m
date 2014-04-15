//
//  NETRequest_Retrieve.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-7.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETRequest_Retrieve.h"

@implementation NETRequest_Retrieve

- (NSDictionary *)build {
    if (self.userEmail) {
        [self.requestDic setObject:self.userEmail forKey:@"userEmail"];
    }
    
    return self.requestDic;
}

- (NSDictionary *)loadUserEmail:(NSString *)userId {
    self.userEmail = userId;
    return [self build];
}

@end
