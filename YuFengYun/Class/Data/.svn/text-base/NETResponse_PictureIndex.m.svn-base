//
//  NETResponse_UserInfo.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-8.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETResponse_PictureIndex.h"

@implementation NETResponse_PictureIndex

- (void)setResponseDic:(NSDictionary *)responseDic {
    if (_responseDic != responseDic) {
        _responseDic = responseDic;
        
        NSArray *resultArr = [_responseDic objectForKey:@"results"];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *resultDic in resultArr) {
            NETResponse_PictureIndex_Result *result = [[NETResponse_PictureIndex_Result alloc] init];
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
        NETResponse_PictureIndex_Result *result = [[NETResponse_PictureIndex_Result alloc] init];
        result.responseDic = resultDic;
        
        [self.results addObject:result];
    }
    
    self.totalSize = [_responseDic objectForKey:@"totalSize"];
    
}

@end



@implementation NETResponse_PictureIndex_Result

- (void)setResponseDic:(NSDictionary *)responseDic {
    if (_responseDic != responseDic) {
        _responseDic = responseDic;
        
        self.pics           = [_responseDic objectForKey:@"pics"];
        self.commentNum     = [_responseDic objectForKey:@"commentNum"];
        self.atlasId        = [_responseDic objectForKey:@"atlasId"];
        self.atlasName      = [_responseDic objectForKey:@"atlasName"];
        self.coverPhotoUrl  = [_responseDic objectForKey:@"coverPhotoUrl"];
    }
}
@end