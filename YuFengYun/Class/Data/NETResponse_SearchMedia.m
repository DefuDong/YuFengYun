//
//  NETResponse_SearchArticle.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-9-6.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETResponse_SearchMedia.h"

@implementation NETResponse_SearchMedia

- (void)setResponseDic:(NSDictionary *)responseDic {
    if (_responseDic != responseDic) {
        _responseDic = responseDic;
        
        NSArray *resultArr = [_responseDic objectForKey:@"results"];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *resultDic in resultArr) {
            NETResponse_SearchMedia_Result *result = [[NETResponse_SearchMedia_Result alloc] init];
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
        NETResponse_SearchMedia_Result *result = [[NETResponse_SearchMedia_Result alloc] init];
        result.responseDic = resultDic;
        
        [self.results addObject:result];
    }
    
    self.totalSize = [_responseDic objectForKey:@"totalSize"];
    
}


@end



@implementation NETResponse_SearchMedia_Result

- (void)setResponseDic:(NSDictionary *)responseDic {
    if (_responseDic != responseDic) {
        _responseDic = responseDic;
        self.mediaId         = [_responseDic objectForKey:@"mediaId"];
        self.mediaTitle      = [_responseDic objectForKey:@"mediaTitle"];
        self.mediaDeckblatt  = [_responseDic objectForKey:@"mediaDeckblatt"];
        self.vidDuration     = [_responseDic objectForKey:@"vidDuration"];
    }
}

@end









