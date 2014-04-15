//
//  NETResponse_Collections.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-8.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETResponse.h"

@interface NETResponse_Media_Collections : NETResponse

@property (nonatomic, strong) NSNumber *totalSize;
@property (nonatomic, strong) NSMutableArray *results;

- (void)addResponseDic:(NSDictionary *)dic;

@end




@interface NETResponse_Media_Collections_Result : NETResponse

@property (nonatomic, strong) NSNumber *articleId;            //文章ID
@property (nonatomic, copy) NSString *title;    //文章短标题
@property (nonatomic, copy) NSString *obj;        //文章来源
@property (nonatomic, copy) NSString *objImage;     //文章封面图地址

@end 
