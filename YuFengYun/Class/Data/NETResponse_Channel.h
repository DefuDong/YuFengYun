//
//  NETResponse_Channel.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-8.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETResponse.h"

@class NETResponse_Channel_Result;
@interface NETResponse_Channel : NETResponse

@property (nonatomic, strong) NSNumber *totalSize;
@property (nonatomic, strong) NSMutableArray *results;

- (void)addResponseDic:(NSDictionary *)dic;

@end




@interface NETResponse_Channel_Result : NETResponse

@property (nonatomic, strong) NSNumber *articleId;            //文章ID
@property (nonatomic, copy) NSString *articleShortTitle;    //文章短标题
@property (nonatomic, copy) NSString *articleRootIn;        //文章来源
@property (nonatomic, copy) NSString *articleDeckblatt;     //文章封面图地址
@property (nonatomic, copy) NSString *articlePublishTime;   //文章发布时间
@property (nonatomic, copy) NSString *articleSynopsis;      //文章简介
@property (nonatomic, strong) NSNumber *articleCommentNum;

@end
