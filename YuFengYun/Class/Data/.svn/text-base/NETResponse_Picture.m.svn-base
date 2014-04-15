//
//  NETResponse_UserInfo.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-8.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETResponse_Picture.h"

@implementation NETResponse_Picture

- (void)setResponseDic:(NSDictionary *)responseDic {
    if (_responseDic != responseDic) {
        _responseDic = responseDic;
        
        NSArray *picArr = [_responseDic objectForKey:@"pictures"];
        NSMutableArray *arr1 = [NSMutableArray array];
        for (NSDictionary *picDic in picArr) {
            NETResponse_Picture_Pictures *pic = [[NETResponse_Picture_Pictures alloc] init];
            pic.responseDic = picDic;
            
            [arr1 addObject:pic];
        }
        self.pictures = arr1;
        
        
        NSArray *resultArr = [_responseDic objectForKey:@"recommendList"];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *resultDic in resultArr) {
            NETResponse_Picture_Recommen *result = [[NETResponse_Picture_Recommen alloc] init];
            result.responseDic = resultDic;
            
            [arr addObject:result];
        }
        self.recommendList = arr;
        

        self.commentNum     = [_responseDic objectForKey:@"commentNum"];
        self.enjoyNum       = [_responseDic objectForKey:@"enjoyNum"];
        self.favoriteNum    = [_responseDic objectForKey:@"favoriteNum"];
        self.favoriteFlag   = [_responseDic objectForKey:@"favoriteFlag"];
        self.enjoyFlag      = [_responseDic objectForKey:@"enjoyFlag"];
        self.atlasId        = [_responseDic objectForKey:@"atlasId"];
        self.atlasName      = [_responseDic objectForKey:@"atlasName"];
        self.publishTime    = [_responseDic objectForKey:@"publishTime"];
        self.atlasOrigin    = [_responseDic objectForKey:@"atlasOrigin"];
        self.atlasSynopsis  = [_responseDic objectForKey:@"atlasSynopsis"];
        self.link           = [_responseDic objectForKey:@"link"];
    }
}

@end


@implementation NETResponse_Picture_Recommen

- (void)setResponseDic:(NSDictionary *)responseDic {
    if (_responseDic != responseDic) {
        _responseDic = responseDic;
        
        self.mediaId            = [_responseDic objectForKey:@"mediaId"];
        self.mediaTitle         = [_responseDic objectForKey:@"mediaTitle"];
        self.mediaDeckblatt     = [_responseDic objectForKey:@"mediaDeckblatt"];
    }
}
@end


@implementation NETResponse_Picture_Pictures

- (void)setResponseDic:(NSDictionary *)responseDic {
    if (_responseDic != responseDic) {
        _responseDic = responseDic;
        
        self.picUrl             = [_responseDic objectForKey:@"picUrl"];
        self.picDescription     = [_responseDic objectForKey:@"picDescription"];
        self.attr1              = [_responseDic objectForKey:@"attr1"];
    }
}
@end