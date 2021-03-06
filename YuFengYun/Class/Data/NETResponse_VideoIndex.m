//
//  NETResponse_UserInfo.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-8.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETResponse_VideoIndex.h"

@implementation NETResponse_VideoIndex

- (void)setResponseDic:(NSDictionary *)responseDic {
    if (_responseDic != responseDic) {
        _responseDic = responseDic;
        
        NSArray *resultArr = [_responseDic objectForKey:@"results"];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *resultDic in resultArr) {
            NETResponse_VideoIndex_Result *result = [[NETResponse_VideoIndex_Result alloc] init];
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
        NETResponse_VideoIndex_Result *result = [[NETResponse_VideoIndex_Result alloc] init];
        result.responseDic = resultDic;
        
        [self.results addObject:result];
    }
    
    self.totalSize = [_responseDic objectForKey:@"totalSize"];
    
}

@end



@implementation NETResponse_VideoIndex_Result

- (void)setResponseDic:(NSDictionary *)responseDic {
    if (_responseDic != responseDic) {
        _responseDic = responseDic;
        
        self.videoId        = [_responseDic objectForKey:@"videoId"];
        self.vidDuration    = [_responseDic objectForKey:@"vidDuration"];
        self.videoName      = [_responseDic objectForKey:@"videoName"];
        self.coverPhoto     = [_responseDic objectForKey:@"coverPhoto"];
        self.pv             = [_responseDic objectForKey:@"pv"];
    }
}
@end