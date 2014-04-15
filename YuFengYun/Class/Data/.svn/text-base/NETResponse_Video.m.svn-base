//
//  NETResponse_UserInfo.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-8.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETResponse_Video.h"

@implementation NETResponse_Video

- (void)setResponseDic:(NSDictionary *)responseDic {
    if (_responseDic != responseDic) {
        _responseDic = responseDic;
        
        
        NSArray *resultArr = [_responseDic objectForKey:@"recommendList"];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *resultDic in resultArr) {
            NETResponse_Video_Recommen *result = [[NETResponse_Video_Recommen alloc] init];
            result.responseDic = resultDic;
            
            [arr addObject:result];
        }
        self.recommendList = arr;
        

        self.videoId        = [_responseDic objectForKey:@"videoId"];
        self.videoSynopsis  = [_responseDic objectForKey:@"videoSynopsis"];
        self.videoName      = [_responseDic objectForKey:@"videoName"];
        self.commentNum     = [_responseDic objectForKey:@"commentNum"];
        self.enjoyNum       = [_responseDic objectForKey:@"enjoyNum"];
        self.favoriteNum    = [_responseDic objectForKey:@"favoriteNum"];
        self.favoriteFlag   = [_responseDic objectForKey:@"favoriteFlag"];
        self.enjoyFlag      = [_responseDic objectForKey:@"enjoyFlag"];
        self.videoUrl       = [_responseDic objectForKey:@"videoUrl"];
        self.publishTime    = [_responseDic objectForKey:@"publishTime"];
        self.pv             = [_responseDic objectForKey:@"pv"];
        self.link           = [_responseDic objectForKey:@"link"];
        self.videoLink      = [_responseDic objectForKey:@"videoLink"];
        self.coverPhoto     = [_responseDic objectForKey:@"coverPhoto"];
    }
}

@end


@implementation NETResponse_Video_Recommen

- (void)setResponseDic:(NSDictionary *)responseDic {
    if (_responseDic != responseDic) {
        _responseDic = responseDic;
        
        self.videoId        = [_responseDic objectForKey:@"videoId"];
        self.videoName      = [_responseDic objectForKey:@"videoName"];
        self.coverPhoto     = [_responseDic objectForKey:@"coverPhoto"];
        self.vidDuration    = [_responseDic objectForKey:@"vidDuration"];
    }
}
@end

