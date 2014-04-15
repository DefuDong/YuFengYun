//
//  NETResponse_SearchArticle.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-9-6.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETResponse.h"

@interface NETResponse_SearchMedia : NETResponse

@property (nonatomic, strong) NSNumber *totalSize;
@property (nonatomic, strong) NSMutableArray *results;

- (void)addResponseDic:(NSDictionary *)dic;

@end




@interface NETResponse_SearchMedia_Result : NETResponse

@property (nonatomic, strong) NSNumber *mediaId;
@property (nonatomic, copy) NSString *mediaDeckblatt;
@property (nonatomic, copy) NSString *mediaTitle;
@property (nonatomic, copy) NSString *vidDuration;

@end
