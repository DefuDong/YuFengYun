//
//  NETResponse_SearchArticle.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-9-6.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETResponse.h"

@interface NETResponse_SearchArticle : NETResponse

@property (nonatomic, strong) NSNumber *totalSize;
@property (nonatomic, strong) NSMutableArray *results;

- (void)addResponseDic:(NSDictionary *)dic;

@end




@interface NETResponse_SearchArticle_Result : NETResponse

@property (nonatomic, strong) NSNumber *articleId;
@property (nonatomic, copy) NSString *articleAuthor;//
@property (nonatomic, copy) NSString *articleShortTitle;
@property (nonatomic, copy) NSString *articleContent;//
@property (nonatomic, copy) NSString *articleRootIn;
@property (nonatomic, copy) NSString *articleDeckblatt;
@property (nonatomic, copy) NSString *articlePublishTime;

@end
