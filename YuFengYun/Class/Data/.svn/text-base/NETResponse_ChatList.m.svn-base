//
//  NETResponse_ChatList.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-9-12.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETResponse_ChatList.h"

@implementation NETResponse_ChatList

- (void)setResponseDic:(NSDictionary *)responseDic {
    if (_responseDic != responseDic) {
        _responseDic = responseDic;
        
        NSArray *resultArr = [_responseDic objectForKey:@"results"];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *resultDic in resultArr) {
            NETResponse_ChatList_Result *result = [[NETResponse_ChatList_Result alloc] init];
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
        NETResponse_ChatList_Result *result = [[NETResponse_ChatList_Result alloc] init];
        result.responseDic = resultDic;
        
        [self.results addObject:result];
    }
    
    self.totalSize = [_responseDic objectForKey:@"totalSize"];
    
}

@end



@implementation NETResponse_ChatList_Result

- (void)setResponseDic:(NSDictionary *)responseDic {
    if (_responseDic != responseDic) {
        _responseDic = responseDic;
        self.letterSendUserId       = [_responseDic objectForKey:@"letterSendUserId"];
        self.letterSendUserName     = [_responseDic objectForKey:@"letterSendUserName"];
        self.letterReceiveUserName  = [_responseDic objectForKey:@"letterReceiveUserName"];
        self.childCount             = [_responseDic objectForKey:@"childCount"];
        self.userIcon               = [_responseDic objectForKey:@"userIcon"];
        self.letterText             = [_responseDic objectForKey:@"letterText"];
        self.letterId               = [_responseDic objectForKey:@"letterId"];
        self.sendTime               = [_responseDic objectForKey:@"sendTime"];
    }
}


@end