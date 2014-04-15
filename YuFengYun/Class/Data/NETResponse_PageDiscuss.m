//
//  NETResponse_PageDiscuss.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-20.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETResponse_PageDiscuss.h"

@implementation NETResponse_PageDiscuss

- (void)setResponseDic:(NSDictionary *)responseDic {
    if (_responseDic != responseDic) {
        _responseDic = responseDic;
        
        NSArray *resultArr = [_responseDic objectForKey:@"results"];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *resultDic in resultArr) {
            NETResponse_PageDiscuss_Result *result = [[NETResponse_PageDiscuss_Result alloc] init];
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
        NETResponse_PageDiscuss_Result *result = [[NETResponse_PageDiscuss_Result alloc] init];
        result.responseDic = resultDic;
        
        [self.results addObject:result];
    }
    
    self.totalSize = [_responseDic objectForKey:@"totalSize"];
    
}


@end



@implementation NETResponse_PageDiscuss_Result

- (void)setResponseDic:(NSDictionary *)responseDic {
    if (_responseDic != responseDic) {
        _responseDic = responseDic;
        self.commentUserName    = [_responseDic objectForKey:@"commentUserName"];
        self.commentObjUserName = [_responseDic objectForKey:@"commentObjUserName"];
        self.commentUserId      = [_responseDic objectForKey:@"commentUserId"];
        self.commentObjectId    = [_responseDic objectForKey:@"commentObjectId"];
        self.commentText        = [_responseDic objectForKey:@"commentText"];
        self.commentTime        = [_responseDic objectForKey:@"commentTime"];
        self.articleShortTitle  = [_responseDic objectForKey:@"articleShortTitle"];
        self.userIcon           = [_responseDic objectForKey:@"userIcon"];
        self.commentId          = [_responseDic objectForKey:@"commentId"];
        self.articleId          = [_responseDic objectForKey:@"articleId"];
        self.commentFloorSign   = [_responseDic objectForKey:@"commentFloorSign"];
    }
}


@end
