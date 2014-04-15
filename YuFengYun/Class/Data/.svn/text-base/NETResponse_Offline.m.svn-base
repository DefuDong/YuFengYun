//
//  NETResponse_Offline.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-9-4.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETResponse_Offline.h"

@implementation NETResponse_Offline

- (void)setResponseDic:(NSDictionary *)responseDic {
    if (_responseDic != responseDic) {
        _responseDic = responseDic;
        
        /*******************************************************************************************************************/
        NSArray *result_1 = [_responseDic objectForKey:@"1"];
        NSMutableArray *array_1 = [[NSMutableArray alloc] init];
        
        for (NSDictionary *resultDic in result_1) {
            NETResponse_Offline_Result *result = [[NETResponse_Offline_Result alloc] init];
            result.responseDic = resultDic;
            
            [array_1 addObject:result];
        }
        self.channel_1 = array_1;
        self.totalSize_1 = [NSNumber numberWithInteger:array_1.count];

        /*******************************************************************************************************************/
        NSArray *result_2 = [_responseDic objectForKey:@"2"];
        NSMutableArray *array_2 = [[NSMutableArray alloc] init];
        
        for (NSDictionary *resultDic in result_2) {
            NETResponse_Offline_Result *result = [[NETResponse_Offline_Result alloc] init];
            result.responseDic = resultDic;
            
            [array_2 addObject:result];
        }
        
        self.channel_2 = array_2;
        self.totalSize_2 = [NSNumber numberWithInteger:array_2.count];
        
        /*******************************************************************************************************************/
        NSArray *result_3 = [_responseDic objectForKey:@"3"];
        NSMutableArray *array_3 = [[NSMutableArray alloc] init];

        for (NSDictionary *resultDic in result_3) {
            NETResponse_Offline_Result *result = [[NETResponse_Offline_Result alloc] init];
            result.responseDic = resultDic;
            
            [array_3 addObject:result];
        }
        
        self.channel_3 = array_3;
        self.totalSize_3 = [NSNumber numberWithInteger:array_3.count];
        
        /*******************************************************************************************************************/
        NSArray *result_4 = [_responseDic objectForKey:@"4"];
        NSMutableArray *array_4 = [[NSMutableArray alloc] init];

        for (NSDictionary *resultDic in result_4) {
            NETResponse_Offline_Result *result = [[NETResponse_Offline_Result alloc] init];
            result.responseDic = resultDic;
            
            [array_4 addObject:result];
        }
        
        self.channel_4 = array_4;
        self.totalSize_4 = [NSNumber numberWithInteger:array_4.count];
        
        /*******************************************************************************************************************/
        NSArray *result_9 = [_responseDic objectForKey:@"9"];
        NSMutableArray *array_9 = [[NSMutableArray alloc] init];

        for (NSDictionary *resultDic in result_9) {
            NETResponse_Offline_Result *result = [[NETResponse_Offline_Result alloc] init];
            result.responseDic = resultDic;
            
            [array_9 addObject:result];
        }
        
        self.channel_9 = array_9;
        self.totalSize_9 = [NSNumber numberWithInteger:array_9.count];
    }
}


@end



@implementation NETResponse_Offline_Result

- (void)setResponseDic:(NSDictionary *)responseDic {
    if (_responseDic != responseDic) {
        _responseDic = responseDic;
        self.articleId          = [_responseDic objectForKey:@"articleId"];
        self.articleContent     = [_responseDic objectForKey:@"articleContent"];
        self.articleTitle       = [_responseDic objectForKey:@"articleTitle"];
        self.articleShortTitle  = [_responseDic objectForKey:@"articleShortTitle"];
        self.articleRootIn      = [_responseDic objectForKey:@"articleRootIn"];
        self.articleDeckblatt   = [_responseDic objectForKey:@"articleDeckblatt"];
        self.articlePublishTime = [_responseDic objectForKey:@"articlePublishTime"];
        self.articleSynopsis    = [_responseDic objectForKey:@"articleSynopsis"];
        self.formatPublishTime  = [_responseDic objectForKey:@"formatPublishTime"];
        self.articleCommentNum  = [_responseDic objectForKey:@"articleCommentNum"];
    }
}


@end
