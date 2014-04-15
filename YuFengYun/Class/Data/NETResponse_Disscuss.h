//
//  NETResponse_Disscuss.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-8.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETResponse.h"

@interface NETResponse_Disscuss : NETResponse

@property (nonatomic, strong) NSNumber *totalSize;
@property (nonatomic, strong) NSMutableArray *results;

- (void)addResponseDic:(NSDictionary *)dic;

@end




@interface NETResponse_Disscuss_Result : NETResponse

@property (nonatomic, copy) NSString *commentUserName;
@property (nonatomic, copy) NSString *commentObjUserName;
@property (nonatomic, strong) NSNumber *commentUserId;
@property (nonatomic, strong) NSNumber *commentObjectId;
@property (nonatomic, copy) NSString *commentText;
@property (nonatomic, copy) NSString *commentTime;
@property (nonatomic, copy) NSString *articleShortTitle;
@property (nonatomic, copy) NSString *userIcon;
@property (nonatomic, strong) NSNumber *commentId;
@property (nonatomic, strong) NSNumber *articleId;

@end
