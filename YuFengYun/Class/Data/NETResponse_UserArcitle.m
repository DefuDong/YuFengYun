//
//  NETResponse_UserArcitle.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-9-9.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETResponse_UserArcitle.h"

@implementation NETResponse_UserArcitle

- (void)setResponseDic:(NSDictionary *)responseDic {
    if (_responseDic != responseDic) {
        _responseDic = responseDic;
        
        NSArray *resultArr = [_responseDic objectForKey:@"results"];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *resultDic in resultArr) {
            NETResponse_UserArcitle_Result *result = [[NETResponse_UserArcitle_Result alloc] init];
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
        NETResponse_UserArcitle_Result *result = [[NETResponse_UserArcitle_Result alloc] init];
        result.responseDic = resultDic;
        
        [self.results addObject:result];
    }
    
    self.totalSize = [_responseDic objectForKey:@"totalSize"];
    
}

@end



@implementation NETResponse_UserArcitle_Result

- (void)setResponseDic:(NSDictionary *)responseDic {
    if (_responseDic != responseDic) {
        _responseDic = responseDic;
        self.articleId          = [_responseDic objectForKey:@"articleId"];
        self.articleShortTitle  = [_responseDic objectForKey:@"articleShortTitle"];
        self.articleRootIn      = [_responseDic objectForKey:@"articleRootIn"];
        self.articleDeckblatt   = [_responseDic objectForKey:@"articleDeckblatt"];
        self.articlePublishTime = [_responseDic objectForKey:@"articlePublishTime"];
        self.articleAuthorName  = [_responseDic objectForKey:@"articleAuthorName"];
    }
}


@end