//
//  NETRequest_AddDisscuss.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-7.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETRequest.h"

@interface NETRequest_AddDisscuss : NETRequest

@property (nonatomic, strong) NSNumber *articleId;
@property (nonatomic, strong) NSNumber *commentUserId;
@property (nonatomic, strong) NSNumber *commentObjectId;
@property (nonatomic, copy) NSString *commentText;
@property (nonatomic, copy) NSString *commentType;

- (NSDictionary *)loadArticleId:(NSNumber *)articleId
                  commentUserId:(NSNumber *)commentUserId
                commentObjectId:(NSNumber *)commentObjectId
                   commentText:(NSString *)commentText
                   commentType:(NSString *)commentType;

@end
