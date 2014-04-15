//
//  NETResponse_PageDiscuss.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-20.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETResponse.h"

@interface NETResponse_PageDiscuss : NETResponse

@property (nonatomic, strong) NSNumber *totalSize;
@property (nonatomic, strong) NSMutableArray *results;

- (void)addResponseDic:(NSDictionary *)dic;

@end




@interface NETResponse_PageDiscuss_Result : NETResponse

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
@property (nonatomic, strong) NSNumber *commentFloorSign;

@end
