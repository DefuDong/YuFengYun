//
//  NETResponse_UserInfo.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-8.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETResponse.h"

@interface NETResponse_Picture : NETResponse

@property (nonatomic, strong) NSNumber *commentNum;
@property (nonatomic, strong) NSNumber *enjoyNum;
@property (nonatomic, strong) NSNumber *favoriteNum;
@property (nonatomic, copy) NSString *favoriteFlag;
@property (nonatomic, copy) NSString *enjoyFlag;
@property (nonatomic, strong) NSNumber *atlasId;            //文章ID
@property (nonatomic, copy) NSString *atlasName;    //文章短标题
@property (nonatomic, copy) NSString *publishTime;        //文章来源
@property (nonatomic, copy) NSString *atlasOrigin;     //文章封面图地址
@property (nonatomic, copy) NSString *atlasSynopsis;   //文章发布时间
@property (nonatomic, copy) NSString *link;

@property (nonatomic, strong) NSMutableArray *pictures;
@property (nonatomic, strong) NSMutableArray *recommendList;

@end


@interface NETResponse_Picture_Pictures : NETResponse

@property (nonatomic, copy) NSString *picUrl;     //文章封面图地址
@property (nonatomic, copy) NSString *picDescription;   //文章发布时间
@property (nonatomic, copy) NSString *attr1;   //文章发布时间

@end


@interface NETResponse_Picture_Recommen : NETResponse

@property (nonatomic, strong) NSNumber *mediaId;            //文章ID
@property (nonatomic, copy) NSString *mediaTitle;    //文章短标题
@property (nonatomic, copy) NSString *mediaDeckblatt;        //文章来源

@end
