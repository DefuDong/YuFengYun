//
//  NETResponse_UserInfo.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-8.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETResponse.h"

@interface NETResponse_PictureIndex : NETResponse

@property (nonatomic, strong) NSNumber *totalSize;
@property (nonatomic, strong) NSMutableArray *results;

- (void)addResponseDic:(NSDictionary *)dic;

@end


@interface NETResponse_PictureIndex_Result : NETResponse

@property (nonatomic, strong) NSNumber *pics;            //文章ID
@property (nonatomic, strong) NSNumber *commentNum;    //文章短标题
@property (nonatomic, strong) NSNumber *atlasId;        //文章来源
@property (nonatomic, copy) NSString *atlasName;     //文章封面图地址
@property (nonatomic, copy) NSString *coverPhotoUrl;   //文章发布时间

@end