//
//  NETRequest_PageDiscuss.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-20.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETRequest.h"

@interface NETRequest_PageDiscuss : NETRequest

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSNumber *articleId;
@property (nonatomic, copy) NSString *commentType;

@property (nonatomic, strong) NSNumber *pageIndex;
@property (nonatomic, strong) NSNumber *pageSize;


- (NSDictionary *)loadUserId:(NSNumber *)userId
                   articleId:(NSNumber *)articleId
                 commentType:(NSString *)commentType
                   pageIndex:(NSNumber *)pageIndex
                    pageSize:(NSNumber *)pageSize;

@end
