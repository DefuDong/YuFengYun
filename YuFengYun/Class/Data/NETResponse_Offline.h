//
//  NETResponse_Offline.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-9-4.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETResponse.h"

@interface NETResponse_Offline : NETResponse

@property (nonatomic, strong) NSArray *channel_1;
@property (nonatomic, strong) NSArray *channel_2;
@property (nonatomic, strong) NSArray *channel_3;
@property (nonatomic, strong) NSArray *channel_4;
@property (nonatomic, strong) NSArray *channel_9;

@property (nonatomic, strong) NSNumber *totalSize_1;
@property (nonatomic, strong) NSNumber *totalSize_2;
@property (nonatomic, strong) NSNumber *totalSize_3;
@property (nonatomic, strong) NSNumber *totalSize_4;
@property (nonatomic, strong) NSNumber *totalSize_9;

@end



@interface NETResponse_Offline_Result : NETResponse

@property (nonatomic, strong) NSNumber *articleId;
@property (nonatomic, copy) NSString *articleContent;
@property (nonatomic, copy) NSString *articleTitle;
@property (nonatomic, copy) NSString *articleShortTitle;
@property (nonatomic, copy) NSString *articleRootIn;
@property (nonatomic, copy) NSString *articleDeckblatt;
@property (nonatomic, copy) NSString *articlePublishTime;
@property (nonatomic, copy) NSString *articleSynopsis;
@property (nonatomic, copy) NSString *formatPublishTime;
@property (nonatomic, strong) NSNumber *articleCommentNum;

@end