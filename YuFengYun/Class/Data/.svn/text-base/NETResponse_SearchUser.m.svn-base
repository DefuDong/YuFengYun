//
//  NETResponse_SearchUser.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-9-6.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETResponse_SearchUser.h"

@implementation NETResponse_SearchUser

- (void)setResponseDic:(NSDictionary *)responseDic {
    if (_responseDic != responseDic) {
        _responseDic = responseDic;
        
        NSArray *resultArr = [_responseDic objectForKey:@"results"];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *resultDic in resultArr) {
            NETResponse_SearchUser_Result *result = [[NETResponse_SearchUser_Result alloc] init];
            result.responseDic = resultDic;
            
            [arr addObject:result];
        }
        
        self.results = arr;
        self.totalSize = [_responseDic objectForKey:@"totalSize"];
    }
}

- (void)addResponseDic:(NSDictionary *)dic {
    
    NSArray *resultArr = [dic objectForKey:@"results"];
    if (!self.results) {
        self.results = [NSMutableArray array];
    }
    
    for (NSDictionary *resultDic in resultArr) {
        NETResponse_SearchUser_Result *result = [[NETResponse_SearchUser_Result alloc] init];
        result.responseDic = resultDic;
        
        [self.results addObject:result];
    }
    
    self.totalSize = [_responseDic objectForKey:@"totalSize"];
    
}


@end



@implementation NETResponse_SearchUser_Result

- (void)setResponseDic:(NSDictionary *)responseDic {
    if (_responseDic != responseDic) {
        _responseDic = responseDic;
        self.userId         = [_responseDic objectForKey:@"userId"];
        self.userNickName   = [_responseDic objectForKey:@"userNickName"];
        self.userIcon       = [_responseDic objectForKey:@"userIcon"];
        self.userSex        = [_responseDic objectForKey:@"userSex"];
        self.userCompany    = [_responseDic objectForKey:@"userCompany"];
        self.userTitle      = [_responseDic objectForKey:@"userTitle"];
    }
}

@end
